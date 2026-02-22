import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class CategoryGrid extends StatelessWidget {
  final Function(BusinessCategory) onCategoryTap;

  const CategoryGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final categories = BusinessCategory.values.take(8).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          onTap: () => onCategoryTap(category),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final BusinessCategory category;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(category).withValues(alpha: 0.3),
                  _getCategoryColor(category).withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getCategoryColor(category).withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                category.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Label
          Text(
            _getCategoryShortLabel(category),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
      case BusinessCategory.unisexSalon:
        return const Color(0xFF8B5CF6);
      case BusinessCategory.makeupArtist:
        return const Color(0xFFF472B6);
      case BusinessCategory.marqueeHall:
        return const Color(0xFFD4AF37);
      case BusinessCategory.restaurant:
        return const Color(0xFFF59E0B);
      case BusinessCategory.cafe:
        return const Color(0xFF10B981);
      default:
        return AppColors.primaryDeep;
    }
  }

  String _getCategoryShortLabel(BusinessCategory category) {
    switch (category) {
      case BusinessCategory.photographyVideo:
        return 'Photo &\nVideo';
      case BusinessCategory.womensSalon:
        return "Women's\nSalon";
      case BusinessCategory.mensSalon:
        return "Men's\nSalon";
      case BusinessCategory.unisexSalon:
        return 'Unisex\nSalon';
      case BusinessCategory.makeupArtist:
        return 'Makeup\nArtist';
      case BusinessCategory.marqueeHall:
        return 'Marquee\n& Hall';
      case BusinessCategory.restaurant:
        return 'Restaurant';
      case BusinessCategory.cafe:
        return 'Café';
      default:
        return category.label;
    }
  }
}
