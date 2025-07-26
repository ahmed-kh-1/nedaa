import 'package:call/screens/organizations/orgnizations_screen.dart';
import 'package:flutter/material.dart';
import 'package:call/screens/home/home_screen.dart';
import 'package:call/screens/auth/profile_screen.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نداء'),
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'الرئيسية'),
              Tab(text: 'المنظمات'),
              Tab(text: 'حسابي'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            OrganizationsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
