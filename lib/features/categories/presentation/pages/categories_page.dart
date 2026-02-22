import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _searchQuery.isEmpty
        ? BusinessCategory.values
        : BusinessCategory.values
            .where((cat) =>
                cat.label.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.backgroundDark,
            elevation: 0,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 12),
                      _buildSearchBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Categories Grid
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = filteredCategories[index];
                  return _CategoryCard(
                    category: category,
                    delay: index * 100,
                    onTap: () => context.push('/category/${category.name}'),
                  );
                },
                childCount: filteredCategories.length,
              ),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: GoogleFonts.inter(
            color: Colors.white38,
            fontSize: 14,
          ),
          border: InputBorder.none,
          icon: const Icon(
            Icons.search_rounded,
            color: Colors.white38,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Colors.white38,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _CategoryCard extends StatelessWidget {
  final BusinessCategory category;
  final int delay;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getCategoryColor(category).withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(category).withValues(alpha: 0.3),
                  _getCategoryColor(category).withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _getCategoryColor(category).withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Background Pattern
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Text(
                      category.emoji,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),

                      const Spacer(),

                      // Label
                      Text(
                        category.label,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Count (mock)
                      Text(
                        '${_getBusinessCount(category)} businesses',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
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
      case BusinessCategory.farmhouse:
        return const Color(0xFF10B981);
      case BusinessCategory.hotelBanquet:
        return const Color(0xFFF59E0B);
      case BusinessCategory.restaurant:
        return const Color(0xFFF59E0B);
      case BusinessCategory.cafe:
        return const Color(0xFF10B981);
      case BusinessCategory.catering:
        return const Color(0xFFEF4444);
      case BusinessCategory.decor:
        return const Color(0xFFF472B6);
      case BusinessCategory.wearDesigners:
        return const Color(0xFFEC4899);
      case BusinessCategory.transport:
        return const Color(0xFF3B82F6);
      case BusinessCategory.photoVideoStudio:
        return const Color(0xFF8B5CF6);
    }
  }

  int _getBusinessCount(BusinessCategory category) {
    // Mock counts - will be replaced with real data
    return 50 + (category.index * 15);
  }
}
