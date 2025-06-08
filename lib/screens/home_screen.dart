import 'package:flutter/material.dart';
import 'package:call/screens/ngos_screen.dart';
import 'package:call/screens/profile_screen.dart';
import 'package:call/widgets/post_card.dart';
import 'package:call/models/post_model.dart';
import 'package:call/services/post_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PostService _postService = PostService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  int _currentIndex = 0;
  bool _isFabPressed = false;
  double _scrollOffset = 0;
  List<PostModel> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _setupScrollListener();
  }

  Future<void> _loadPosts() async {
    final posts = await _postService.fetchPosts();
    setState(() => _posts = posts);
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  void _adoptPost(int index, String ngoName) {
    setState(() {
      _posts[index] =
          _posts[index].copyWith(isAdopted: true, adoptedBy: ngoName);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تبني المشكلة بواسطة $ngoName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAdoptionInfo(BuildContext context, String ngoName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('معلومات التبني'),
        content: Text('تم تبني هذه المشكلة بواسطة جمعية: $ngoName'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: _buildBody(theme),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton(theme) : null,
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.primaryColor,
      elevation: 4,
      title: _currentIndex == 0
          ? _isSearching
              ? TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن بلاغات...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      // ignore: deprecated_member_use
                      color: theme.colorScheme.onPrimary.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    prefixIcon:
                        Icon(Icons.search, color: theme.colorScheme.secondary),
                  ),
                )
              : Text('نداء',
                  style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 32))
          : Text(_getAppBarTitle(),
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: theme.colorScheme.onPrimary)),
      actions: [
        if (_currentIndex == 0)
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: theme.colorScheme.secondary,
                size: 30,
                key: ValueKey<bool>(_isSearching),
              ),
            ),
            onPressed: () => setState(() => _isSearching = !_isSearching),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Transform.translate(
          offset: Offset(0, -_scrollOffset.clamp(0, 30) / 3),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  // ignore: deprecated_member_use
                  theme.colorScheme.primaryContainer.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: theme.colorScheme.secondary.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, 'المنشورات', theme),
                _buildNavItem(1, Icons.people_alt, 'الجمعيات', theme),
                _buildNavItem(2, Icons.person_pin, 'حسابي', theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                RefreshIndicator(
                  color: theme.colorScheme.secondary,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  onRefresh: _loadPosts,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Stack(
                        children: [
                          Column(
                            children: [
                              PostCard(post: post),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8),
                                child: Center(
                                  child: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.handHoldingHeart,
                                      color: post.isAdopted
                                          ? Colors.grey.shade400
                                          : Colors.blue,
                                      size: 44,
                                    ),
                                    onPressed: post.isAdopted
                                        ? null
                                        : () {
                                            const ngoName = 'جمعية الإغاثة';
                                            _adoptPost(index, ngoName);
                                          },
                                    tooltip: 'تبني المشكلة',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (post.isAdopted)
                            Positioned(
                              top: 18,
                              left: 16,
                              child: GestureDetector(
                                onTap: () => _showAdoptionInfo(
                                    context, post.adoptedBy ?? ''),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: const Icon(Icons.star,
                                      color: Colors.white, size: 22),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const NGOsScreen(),
                const ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isFabPressed = true),
        onTapUp: (_) => setState(() => _isFabPressed = false),
        onTapCancel: () => setState(() => _isFabPressed = false),
        onTap: () => Navigator.pushNamed(context, '/create-post'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.secondary,
                theme.colorScheme.primaryContainer
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary
                    // ignore: deprecated_member_use
                    .withOpacity(_isFabPressed ? 0.4 : 0.6),
                blurRadius: _isFabPressed ? 8 : 15,
                spreadRadius: _isFabPressed ? 1 : 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: theme.colorScheme.onPrimary, size: 28),
              const SizedBox(width: 10),
              Text(
                'بلاغ طارئ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, ThemeData theme) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: isActive
              ? Border(
                  bottom:
                      BorderSide(color: theme.colorScheme.secondary, width: 3))
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isActive
                    ? theme.colorScheme.secondary
                    // ignore: deprecated_member_use
                    : theme.colorScheme.onPrimary.withOpacity(0.6),
                size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isActive
                    ? theme.colorScheme.secondary
                    // ignore: deprecated_member_use
                    : theme.colorScheme.onPrimary.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      default:
        return 'نداء';
    }
  }
}
