import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';
import '../widgets/hero_search_bar.dart';
import '../widgets/location_selector.dart';
import '../widgets/curated_collection.dart';
import '../widgets/category_grid.dart';
import '../widgets/trust_layer_strip.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _selectedCity = 'Lahore';
  String? _selectedArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium App Bar
          _buildAppBar(),

          // Hero Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: HeroSearchBar(
                onTap: () => context.push('/search'),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            ),
          ),

          // Trust Layer Strip
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const TrustLayerStrip()
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideX(begin: -0.2, end: 0),
            ),
          ),

          // Curated Collections
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Top Picks for You', 'See all'),
                const SizedBox(height: 16),
                CuratedCollection(
                  title: 'Top rated photographers this week',
                  businesses:
                      _getMockBusinesses(BusinessCategory.photographyVideo),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 24),
                CuratedCollection(
                  title: "Ladies-only salons with private rooms",
                  businesses: _getMockBusinesses(BusinessCategory.womensSalon),
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 24),
                CuratedCollection(
                  title: 'Best cafés for dholki meetup',
                  businesses: _getMockBusinesses(BusinessCategory.cafe),
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),

          // Featured Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Browse Categories', 'View all'),
                  const SizedBox(height: 20),
                  CategoryGrid(
                    onCategoryTap: (category) {
                      context.push('/category/${category.name}');
                    },
                  ).animate().fadeIn(delay: 1200.ms),
                ],
              ),
            ),
          ),

          // Near You Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildNearYouCard().animate().fadeIn(delay: 1400.ms).scale(
                  begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
            ),
          ),

          // Recently Viewed
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSectionHeader('Recently Viewed', ''),
                ),
                const SizedBox(height: 16),
                CuratedCollection(
                  title: '',
                  businesses: _getMockBusinesses(BusinessCategory.restaurant),
                  showTitle: false,
                ).animate().fadeIn(delay: 1600.ms),
              ],
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

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      expandedHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.backgroundDark,
                AppColors.backgroundDark.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Location Selector
                  Expanded(
                    child: LocationSelector(
                      selectedCity: _selectedCity,
                      selectedArea: _selectedArea,
                      onChanged: (city, area) {
                        setState(() {
                          _selectedCity = city;
                          _selectedArea = area;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Notifications
                  _buildIconButton(
                    icon: Icons.notifications_outlined,
                    onTap: () => context.push('/notifications'),
                    hasBadge: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onTap,
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundDark, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        if (action.isNotEmpty)
          TextButton(
            onPressed: () {},
            child: Text(
              action,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNearYouCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDeep.withValues(alpha: 0.2),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryDeep.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.primaryLight,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Near You',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find services within 5km',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white38,
            size: 20,
          ),
        ],
      ),
    );
  }

  // Mock data - will be replaced with real data
  List<Map<String, dynamic>> _getMockBusinesses(BusinessCategory category) {
    return List.generate(5, (index) {
      return {
        'id': 'business_${category.name}_$index',
        'name': '${category.label} ${index + 1}',
        'category': category,
        'rating': 4.5 + (index * 0.1),
        'reviews': 100 + (index * 20),
        'priceRange': PriceRange.premium,
        'distance': 2.5 + index,
        'imageUrl': 'https://picsum.photos/400/300?random=$index',
        'isVerified': index % 2 == 0,
      };
    });
  }
}
