import 'package:flutter/material.dart';
import 'package:call/models/post_model.dart';
import 'package:call/services/post_service.dart';
import 'package:call/widgets/posts/post_card.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل البلاغ'),
      ),
      body: FutureBuilder<PostModel?>(
        future: PostService().getPostById(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text('حدث خطأ أثناء جلب تفاصيل البلاغ', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                  ],
                ),
              ),
            );
          }
          final post = snapshot.data;
          if (post == null) {
            return const Center(child: Text('البلاغ غير موجود'));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // Reuse PostCard for a consistent single-post view
              PostCard(
                post: post,
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
