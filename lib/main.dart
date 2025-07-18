import 'package:call/providers/auth_provider.dart';
import 'package:call/providers/organization_provider.dart';
import 'package:call/screens/auth/sign_in_screen.dart';
import 'package:call/screens/auth/sign_up_screen.dart';
import 'package:call/screens/organizations/add_orgnization_screen.dart';
import 'package:call/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:call/screens/create_post_page.dart';
import 'package:call/screens/home_screen.dart';

// Theme management
import 'package:call/settings/theme_notifier.dart';
import 'package:call/theme/app_themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iwqhhnnbdlzzjsboyufq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3cWhobm5iZGx6empzYm95dWZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1MjE0MTgsImV4cCI6MjA2ODA5NzQxOH0.ZSjjCaKKGB0XLFPDo6XGD9Yp-TSV4bY5dyOuzJCGQvA',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrganizationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نداء',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/add-organization',
      routes: {
        // '/': (context) => const SplashScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-post': (context) => const CreatePostScreen(),
        '/add-organization': (context) => const AddOrganizationScreen(),
      },
    );
  }
}
