import 'package:call/screens/calls/CallsPage.dart';
import 'package:call/screens/comments/CommentPage.dart';
import 'package:flutter/material.dart';
import 'package:call/models/post_model.dart';

class PostActions extends StatefulWidget {
  final PostModel post;

  const PostActions({super.key, required this.post});

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool _isAdopted = false;

  @override
  void initState() {
    super.initState();
    _isAdopted = widget.post.isAdopted;
  }

  void _toggleAdopt() {
    setState(() {
      _isAdopted = !_isAdopted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAdoptButton(),
        _buildCommentButton(context),
        _buildCallButton(context),
      ],
    );
  }

  Widget _buildAdoptButton() {
    return TextButton.icon(
      onPressed: _toggleAdopt,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(
        _isAdopted ? Icons.handshake : Icons.handshake_outlined,
        color: _isAdopted
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: 20,
      ),
      label: Text(
        _isAdopted ? 'تم تبني المشكلة' : 'تبنى',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _navigateToComments(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(
        Icons.comment_outlined,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: 20,
      ),
      label: Text(
        'التعليقات',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildCallButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _navigateToCalls(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(
        Icons.speaker_phone,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: 20,
      ),
      label: Text(
        'نداء',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  void _navigateToCalls(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallsPage(post: widget.post),
      ),
    );
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
