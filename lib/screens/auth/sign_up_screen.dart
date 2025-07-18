import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call/providers/auth_provider.dart';

// تعريف التعداد في نفس الملف لتجنب مشاكل الاستيراد
enum UserType { user, association }

// ودجيت اختيار نوع الحساب (تم نقله إلى نفس الملف)
class AccountTypeSelector extends StatelessWidget {
  final UserType selected;
  final Function(UserType?)? onChanged;

  const AccountTypeSelector({
    super.key,
    required this.selected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<UserType>(
            title: const Text('مستخدم'),
            value: UserType.user,
            groupValue: selected,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: RadioListTile<UserType>(
            title: const Text('منظمة'),
            value: UserType.association,
            groupValue: selected,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  UserType userType = UserType.user;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.signUp(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        accountType: userType == UserType.user ? "user" : "association",
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("تم إنشاء الحساب بنجاح"),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("فشل التسجيل: ${e.toString()}"),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = userType == UserType.user;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 85, 175, 195),
              Color.fromARGB(255, 85, 175, 195),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار مع التأثير
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 58, 158, 183)
                            .withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // البطاقة البيضاء
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "إنشاء حساب",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // اختيار نوع الحساب
                          AccountTypeSelector(
                            selected: userType,
                            onChanged: (val) => setState(() => userType = val!),
                          ),
                          const SizedBox(height: 2),

                          // حقل الاسم
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText:
                                    isUser ? 'اسم المستخدم' : 'اسم الجمعية',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الاسم';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // حقل الإيميل
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال البريد الإلكتروني';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'بريد إلكتروني غير صالح';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // حقل كلمة المرور
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() =>
                                        _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
                                }
                                if (value.length < 6) {
                                  return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 25),

                          // زر التسجيل
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 58, 158, 183),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      "تسجيل",
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
