import 'package:call/providers/user_provider.dart';
import 'package:call/services/location_service.dart';
import 'package:call/widgets/posts/description_text_field.dart';
import 'package:call/widgets/posts/emergency_type_dropdown.dart';
import 'package:call/widgets/posts/image_picker_card.dart';
import 'package:call/widgets/posts/location_text_field.dart';
import 'package:call/models/post_model.dart';
import 'package:call/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  final PostModel? initialPost;
  const CreatePostScreen({super.key, this.initialPost});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedType = 'حالة طارئة';
  File? _selectedImage;
  String? _existingImageUrl; // for edit mode existing image
  bool _isLocating = false; // loading state for fetching current location only

  final List<String> _emergencyTypes = [
    'حالة طارئة',
    'حريق',
    'حادث مروري',
    'حالة صحية'
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initialPost;
    if (p != null) {
      _descriptionController.text = p.postText;
      _locationController.text = p.locationUrl;
      _existingImageUrl = p.imageUrl;
      // map stored type to dropdown label
      switch (p.postType) {
        case 'fire':
          _selectedType = 'حريق';
          break;
        case 'accident':
          _selectedType = 'حادث مروري';
          break;
        case 'health':
          _selectedType = 'حالة صحية';
          break;
        default:
          _selectedType = 'حالة طارئة';
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLocating = true);
      LocationService locationService = LocationService();
      final locationLink = await locationService.getLocationLink();
      setState(() {
        _locationController.text = locationLink!;
      });
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في تحديد الموقع: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _chooseImageSource() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('التقاط صورة بالكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitReport(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.loadUser();

    // جلب بيانات المستخدم الحالي
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'فشل في إرسال البلاغ: لم يتم العثور على بيانات المستخدم'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // if editing
    final bool isEditing = widget.initialPost != null;

    try {
      if (isEditing) {
        // build updated post
        final updated = widget.initialPost!.copyWith(
          postText: _descriptionController.text,
          postType: _selectedType == 'حالة طارئة'
              ? 'emergency'
              : _selectedType == 'حريق'
                  ? 'fire'
                  : _selectedType == 'حادث مروري'
                      ? 'accident'
                      : 'health',
          // if user removed existing image and didn't add new one
          imageUrl: (_selectedImage == null) ? _existingImageUrl : widget.initialPost!.imageUrl,
          locationUrl: _locationController.text,
        );

        await postProvider.updatePost(widget.initialPost!.postId, updated, image: _selectedImage);
      } else {
        // إنشاء البلاغ الجديد باستخدام بيانات المستخدم
        final newPost = PostModel(
          postId: '',
          posterName: currentUser.fullName ?? "مجهول", // من UserProvider
          posterId: currentUser.id, // من UserProvider
          postText: _descriptionController.text,
          postType: _selectedType == 'حالة طارئة'
              ? 'emergency'
              : _selectedType == 'حريق'
                  ? 'fire'
                  : _selectedType == 'حادث مروري'
                      ? 'accident'
                      : 'health',
          isAdopted: false,
          imageUrl: null, // سيتم تحديثها بعد رفع الصورة
          locationUrl: _locationController.text,
          createdAt: DateTime.now(),
        );
        await postProvider.addPost(newPost, image: _selectedImage);
      }

      if (postProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'تم حفظ التعديلات' : 'تم إرسال البلاغ بنجاح'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );

        if (isEditing) {
          Navigator.pop(context, true);
        } else {
          // مسح الحقول
          _descriptionController.clear();
          _locationController.clear();
          setState(() {
            _selectedImage = null;
            _existingImageUrl = null;
            _selectedType = 'حالة طارئة';
          });
          // العودة للخلف
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إرسال البلاغ: ${postProvider.errorMessage}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في إرسال البلاغ: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialPost == null ? 'إنشاء بلاغ جديد' : 'تعديل البلاغ',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // For edit mode: show existing network image if present and no new image selected
                          if (_selectedImage == null && _existingImageUrl != null)
                            GestureDetector(
                              onTap: _chooseImageSource,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        _existingImageUrl!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _existingImageUrl = null),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ImagePickerCard(
                              selectedImage: _selectedImage,
                              onChooseImage: _chooseImageSource,
                              onRemoveImage: () => setState(() => _selectedImage = null),
                            ),
                          const SizedBox(height: 24),
                          EmergencyTypeDropdown(
                            selectedType: _selectedType,
                            emergencyTypes: _emergencyTypes,
                            onChanged: (value) =>
                                setState(() => _selectedType = value!),
                          ),
                          const SizedBox(height: 24),
                          DescriptionTextField(
                            controller: _descriptionController,
                          ),
                          const SizedBox(height: 24),
                          LocationTextField(
                            controller: _locationController,
                            isLoading: _isLocating,
                            onGetLocation: _getCurrentLocation,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: postProvider.isLoading
                            ? null
                            : () => _submitReport(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 2,
                        ),
                        child: postProvider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                widget.initialPost == null ? 'إرسال البلاغ' : 'حفظ التعديل',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
