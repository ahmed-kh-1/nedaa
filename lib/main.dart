import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:call/providers/auth_provider.dart';
import 'package:call/providers/organization_provider.dart';
import 'package:call/screens/auth/sign_in_screen.dart';
import 'package:call/screens/auth/sign_up_screen.dart';
import 'package:call/screens/create_post_page.dart';
import 'package:call/screens/home/home_screen.dart';
import 'package:call/screens/home/main_tab_screen.dart';
import 'package:call/screens/organizations/add_orgnization_screen.dart';
import 'package:call/screens/organizations/orgnizations_screen.dart';
import 'package:call/screens/splash_screen.dart';
import 'package:call/services/supabase_service.dart';
import 'package:call/settings/theme_notifier.dart';
import 'package:call/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseService.supabaseUrl,
    anonKey: SupabaseService.supabaseAnonKey,
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
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        return const Locale('ar');
      },
      title: 'نداء',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-post': (context) => const CreatePostScreen(),
        '/add-organization': (context) => const AddOrganizationScreen(),
        '/organizations': (context) => const OrganizationsScreen(),
        '/main-tab': (context) => const MainTabScreen(),
      },
    );
  }
}
