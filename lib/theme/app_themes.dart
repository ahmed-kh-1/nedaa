import 'package:flutter/material.dart';

class AppTheme {
  // ------ Colors ------ //
  static const Color primaryColor =
      Color.fromRGBO(33, 133, 173, 1); // بنفسجي داكن
  static const Color secondaryColor =
      Color.fromARGB(255, 5, 62, 103); // بنفسجي فاتح
  static const Color accentColor = Color(0xFF212121); // أسود
  static const Color backgroundColor = Color(0xFFF5F5F5); // خلفية فاتحة
  static const Color cardColor = Color(0xFFFFFFFF); // أبيض للكروت
  static const Color errorColor = Color(0xFFD32F2F); // أحمر للخطأ
  static const Color successColor = Color(0xFF388E3C); // أخضر للنجاح

  // ------ Button Styles ------ //
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );

  // ------ Light Theme ------ //
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        surface: cardColor,
        onSurface: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
    );
  }

  // ------ Dark Theme ------ //
  static ThemeData darkTheme() {
    const Color darkBackground = Color(0xFF121212);
    const Color darkCard = Color(0xFF1E1E1E);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        surface: darkCard,
        onSurface: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
    );
  }
}
