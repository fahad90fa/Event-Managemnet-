import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../domain/entities/social_post.dart';

class PostCard extends StatelessWidget {
  final SocialPost post;
  final int index;

  const PostCard({super.key, required this.post, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with User Info
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.backgroundDark,
                          backgroundImage: post.userImageUrl != null
                              ? NetworkImage(post.userImageUrl!)
                              : null,
                          child: post.userImageUrl == null
                              ? const Icon(Icons.person, color: Colors.white70)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.userName,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: AppColors.textPrimary)),
                            Text(
                              _formatTimestamp(post.createdAt),
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz_rounded,
                            color: AppColors.textTertiary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Content Text
                if (post.content.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Text(
                      post.content,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.textPrimary.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Image Gallery
                if (post.imageUrls.isNotEmpty)
                  _buildPremiumGallery(post.imageUrls),

                // Interaction Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Row(
                    children: [
                      _buildInteractionItem(
                        icon: post.isLikedByMe
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        label: '${post.likesCount}',
                        activeColor: Colors.redAccent,
                        isActive: post.isLikedByMe,
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _buildInteractionItem(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: '${post.commentsCount}',
                        activeColor: AppColors.primaryLight,
                        isActive: false,
                        onTap: () {},
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: AppColors.textTertiary, size: 20),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border_rounded,
                            color: AppColors.textTertiary, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumGallery(List<String> images) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: images.length == 1
            ? Image.network(images[0],
                fit: BoxFit.cover, width: double.infinity)
            : PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildInteractionItem({
    required IconData icon,
    required String label,
    required Color activeColor,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: isActive ? activeColor : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isActive ? activeColor : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
