import 'package:call/screens/change_password_screen.dart'
    show ChangePasswordScreen;
import 'package:call/screens/edit_profile_screen.dart' show EditProfileScreen;
import 'package:call/screens/privacy_settings_screen.dart'
    show PrivacySettingsScreen;
import 'package:flutter/material.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الحساب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSettingCard(
              'معلومات الحساب',
              [
                _buildSettingItem(
                  context,
                  Icons.person,
                  'تعديل الملف الشخصي',
                  const EditProfileScreen(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSettingCard(
              'الأمان',
              [
                _buildSettingItem(
                  context,
                  Icons.lock,
                  'تغيير كلمة المرور',
                  const ChangePasswordScreen(),
                ),
                _buildSettingItem(
                  context,
                  Icons.security,
                  'الأمان والخصوصية',
                  const PrivacySettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(String title, List<Widget> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const Divider(height: 1),
            Column(children: items),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
