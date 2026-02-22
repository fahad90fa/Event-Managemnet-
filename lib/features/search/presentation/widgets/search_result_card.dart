import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> business;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.business,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = business['category'] as BusinessCategory;
    final priceRange = business['priceRange'] as PriceRange;
    final genderPolicy = business['genderPolicy'] as GenderPolicy;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: AppColors.surfaceDark,
            child: Row(
              children: [
                // Image
                Container(
                  width: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundDark,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        business['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surfaceDark,
                            child: const Icon(
                              Icons.image_outlined,
                              color: Colors.white24,
                              size: 32,
                            ),
                          );
                        },
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Verified Badge
                      if (business['isVerified'] == true)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.successDeep.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),

                      // Save Button
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            icon: const Icon(
                              Icons.bookmark_outline_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Saved to favorites!'),
                                      backgroundColor: AppColors.primaryDeep));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            category.label,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _getCategoryColor(category),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Business Name
                        Text(
                          business['name'],
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Rating & Reviews
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.gold,
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              business['rating'].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${business['reviews']})',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              priceRange.symbol,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Bottom Row: Distance, Gender Policy, Deals
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white54,
                              size: 12,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${business['distance']} km',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white54,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildGenderBadge(genderPolicy),
                            if (business['hasDeals'] == true) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Deal',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Quick Actions
                        Row(
                          children: [
                            _buildQuickAction(Icons.phone_outlined, 'Call'),
                            const SizedBox(width: 8),
                            _buildQuickAction(
                                Icons.chat_bubble_outline_rounded, 'Chat'),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: AppColors.heroGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Book',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderBadge(GenderPolicy policy) {
    final colors = {
      GenderPolicy.womenOnly: const Color(0xFFDB2777),
      GenderPolicy.menOnly: const Color(0xFF2563EB),
      GenderPolicy.unisex: const Color(0xFF8B5CF6),
      GenderPolicy.segregated: const Color(0xFF10B981),
    };

    final icons = {
      GenderPolicy.womenOnly: Icons.woman_rounded,
      GenderPolicy.menOnly: Icons.man_rounded,
      GenderPolicy.unisex: Icons.people_rounded,
      GenderPolicy.segregated: Icons.family_restroom_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors[policy]!.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icons[policy],
            color: colors[policy],
            size: 10,
          ),
          const SizedBox(width: 3),
          Text(
            policy == GenderPolicy.womenOnly
                ? 'W'
                : policy == GenderPolicy.menOnly
                    ? 'M'
                    : policy == GenderPolicy.unisex
                        ? 'U'
                        : 'F',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: colors[policy],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white54,
          size: 14,
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(BusinessCategory category) {
    switch (category) {
      case BusinessCategory.photographyVideo:
        return const Color(0xFF8B5CF6);
      case BusinessCategory.womensSalon:
        return const Color(0xFFEC4899);
      case BusinessCategory.mensSalon:
        return const Color(0xFF3B82F6);
      default:
        return AppColors.primaryDeep;
    }
  }
}
