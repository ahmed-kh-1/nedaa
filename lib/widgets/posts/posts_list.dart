import 'package:flutter/material.dart';
import 'package:call/widgets/posts/post_card.dart';
import 'package:call/models/post_model.dart';

class PostsList extends StatelessWidget {
  final List<PostModel> posts;
  final Future<void> Function() onRefresh;

  const PostsList({
    super.key,
    required this.posts,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
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
              'لا توجد بلاغات حتى الآن',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'كن أول من يبلغ عن مشكلة في منطقتك',
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
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(post: post, onTap: () {});
        },
      ),
    );
  }
}
