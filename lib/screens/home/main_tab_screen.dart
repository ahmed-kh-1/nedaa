import 'package:call/screens/home/home_screen.dart';
import 'package:call/screens/organizations/orgnizations_screen.dart';
import 'package:call/screens/settings/profile_screen.dart';
import 'package:flutter/material.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final surfaceColor = theme.scaffoldBackgroundColor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: surfaceColor,
        appBar: AppBar(
          title: const Text('نداء',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          actions: [
            Icon(Icons.notifications, color: onPrimaryColor),
            const SizedBox(width: 16),
          ],
          backgroundColor: surfaceColor,
          bottom: TabBar(
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelColor: primaryColor,
            unselectedLabelColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.6),
            tabs: const [
              Tab(icon: Icon(Icons.home_rounded), text: 'الرئيسية'),
              Tab(
                  icon: Icon(Icons.health_and_safety_rounded),
                  text: 'المنظمات'),
              Tab(icon: Icon(Icons.person_rounded), text: 'الملف الشخصي'),
            ],
          ),
        ),
        body: Container(
          color: surfaceColor,
          child: const TabBarView(
            children: [
              HomeScreen(),
              OrganizationsScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
