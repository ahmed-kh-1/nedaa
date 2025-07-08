// splash_screen.dart
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:call/settings/theme_notifier.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _gradientAnimation;

  final List<Bubble> bubbles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // إنشاء فقاعات عشوائية للخلفية
    for (int i = 0; i < 15; i++) {
      bubbles.add(Bubble(
        size: random.nextDouble() * 40 + 10,
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: random.nextDouble() * 0.5 + 0.1,
        color: Colors.white.withOpacity(random.nextDouble() * 0.3 + 0.1),
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF6A11CB),
      end: const Color(0xFF2575FC),
    ).animate(_controller);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // تحديث الفقاعات باستمرار
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted) {
        setState(() {
          for (var bubble in bubbles) {
            bubble.update();
          }
        });
      } else {
        timer.cancel();
      }
    });

    // الانتقال لشاشة تسجيل الدخول بعد 5 ثوانٍ
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDark;

    // تحديد الألوان بناءً على الوضع الحالي (ليلي/نهاري)
    final lightColors = [
      const Color.fromARGB(255, 17, 200, 203),
      const Color.fromARGB(255, 69, 124, 218),
      const Color(0xFF2AF598),
      const Color(0xFF009EFD),
    ];

    final darkColors = [
      const Color(0xFF0F2027),
      const Color(0xFF203A43),
      const Color(0xFF2C5364),
    ];

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // خلفية متدرجة متحركة
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    startAngle: 0,
                    endAngle: _gradientAnimation.value * 2 * pi,
                    colors: isDarkMode ? darkColors : lightColors,
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),

              // فقاعات متحركة
              ...bubbles.map((bubble) {
                return Positioned(
                  left: bubble.x * MediaQuery.of(context).size.width,
                  top: bubble.y * MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: bubble.color.opacity,
                    child: Container(
                      width: bubble.size,
                      height: bubble.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bubble.color,
                        boxShadow: [
                          BoxShadow(
                            color: bubble.color.withOpacity(0.8),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // محتوى مركزي
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة الاتصال مع تأثيرات متعددة
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * pi,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              stops: const [0.1, 0.8],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _colorAnimation.value!.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.call,
                            size: 100,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // نص متحرك
                    ScaleTransition(
                      scale: _textScaleAnimation,
                      child: Text(
                        'نداء'.tr(), // استخدام الترجمة
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 50,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // شريط تقدم
                    Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.8),
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Bubble {
  double size;
  double x;
  double y;
  double speed;
  double direction;
  Color color;

  Bubble({
    required this.size,
    required this.x,
    required this.y,
    required this.speed,
    required this.color,
  }) : direction = 2 * pi * Random().nextDouble();

  void update() {
    x += 0.005 * cos(direction);
    y -= speed * 0.01;

    if (y < -0.2) {
      y = 1.2;
      x = Random().nextDouble();
    }
  }
}
