import 'package:flutter/material.dart';
import 'package:call/models/post_model.dart';
import 'package:call/widgets/home/post_user_info_section.dart';
import 'package:call/widgets/home/post_actions.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostUserInfoSection(post: post),
                const SizedBox(height: 16),
                _buildPostTitle(),
                const SizedBox(height: 8),
                _buildPostDescription(),
                const SizedBox(height: 16),
                PostActions(post: post),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostTitle() {
    return Text(
      post.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPostDescription() {
    return Text(
      post.description,
      style: const TextStyle(fontSize: 16),
    );
  }
}
