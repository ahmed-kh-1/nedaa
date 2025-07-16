import 'package:call/providers/auth_provider.dart';
import 'package:call/widgets/auth/account_type_selector.dart';
import 'package:call/widgets/auth/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserType userType = UserType.user;

  void _signup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    debugPrint("signUp");
    try {
      await auth.signUp(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          accountType: userType == UserType.user ? "user" : "association");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم إنشاء الحساب بنجاح"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("فشل التسجيل: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = userType == UserType.user;

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserTypeSelector(
              selected: userType,
              onChanged: (val) => setState(() => userType = val!),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: isUser ? 'اسم المستخدم' : 'اسم الجمعية',
              controller: nameController,
            ),
            const SizedBox(height: 12),
            AuthTextField(label: 'الإيميل', controller: emailController),
            const SizedBox(height: 12),
            AuthTextField(
              label: 'كلمة المرور',
              controller: passwordController,
              obscure: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('تسجيل'),
            ),
          ],
        ),
      ),
    );
  }
}
