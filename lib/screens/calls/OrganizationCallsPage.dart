import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:call/screens/posts/post_detail_screen.dart';
import '../../models/organization_model.dart';
import '../../providers/call_provider.dart';

class OrganizationCallsPage extends StatefulWidget {
  final OrganizationModel organization;

  const OrganizationCallsPage({super.key, required this.organization});

  @override
  State<OrganizationCallsPage> createState() => _OrganizationCallsPageState();
}

class _OrganizationCallsPageState extends State<OrganizationCallsPage> {
  final Map<String, String> _postTitles = {};
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCalls();
    });
  }

  Future<String> _getPostTitle(String postId) async {
    // Check if we already have the title cached
    if (_postTitles.containsKey(postId)) {
      return _postTitles[postId]!;
    }

    try {
      // Fetch the post title from Supabase
      final response = await _supabase
          .from('posts')
          .select('post_text')
          .eq('id', postId)
          .single();

      final title = response['post_text'] ?? 'بدون عنوان';
      setState(() {
        _postTitles[postId] = title;
      });
      return title;
    } catch (e) {
      print('Error fetching post title: $e');
      return 'بدون عنوان';
    }
  }

  Future<void> _loadCalls() async {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    await callProvider.fetchCallsByOrgId(widget.organization.id);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.organization.name} - النداءات'),
      ),
      body: Consumer<CallProvider>(
        builder: (context, callProvider, child) {
          if (callProvider.isLoading && callProvider.calls.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (callProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حدث خطأ: ${callProvider.errorMessage}'),
                  ElevatedButton(
                    onPressed: _loadCalls,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final calls = callProvider.calls;

          return RefreshIndicator(
            onRefresh: _loadCalls,
            child: calls.isEmpty
                ? const Center(child: Text('لا توجد مكالمات بعد'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: calls.length,
                    itemBuilder: (context, index) {
                      final call = calls[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PostDetailScreen(
                                  postId: call.postId,
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
                                  backgroundColor: Colors.green.shade300,
                                  child:
                                      const Icon(Icons.call, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder<String>(
                                              future: _getPostTitle(call.postId),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    snapshot.data!,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Text('حدث خطأ');
                                                } else {
                                                  return const Text(
                                                      'جاري التحميل...');
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _formatDateTime(call.createdAt),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'بواسطة: ${call.callerName}',
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
          );
        },
      ),
    );
  }
}
