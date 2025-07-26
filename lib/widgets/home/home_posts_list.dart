import 'package:flutter/material.dart';
import 'package:call/widgets/home/post_card.dart';
import 'package:call/models/post_model.dart';

class HomePostsList extends StatelessWidget {
  final List<PostModel> posts;
  final Future<void> Function() onRefresh;

  const HomePostsList({
    super.key,
    required this.posts,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildPostList(context),
        ),
      ],
    );
  }

  Widget _buildPostList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: PostCard(post: post, onTap: () {}),
          );
        },
      ),
    );
  }
}
