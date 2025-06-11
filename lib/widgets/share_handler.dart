import 'package:flutter/material.dart';

class ShareHandler {
  static void showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _ShareOptionsBottomSheet(),
    );
  }

  static void _shareViaMessages(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري فتح تطبيق الرسائل...')),
    );
  }

  static void _shareViaEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري فتح تطبيق البريد الإلكتروني...')),
    );
  }

  static void _shareViaWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري فتح تطبيق WhatsApp...')),
    );
  }
}

class _ShareOptionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'مشاركة المنشور',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildShareOptionTile(
            icon: Icons.link,
            color: Colors.blue,
            label: 'نسخ الرابط',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ الرابط')),
              );
            },
          ),
          _buildShareOptionTile(
            icon: Icons.message,
            color: Colors.green,
            label: 'مشاركة عبر الرسائل',
            onTap: () {
              Navigator.pop(context);
              ShareHandler._shareViaMessages(context);
            },
          ),
          _buildShareOptionTile(
            icon: Icons.more_horiz,
            label: 'خيارات أخرى',
            onTap: () {
              Navigator.pop(context);
              _MoreShareOptionsBottomSheet.show(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.grey,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _MoreShareOptionsBottomSheet extends StatelessWidget {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _MoreShareOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'خيارات مشاركة إضافية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildShareOptionTile(
            icon: Icons.email,
            color: Colors.red,
            label: 'مشاركة عبر البريد الإلكتروني',
            onTap: () {
              Navigator.pop(context);
              ShareHandler._shareViaEmail(context);
            },
          ),
          _buildShareOptionTile(
            icon: Icons.chat,
            color: Colors.green,
            label: 'مشاركة عبر WhatsApp',
            onTap: () {
              Navigator.pop(context);
              ShareHandler._shareViaWhatsApp(context);
            },
          ),
          _buildShareOptionTile(
            icon: Icons.social_distance,
            color: Colors.blue,
            label: 'مشاركة عبر وسائل التواصل الاجتماعي',
            onTap: () {
              Navigator.pop(context);
              _SocialMediaShareSheet.show(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _SocialMediaShareSheet extends StatelessWidget {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SocialMediaShareSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'اختر منصة التواصل الاجتماعي',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSocialMediaRow(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSocialMediaRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialMediaButton(
          icon: Icons.facebook,
          color: Colors.blue,
          label: 'Facebook',
          onPressed: () => _showPlatformMessage(context, 'Facebook'),
        ),
        _buildSocialMediaButton(
          icon: Icons.camera_alt,
          color: Colors.purple,
          label: 'Instagram',
          onPressed: () => _showPlatformMessage(context, 'Instagram'),
        ),
        _buildSocialMediaButton(
          icon: Icons.chat_bubble,
          color: Colors.lightBlue,
          label: 'Twitter',
          onPressed: () => _showPlatformMessage(context, 'Twitter'),
        ),
      ],
    );
  }

  Widget _buildSocialMediaButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 40),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

  void _showPlatformMessage(BuildContext context, String platform) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('جاري فتح $platform...')),
    );
  }
}
