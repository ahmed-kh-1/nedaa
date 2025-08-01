import 'package:flutter/material.dart';
import 'package:call/models/post_model.dart';

class PostUserInfoSection extends StatelessWidget {
  final PostModel post;

  const PostUserInfoSection({super.key, required this.post});

  String _getInitials(String fullName) {
    // Handle empty posterName case
    if (fullName.isEmpty) {
      return '?';
    }
    final List<String> parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String _formatRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعات';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقائق';
    } else {
      return 'الآن';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initials = _getInitials(post.posterName);
    final String relativeTime = _formatRelativeTime(post.createdAt);

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Text(
              initials,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.posterName.isEmpty ? 'مُستخدم مجهول' : post.posterName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                relativeTime,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        // Post type indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: post.postType == 'problem' 
                ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            post.postType == 'problem' ? 'مشكلة' : 'حادث',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: post.postType == 'problem' 
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
