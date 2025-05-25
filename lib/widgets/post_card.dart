import 'package:flutter/material.dart';
import '../models/post_model.dart';

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
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage('https://example.com/avatar.jpg'),
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
            builder: (context) => CommentsScreen(post: widget.post),
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

class CommentsScreen extends StatefulWidget {
  final PostModel post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  late final List<String> _comments = widget.post.savedComments ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعليقات'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _comments.isEmpty
                ? const Center(child: Text('لا توجد تعليقات بعد'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return _buildCommentItem(_comments[index], index);
                    },
                  ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentItem(String comment, int index) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        NetworkImage('https://example.com/avatar.jpg'),
                  ),
                  const SizedBox(width: 8),
                  const Text('مستخدم'),
                  const Spacer(),
                  Text(
                    'الآن',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(comment),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التعليق'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا التعليق؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _comments.removeAt(index);
                widget.post.savedComments = _comments;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف التعليق')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'اكتب تعليقاً...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                setState(() {
                  _comments.add(_commentController.text);
                  widget.post.savedComments = _comments;
                  _commentController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
