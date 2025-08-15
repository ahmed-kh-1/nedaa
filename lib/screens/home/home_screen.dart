import 'package:call/models/user_model.dart';
import 'package:call/providers/auth_provider.dart';
import 'package:call/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:call/widgets/posts/posts_list.dart';
import 'package:call/providers/post_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading && postProvider.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    postProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: postProvider.fetchPosts,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return PostsList(
            posts: postProvider.posts,
            onRefresh: postProvider.fetchPosts,
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
        onPressed:
            // () {
            //   // sign out
            //   //   Provider.of<AuthProvider>(context, listen: false).signOut();
            //   Provider.of<UserProvider>(context, listen: false).loadUser();
            //   UserModel? user =
            //       Provider.of<UserProvider>(context, listen: false).currentUser;
            //   debugPrint(user?.fullName);
            // },
            () => Navigator.pushNamed(context, '/create-post'),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        label: const Text('بلاغ جديد'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
