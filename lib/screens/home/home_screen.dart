import 'package:flutter/material.dart';
import 'package:call/widgets/home/home_app_bar.dart';
import 'package:call/widgets/home/home_posts_list.dart';
import 'package:call/models/post_model.dart';
import 'package:call/services/post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();

  int _currentIndex = 0;
  List<PostModel> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final posts = await _postService.fetchPosts();
    setState(() => _posts = posts);
  }

  // void _adoptPost(int index, String ngoName) {

  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePostsList(
        posts: _posts,
        onRefresh: _loadPosts,
      ),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton(context) : null,
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
