import 'package:flutter/material.dart';
import 'package:call/widgets/home_app_bar.dart';
import 'package:call/widgets/custom_bottom_nav_bar.dart';
import 'package:call/widgets/home_body.dart';
import 'package:call/models/post_model.dart';
import 'package:call/services/post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  int _currentIndex = 0;
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
    _scrollController.addListener(() {});
  }

  void _adoptPost(int index, String ngoName) {
    setState(() {
      _posts[index] = _posts[index]
          .copyWith(isAdopted: true, adoptedBy: ngoName, isLiked: false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تبني المشكلة بواسطة $ngoName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSearchToggle() {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) _searchController.clear();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: HomeAppBar(
        currentIndex: _currentIndex,
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchToggle: _handleSearchToggle,
      ),
      body: HomeBody(
        currentIndex: _currentIndex,
        posts: _posts,
        scrollController: _scrollController,
        onRefresh: _loadPosts,
        onAdoptPost: _adoptPost,
      ),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton(context) : null,
      bottomNavigationBar: CustomTopNavBar(
        currentIndex: _currentIndex,
        onTabChange: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-post'),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        label: const Text('بلاغ جديد'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
