import 'package:call/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import '../../models/call_model.dart';
import '../../models/organization_model.dart';
import '../../providers/call_provider.dart';
import '../../providers/organization_provider.dart';
import '../../providers/user_provider.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser();
    final user = userProvider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول لإضافة نداء')),
      );
      return;
    }

    final orgProvider =
        Provider.of<OrganizationProvider>(context, listen: false);

    if (orgProvider.organizations.isEmpty) {
      await orgProvider.fetchOrganizations();
    }

    _showOrganizationSelectionSheet(orgProvider.organizations, user);
  }

  void _showOrganizationSelectionSheet(
      List<OrganizationModel> organizations, UserModel user) {
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        List<OrganizationModel> filteredOrgs = List.from(organizations);
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'اختر المنظمة',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن منظمة...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
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
                                controller: scrollController,
                                itemCount: filteredOrgs.length,
                                itemBuilder: (context, index) {
                                  final org = filteredOrgs[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text(org.name),
                                      subtitle: Text(org.shortDescription),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _addCallToOrganization(org, user);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _addCallToOrganization(
      OrganizationModel organization, UserModel user) async {
    final call = CallModel(
      id: '',
      postId: widget.post.postId,
      organizationId: organization.id,
      callerId: user.id,
      callerName: user.fullName!,
      createdAt: DateTime.now(),
    );

    final callProvider = Provider.of<CallProvider>(context, listen: false);
    try {
      await callProvider.addCall(call);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة النداء بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة النداء: $e')),
      );
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
        title: const Text('النداءات'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCall,
        child: const Icon(Icons.add),
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

                      final organization = orgProvider.organizations
                          .firstWhere((org) => org.id == call.organizationId,
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
