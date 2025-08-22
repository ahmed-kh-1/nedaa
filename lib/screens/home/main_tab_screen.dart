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
    final surfaceColor = theme.colorScheme.surface;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: surfaceColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: surfaceColor,
          title: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'نداء',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
                fontSize: 32, // أكبر شوي ليعطي حضور
                shadows: [
                  Shadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    offset: const Offset(1, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Handle notifications
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 28,
                    color: theme.colorScheme.onSurface,
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: surfaceColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              tooltip: 'الإشعارات',
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight + 8),
            child: Column(
              children: [
                TabBar(
                  indicator: UnderlineTabIndicator(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 4,
                      color: primaryColor,
                    ),
                    insets: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  indicatorWeight: 4,
                  labelStyle: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: theme.textTheme.bodyLarge,
                  labelColor: primaryColor,
                  unselectedLabelColor:
                      theme.colorScheme.onSurface.withOpacity(0.6),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.home_rounded),
                      text: 'الرئيسية',
                    ),
                    Tab(
                      icon: Icon(Icons.health_and_safety_rounded),
                      text: 'المنظمات',
                    ),
                    Tab(
                      icon: Icon(Icons.person_rounded),
                      text: 'الملف الشخصي',
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
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
