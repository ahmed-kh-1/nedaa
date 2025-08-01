import 'package:call/widgets/settings/password_button.dart';
import 'package:call/widgets/settings/password_form_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير كلمة المرور'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordFormField(
                controller: _currentPasswordController,
                label: 'كلمة المرور الحالية',
                obscureText: _obscureCurrentPassword,
                prefixIcon: Icons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الحالية';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
                onToggleVisibility: () => setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                }),
              ),
              const SizedBox(height: 16),
              PasswordFormField(
                controller: _newPasswordController,
                label: 'كلمة المرور الجديدة',
                obscureText: _obscureNewPassword,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الجديدة';
                  }
                  if (value.length < 8) {
                    return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                  }
                  return null;
                },
                onToggleVisibility: () => setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                }),
              ),
              const SizedBox(height: 16),
              PasswordFormField(
                controller: _confirmPasswordController,
                label: 'تأكيد كلمة المرور الجديدة',
                obscureText: _obscureConfirmPassword,
                prefixIcon: Icons.lock_reset,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة المرور الجديدة';
                  }
                  if (value != _newPasswordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
                onToggleVisibility: () => setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                }),
              ),
              const SizedBox(height: 24),
              PasswordButton(
                onPressed: () => _changePassword(context),
                label: 'تغيير كلمة المرور',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
