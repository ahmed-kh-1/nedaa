import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;

  const HomeAppBar({
    super.key,
    required this.currentIndex,
    required this.isSearching,
    required this.searchController,
    required this.onSearchToggle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildAppBarTitle(theme),
      ),
      actions: _buildActions(theme),
    );
  }

  Widget _buildAppBarTitle(ThemeData theme) {
    if (currentIndex == 0) {
      return isSearching
          ? TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن بلاغات...',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.secondary,
                ),
              ),
            )
          : const Text(
              'نداء',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
    }
    return Text(_getAppBarTitle());
  }

  List<Widget> _buildActions(ThemeData theme) {
    if (currentIndex != 0) return [];

    return [
      IconButton(
        icon: Icon(
          isSearching ? Icons.close : Icons.search,
          color: Colors.black,
        ),
        onPressed: onSearchToggle,
      )
    ];
  }

  String _getAppBarTitle() {
    switch (currentIndex) {
      case 1:
        return 'الجمعيات';
      case 2:
        return 'حسابي';
      default:
        return 'نداء';
    }
  }
}
