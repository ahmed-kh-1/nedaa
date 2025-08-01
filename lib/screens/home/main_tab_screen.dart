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
    final surfaceColor = theme.colorScheme.surface;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نداء'),
          centerTitle: true,
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: onPrimaryColor,
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            tabs: [
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
