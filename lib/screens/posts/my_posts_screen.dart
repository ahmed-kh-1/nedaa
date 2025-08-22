import 'package:call/providers/post_provider.dart';
import 'package:call/widgets/posts/post_card.dart';
import 'package:call/models/post_model.dart';
import 'package:call/screens/posts/create_post_page.dart';
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

  Future<void> _navigateToEdit(PostModel post) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(initialPost: post),
      ),
    );
    if (changed == true && mounted) {
      await Provider.of<PostProvider>(context, listen: false).fetchUserPosts();
    }
  }

  Future<void> _confirmDelete(PostModel post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف البلاغ'),
        content: const Text('هل أنت متأكد من حذف هذا البلاغ؟ لا يمكن التراجع عن ذلك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<PostProvider>(context, listen: false);
      await provider.deletePost(post.postId);
      await provider.fetchUserPosts();
    }
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
                return Stack(
                  children: [
                    PostCard(post: post, onTap: () {}),
                    Positioned(
                      top: 0,
                      right: 8,
                      child: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            await _navigateToEdit(post);
                          } else if (value == 'delete') {
                            await _confirmDelete(post);
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('تعديل'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 18),
                                SizedBox(width: 8),
                                Text('حذف'),
                              ],
                            ),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
