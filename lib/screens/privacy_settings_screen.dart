import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showOnlineStatus = true;
  bool _allowMessagesFromAnyone = true;
  bool _showActivityStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمان والخصوصية'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات الخصوصية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPrivacySwitch(
              'إظهار حالة الاتصال',
              'عرض حالتك عبر الإنترنت للأعضاء الآخرين',
              _showOnlineStatus,
              (value) => setState(() => _showOnlineStatus = value!),
            ),
            _buildPrivacySwitch(
              'السماح بالرسائل من الجميع',
              'السماح لأي عضو بإرسال رسائل إليك',
              _allowMessagesFromAnyone,
              (value) => setState(() => _allowMessagesFromAnyone = value!),
            ),
            _buildPrivacySwitch(
              'إظهار حالة النشاط',
              'عرض آخر نشاط لك في التطبيق',
              _showActivityStatus,
              (value) => setState(() => _showActivityStatus = value!),
            ),
            const SizedBox(height: 24),
            const Text(
              'إعدادات الأمان',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('الأجهزة المتصلة'),
              subtitle: const Text('إدارة الأجهزة التي تم تسجيل الدخول منها'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('سجل النشاط'),
              subtitle: const Text('عرض جميع أنشطة الحساب'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySwitch(
      String title, String subtitle, bool value, Function(bool?) onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }
}
