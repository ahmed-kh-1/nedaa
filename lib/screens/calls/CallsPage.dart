import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/post_model.dart';
import '../../models/call_model.dart';
import '../../models/organization_model.dart';
import '../../providers/call_provider.dart';
import '../../providers/organization_provider.dart';

class CallsPage extends StatefulWidget {
  final PostModel post;

  const CallsPage({super.key, required this.post});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCalls();
    });
  }

  Future<void> _loadCalls() async {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    await callProvider.fetchCallsByPostId(widget.post.postId);
  }

  Future<void> _addCall() async {
    final orgProvider = Provider.of<OrganizationProvider>(context, listen: false);
    
    // Ensure organizations are loaded
    if (orgProvider.organizations.isEmpty) {
      await orgProvider.fetchOrganizations();
    }
    
    _showOrganizationSelectionDialog(orgProvider.organizations);
  }

  void _showOrganizationSelectionDialog(List<OrganizationModel> organizations) {
    final searchController = TextEditingController();
    List<OrganizationModel> filteredOrgs = List.from(organizations);
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('اختر المنظمة'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن منظمة...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            filteredOrgs = List.from(organizations);
                          } else {
                            filteredOrgs = organizations
                                .where((org) => org.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: filteredOrgs.isEmpty
                          ? const Center(child: Text('لا توجد منظمات'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredOrgs.length,
                              itemBuilder: (context, index) {
                                final org = filteredOrgs[index];
                                return ListTile(
                                  title: Text(org.name),
                                  subtitle: Text(org.shortDescription),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _confirmAddCall(org);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmAddCall(OrganizationModel organization) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول لإضافة مكالمة')),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد إضافة مكالمة'),
        content: Text('هل تريد إضافة مكالمة إلى ${organization.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final call = CallModel(
        id: '', // Will be generated by Supabase
        postId: widget.post.postId,
        organizationId: organization.id,
        callerId: user.id,
        callerName: user.userMetadata?['full_name'] ?? 'مستخدم',
        createdAt: DateTime.now(),
      );

      final callProvider = Provider.of<CallProvider>(context, listen: false);
      try {
        await callProvider.addCall(call);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة المكالمة بنجاح')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إضافة المكالمة: $e')),
        );
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكالمات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCall,
          ),
        ],
      ),
      body: Consumer2<CallProvider, OrganizationProvider>(
        builder: (context, callProvider, orgProvider, child) {
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
                      
                      // Find organization name
                      final organization = orgProvider.organizations
                          .firstWhere(
                              (org) => org.id == call.organizationId,
                              orElse: () => OrganizationModel(
                                    id: '',
                                    name: 'منظمة غير معروفة',
                                    shortDescription: '',
                                    generalDescription: '',
                                    phone: '',
                                    email: '',
                                    location: '',
                                    workingHours: '',
                                    ownerId: '',
                                    specialization: '',
                                  ));
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.green.shade300,
                                child: const Icon(Icons.call, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            organization.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
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
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
