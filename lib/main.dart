import 'package:call/screens/create_post_page.dart';
import 'package:call/screens/home_screen.dart';
import 'package:call/screens/settings_screen.dart';
import 'package:call/settings/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call/theme/app_themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نداء',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {
        '/create-post': (context) => const CreatePostScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
