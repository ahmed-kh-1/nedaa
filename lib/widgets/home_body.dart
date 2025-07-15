// ignore_for_file: deprecated_member_use

import 'package:call/screens/ngos_screen.dart' show NGOsScreen;
import 'package:call/screens/auth/profile_screen.dart' show ProfileScreen;
import 'package:flutter/material.dart';
import 'package:call/widgets/post_card.dart';
import 'package:call/widgets/adoption_bottom_sheet.dart';
import 'package:call/models/post_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeBody extends StatelessWidget {
  final int currentIndex;
  final List<PostModel> posts;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final Function(int, String) onAdoptPost;

  const HomeBody({
    super.key,
    required this.currentIndex,
    required this.posts,
    required this.scrollController,
    required this.onRefresh,
    required this.onAdoptPost,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(context),
        Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: [
                  _buildPostList(context),
                  const NGOsScreen(),
                  const ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                Column(
                  children: [
                    PostCard(post: post),
                    _buildAdoptionButton(post, index, context),
                  ],
                ),
                if (post.isAdopted) _buildAdoptedBadge(post, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdoptionButton(PostModel post, int index, BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.handHoldingHeart,
            color: post.isAdopted ? Colors.grey : Colors.green,
          ),
          onPressed:
              post.isAdopted ? null : () => onAdoptPost(index, 'جمعية الإغاثة'),
        ),
        Text(post.isAdopted ? 'تم التبني' : 'تبني'),
      ],
    );
  }

  Widget _buildAdoptedBadge(PostModel post, BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (_) => AdoptionBottomSheet(ngoName: post.adoptedBy ?? ''),
        ),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: const Icon(Icons.verified, color: Colors.white),
        ),
      ),
    );
  }
}
