import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'CommentPage.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=8'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post.userName),
                        Text(widget.post.timeAgo),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.post.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLikeButton(),
                    _buildCommentButton(context),
                    _buildShareButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
          _isLiked ? _likeCount++ : _likeCount--;
        });
      },
      icon: Icon(
        _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
        color: _isLiked ? Colors.blue : null,
      ),
      label: Text('دعم ($_likeCount)'),
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentPage(post: widget.post),
          ),
        );
      },
      icon: const Icon(Icons.comment),
      label: Text('تعليق (${widget.post.comments})'),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showShareOptions(context),
      icon: const Icon(Icons.share),
      label: const Text('مشاركة'),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'مشاركة المنشور',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.blue),
              title: const Text('نسخ الرابط'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نسخ الرابط')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.green),
              title: const Text('مشاركة عبر الرسائل'),
              onTap: () {
                Navigator.pop(context);
                _shareViaMessages(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.more_horiz),
              title: const Text('خيارات أخرى'),
              onTap: () {
                Navigator.pop(context);
                _showMoreShareOptions(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareViaMessages(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري فتح تطبيق الرسائل...')),
    );
  }

  void _showMoreShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'خيارات مشاركة إضافية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text('مشاركة عبر البريد الإلكتروني'),
              onTap: () {
                Navigator.pop(context);
                _shareViaEmail(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('مشاركة عبر WhatsApp'),
              onTap: () {
                Navigator.pop(context);
                _shareViaWhatsApp(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.social_distance, color: Colors.blue),
              title: const Text('مشاركة عبر وسائل التواصل الاجتماعي'),
              onTap: () {
                Navigator.pop(context);
                _shareViaSocialMedia(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareViaEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري فتح تطبيق البريد الإلكتروني...')),
    );
  }

  void _shareViaWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري فتح تطبيق WhatsApp...')),
    );
  }

  void _shareViaSocialMedia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر منصة التواصل الاجتماعي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري فتح Facebook...')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.purple),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري فتح Instagram...')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble, color: Colors.lightBlue),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري فتح Twitter...')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
