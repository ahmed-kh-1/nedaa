import 'package:call/settings/help_page.dart' show HelpPage;
import 'package:call/settings/privacy_page.dart' show PrivacyPage;
import 'package:call/settings/theme_notifier.dart' show ThemeNotifier;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('الوضع المظلم'),
            value: isDark,
            onChanged: (value) => themeNotifier.toggleTheme(),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('الخصوصية والأمان'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('المساعدة'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpPage()),
            ),
          ),
        ],
      ),
    );
  }
}
