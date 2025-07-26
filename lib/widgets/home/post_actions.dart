import 'package:call/widgets/CommentPage.dart';
import 'package:flutter/material.dart';
import 'package:call/models/post_model.dart';
import 'package:call/widgets/share_handler.dart'; // ✅ استدعاء صفحة التعليقات

class PostActions extends StatefulWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLikeButton(),
        _buildCommentButton(context),
        _buildShareButton(context),
      ],
    );
  }

  Widget _buildLikeButton() {
    return TextButton.icon(
      onPressed: _toggleLike,
      icon: Icon(
        _isLiked ? Icons.arrow_circle_up_rounded : Icons.arrow_circle_up,
        color: _isLiked ? Theme.of(context).primaryColor : Colors.grey,
        size: 30,
      ),
      label: Text('($_likeCount)'),
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _navigateToComments(context),
      icon: const Icon(
        Icons.comment,
        size: 30,
      ),
      label: Text(' (${widget.post.comments})'),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => ShareHandler.showShareOptions(context),
      icon: const Icon(
        Icons.share,
        size: 30,
      ),
      label: const Text('مشاركة'),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
    });
  }

  void _navigateToComments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentPage(post: widget.post),
      ),
    );
  }
}
