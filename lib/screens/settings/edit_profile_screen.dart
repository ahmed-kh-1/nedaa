import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call/widgets/settings/delete_account_button.dart';
import 'package:call/widgets/settings/delete_account_dialog.dart';
import 'package:call/widgets/settings/save_button.dart';
import 'package:call/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الجوال'),
                validator: _validatePhone,
              ),
              const SizedBox(height: 24),
              SaveButton(onPressed: _saveProfile),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              DeleteAccountButton(onPressed: _showDeleteAccountDialog),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
    if (!value.contains('@')) return 'البريد الإلكتروني غير صالح';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال رقم الجوال';
    if (value.length < 10) return 'رقم الجوال يجب أن يكون 10 أرقام على الأقل';
    return null;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userProvider = context.read<UserProvider>();
      final updatedUser = userProvider.currentUser?.copyWith(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      if (updatedUser != null) {
        userProvider.updateUserInfo(
          fullName: updatedUser.fullName,
          phone: updatedUser.phone,
          avatarUrl: updatedUser.avatarUrl,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
      );
      Navigator.pop(context);
    }
  }

  void _showDeleteAccountDialog() => showDialog(
        context: context,
        builder: (context) => DeleteAccountDialog(deleteAction: _deleteAccount),
      );

  void _deleteAccount() {
    Navigator.pop(context); // Close dialog
    Navigator.pop(context); // Return to previous screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف الحساب بنجاح')),
    );
    // TODO: Actual delete logic would go here
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
