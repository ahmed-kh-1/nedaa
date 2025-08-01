import 'dart:developer';
import 'package:call/services/location_service.dart';
import 'package:call/widgets/posts/description_text_field.dart';
import 'package:call/widgets/posts/emergency_type_dropdown.dart';
import 'package:call/widgets/posts/image_picker_card.dart';
import 'package:call/widgets/posts/location_text_field.dart';
import 'package:call/widgets/posts/create_post_submit_button.dart';
import 'package:call/models/post_model.dart';
import 'package:call/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedType = 'حالة طارئة';
  File? _selectedImage;

  final List<String> _emergencyTypes = [
    'حالة طارئة',
    'حريق',
    'حادث مروري',
    'حالة صحية'
  ];

  Future<void> _getCurrentLocation() async {
    try {
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

    // Create a new post model
    final newPost = PostModel(
      postId: '',
      posterName: '', // Leave empty as requested
      posterId: '', // Will be set by the service
      postText: _descriptionController.text,
      postType: _selectedType == 'حالة طارئة'
          ? 'emergency'
          : _selectedType == 'حريق'
              ? 'fire'
              : _selectedType == 'حادث مروري'
                  ? 'accident'
                  : 'health',
      isAdopted: false,
      imageUrl: null, // Will be updated after image upload
      locationUrl: _locationController.text,
      createdAt: DateTime.now(),
    );

    try {
      await postProvider.addPost(newPost, image: _selectedImage);

      if (postProvider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إرسال البلاغ بنجاح'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );

        // Clear form
        _descriptionController.clear();
        _locationController.clear();
        setState(() {
          _selectedImage = null;
          _selectedType = 'حالة طارئة';
        });

        // Navigate back
        Navigator.pop(context);
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
        title: const Text(
          'إنشاء بلاغ جديد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColorDark,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ImagePickerCard(
                      selectedImage: _selectedImage,
                      onChooseImage: _chooseImageSource,
                      onRemoveImage: () =>
                          setState(() => _selectedImage = null),
                    ),
                    const SizedBox(height: 25),
                    EmergencyTypeDropdown(
                      selectedType: _selectedType,
                      emergencyTypes: _emergencyTypes,
                      onChanged: (value) =>
                          setState(() => _selectedType = value!),
                    ),
                    const SizedBox(height: 25),
                    DescriptionTextField(
                      controller: _descriptionController,
                    ),
                    const SizedBox(height: 25),
                    LocationTextField(
                      controller: _locationController,
                      isLoading: postProvider.isLoading,
                      onGetLocation: _getCurrentLocation,
                    ),
                    const SizedBox(height: 30),
                    SubmitButton(
                      isLoading: postProvider.isLoading,
                      onSubmit: () => _submitReport(context),
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
