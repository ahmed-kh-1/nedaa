// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAdmin = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _associationCodeController =
      TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Perform login logic here
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ألوان راقية ثابتة
// أزرق أنيق
// بنفسجي راقي
    const backgroundColor = Color(0xFFF5F7FF); // خلفية فاتحة أنيقة
    const cardColor = Colors.white; // أبيض نقي
    const textColor = Color(0xFF333333); // لون نص غامق

    // تحديد الألوان بناءً على نوع المستخدم
    final primaryColor = _isAdmin
        ? const Color.fromARGB(255, 39, 160, 176)
        : const Color.fromARGB(255, 55, 124, 155);
    final gradientColors = _isAdmin
        ? [
            const Color.fromARGB(255, 39, 160, 176),
            const Color.fromARGB(255, 55, 124, 155)
          ] // تدرج بنفسجي
        : [
            const Color.fromARGB(255, 39, 160, 176),
            const Color.fromARGB(255, 55, 124, 155)
          ]; // تدرج أزرق

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isAdmin ? Icons.verified_user : Icons.person,
                      size: 60,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // عنوان التطبيق
                  Text(
                    "نداء".tr(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // رسالة ترحيبية
                  Text(
                    _isAdmin ? "welcome_admin".tr() : "welcome_user".tr(),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // بطاقة اختيار النوع
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isAdmin ? "user_admin".tr() : "user_normal".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Switch(
                            value: _isAdmin,
                            onChanged: (value) {
                              setState(() {
                                _isAdmin = value;
                              });
                            },
                            activeColor: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // حقل البريد الإلكتروني
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cardColor,
                      prefixIcon: Icon(Icons.email, color: primaryColor),
                      labelText: "email_hint".tr(),
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "email_validation".tr();
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // حقل كلمة المرور
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cardColor,
                      prefixIcon: Icon(Icons.lock, color: primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      labelText: "password_hint".tr(),
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "password_validation".tr();
                      }
                      if (value.length < 6) {
                        return "password_length_validation".tr();
                      }
                      return null;
                    },
                  ),

                  // حقل كود الجمعية للمدراء
                  if (_isAdmin) ...[
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _associationCodeController,
                      style: const TextStyle(color: textColor),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: cardColor,
                        prefixIcon: Icon(Icons.business, color: primaryColor),
                        labelText: "association_code_hint".tr(),
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 20),
                      ),
                      validator: (value) {
                        if (_isAdmin && (value == null || value.isEmpty)) {
                          return "association_code_validation".tr();
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 30),

                  // زر تسجيل الدخول
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "login_button".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // روابط إضافية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // الانتقال لاستعادة كلمة المرور
                        },
                        child: Text(
                          "forgot_password".tr(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // الانتثار لإنشاء حساب جديد
                        },
                        child: Text(
                          "create_account".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
