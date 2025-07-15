import 'package:flutter/material.dart';
import '../reports_screen.dart';
import '../saved_screen.dart';
import '../user_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
            ),
            const SizedBox(height: 16), 
            const Text(
              ' Ghina Alhosni',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildProfileItem(
              context,
              icon: Icons.history,
              title: 'بلاغاتي السابقة',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              ),
            ),
            _buildProfileItem(
              context,
              icon: Icons.favorite,
              title: 'المحفوظات',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedScreen()),
              ),
            ),
            _buildProfileItem(
              context,
              icon: Icons.settings,
              title: 'الإعدادات',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserSettingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
