import 'package:flutter/material.dart';
import 'package:call/widgets/settings/delete_account_button.dart';
import 'package:call/widgets/settings/delete_account_dialog.dart';
import 'package:call/widgets/settings/save_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'user@example.com');
  final _phoneController = TextEditingController(text: '+966501234567');

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
              // AccountTextField(
              //   controller: _emailController,
              //   label: 'البريد الإلكتروني',
              //   icon: Icons.email,
              //   keyboardType: TextInputType.emailAddress,
              //   validator: _validateEmail,
              // ),
              // const SizedBox(height: 16),
              // AccountTextField(
              //   controller: _phoneController,
              //   label: 'رقم الجوال',
              //   icon: Icons.phone,
              //   keyboardType: TextInputType.phone,
              //   validator: _validatePhone,
              // ),
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
    // Actual delete logic would go here
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
