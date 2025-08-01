import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call/settings/theme_notifier.dart';

class ThemeSettingItem extends StatelessWidget {
  const ThemeSettingItem({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return SwitchListTile(
      title: const Text('الوضع المظلم'),
      value: themeNotifier.isDark,
      onChanged: (value) => themeNotifier.toggleTheme(),
      secondary: const Icon(Icons.dark_mode),
    );
  }
}
