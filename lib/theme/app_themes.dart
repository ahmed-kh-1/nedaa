import 'package:flutter/material.dart';

class AppTheme {
  // ------ Colors ------ //
  static const Color primaryColor =
      Color(0xFFFF6F00); // برتقالي قوي (Amber 800)
  static const Color secondaryColor =
      Color(0xFFFFA726); // برتقالي فاتح (Amber 400)
  static const Color accentColor = Color(0xFF424242); // رمادي غامق للنصوص
  static const Color backgroundColor =
      Color(0xFFFDF6F0); // خلفية فاتحة مائلة للبرتقالي
  static const Color cardColor = Color(0xFFFFFFFF); // أبيض للكروت
  static const Color errorColor = Color(0xFFD32F2F); // أحمر للخطأ
  static const Color successColor = Color(0xFF2E7D32); // أخضر للنجاح

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
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
