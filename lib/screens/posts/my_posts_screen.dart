import 'package:call/providers/post_provider.dart';
import 'package:call/widgets/posts/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPosts();
    });
  }

  Future<void> _loadUserPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.fetchUserPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بلاغاتي السابقة'),
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'حدث خطأ: ${postProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: postProvider.fetchUserPosts,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final userPosts = postProvider.userPosts;
          
          if (userPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.post_add,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بلاغات سابقة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ بإنشاء بلاغ جديد',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: postProvider.fetchUserPosts,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];
                return PostCard(post: post, onTap: () {});
              },
            ),
          );
        },
      ),
    );
  }
}
