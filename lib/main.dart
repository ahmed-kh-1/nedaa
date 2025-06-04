import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

// الشاشات
import 'package:call/screens/create_post_page.dart';
import 'package:call/screens/home_screen.dart';

// إدارة الثيم
import 'package:call/settings/theme_notifier.dart';
import 'package:call/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar')],
      path: 'assets/lang', // مسار ملفات الترجمة
      fallbackLocale: const Locale('ar'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء حالة الوضع الليلي من ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نداء',

      // الثيمات المخصصة
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,

      // الشاشة الرئيسية
      home: const HomeScreen(),

      // التوجيه بين الصفحات
      routes: {
        '/create-post': (context) => const CreatePostScreen(),
      },

      // إعدادات الترجمة
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
