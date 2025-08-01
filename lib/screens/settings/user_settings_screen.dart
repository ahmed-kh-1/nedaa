import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:call/screens/auth/change_password_screen.dart';
import 'package:call/screens/settings/edit_profile_screen.dart';
import 'package:call/screens/settings/privacy_settings_screen.dart';
import 'package:call/settings/theme_notifier.dart';
import 'package:call/widgets/settings/settings_card.dart';
import 'package:call/widgets/settings/setting_item.dart';
import 'package:call/widgets/settings/theme_setting_item.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الحساب'),
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : null,
        iconTheme: IconThemeData(color: isDark ? Colors.white : null),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : null,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            SettingsCard(
              title: 'معلومات الحساب',
              items: [
                SettingItem(
                  icon: Icons.person,
                  title: 'تعديل الملف الشخصي',
                  destination: EditProfileScreen(),
                ),
              ],
            ),
            SizedBox(height: 20),
            SettingsCard(
              title: 'الأمان',
              items: [
                SettingItem(
                  icon: Icons.lock,
                  title: 'تغيير كلمة المرور',
                  destination: ChangePasswordScreen(),
                ),
                SettingItem(
                  icon: Icons.security,
                  title: 'الأمان والخصوصية',
                  destination: PrivacySettingsScreen(),
                ),
              ],
            ),
            SizedBox(height: 20),
            SettingsCard(
              title: 'المظهر',
              items: [ThemeSettingItem()],
            ),
          ],
        ),
      ),
    );
  }
}
