import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:call/screens/posts/post_detail_screen.dart';
import 'package:call/models/organization_model.dart';

class OrganizationAdoptionsPage extends StatefulWidget {
  final OrganizationModel organization;

  const OrganizationAdoptionsPage({super.key, required this.organization});

  @override
  State<OrganizationAdoptionsPage> createState() =>
      _OrganizationAdoptionsPageState();
}

class _OrganizationAdoptionsPageState extends State<OrganizationAdoptionsPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _error;
  List<_Adoption> _items = [];
  final Map<String, String> _postTitles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAdoptions());
  }

  Future<void> _loadAdoptions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _supabase
          .from('adoptions')
          .select('id, post_id, created_at')
          .eq('org_id', widget.organization.id)
          .order('created_at', ascending: false);

      final items = (data as List<dynamic>).map((row) {
        return _Adoption(
          id: row['id'] as int,
          postId: (row['post_id'] as String?) ?? '',
          createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
              DateTime.now(),
        );
      }).toList();

      setState(() {
        _items = items;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _getPostTitle(String postId) async {
    if (postId.isEmpty) return 'بدون عنوان';
    if (_postTitles.containsKey(postId)) return _postTitles[postId]!;
    try {
      final res = await _supabase
          .from('posts')
          .select('post_text')
          .eq('id', postId)
          .single();
      final title = (res['post_text'] as String?) ?? 'بدون عنوان';
      setState(() {
        _postTitles[postId] = title;
      });
      return title;
    } catch (_) {
      return 'بدون عنوان';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.organization.name} - التبنّيات'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAdoptions,
        child: _isLoading && _items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('حدث خطأ: $_error'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _loadAdoptions,
                          child: const Text('إعادة المحاولة'),
                        )
                      ],
                    ),
                  )
                : _items.isEmpty
                    ? const Center(child: Text('لا توجد تبنّيات بعد'))
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PostDetailScreen(
                                      postId: item.postId,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: theme.colorScheme.primary
                                          .withOpacity(0.15),
                                      child: Icon(Icons.favorite_rounded,
                                          color: theme.colorScheme.primary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: FutureBuilder<String>(
                                                  future:
                                                      _getPostTitle(item.postId),
                                                  builder: (context, snapshot) {
                                                    final title = snapshot.data ??
                                                        'جاري التحميل...';
                                                    return Text(
                                                      title,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatDateTime(item.createdAt),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'تم التبنّي بواسطة الجمعية',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

class _Adoption {
  final int id;
  final String postId;
  final DateTime createdAt;
  _Adoption({required this.id, required this.postId, required this.createdAt});
}
