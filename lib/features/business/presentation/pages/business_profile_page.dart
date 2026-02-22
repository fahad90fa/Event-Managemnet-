import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class BusinessProfilePage extends StatefulWidget {
  final String businessId;

  const BusinessProfilePage({super.key, required this.businessId});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isHeaderCollapsed) {
      setState(() {
        _isHeaderCollapsed = true;
      });
    } else if (_scrollController.offset <= 200 && _isHeaderCollapsed) {
      setState(() {
        _isHeaderCollapsed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = _getMockBusiness();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Gallery
              _buildHeroGallery(business),

              // Business Info Header
              SliverToBoxAdapter(
                child: _buildBusinessHeader(business),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: _buildQuickActions(),
              ),

              // Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: AppColors.primaryDeep,
                    indicatorWeight: 3,
                    labelColor: AppColors.primaryLight,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Services'),
                      Tab(text: 'Portfolio'),
                      Tab(text: 'Availability'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Location'),
                    ],
                  ),
                ),
              ),

              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(business),
                    _buildServicesTab(business),
                    _buildPortfolioTab(business),
                    _buildAvailabilityTab(business),
                    _buildReviewsTab(business),
                    _buildLocationTab(business),
                  ],
                ),
              ),
            ],
          ),

          // Floating App Bar
          _buildFloatingAppBar(),

          // Bottom Action Bar
          _buildBottomActionBar(business),
        ],
      ),
    );
  }

  Widget _buildHeroGallery(Map<String, dynamic> business) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              business['coverImage'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surfaceDark,
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.white24,
                    size: 64,
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
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Gallery Indicator
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${business['photoCount']} photos',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHeader(Map<String, dynamic> business) {
    final category = business['category'] as BusinessCategory;
    final priceRange = business['priceRange'] as PriceRange;
    final genderPolicy = business['genderPolicy'] as GenderPolicy;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryDeep.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLight,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Business Name
          Text(
            business['name'],
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),

          const SizedBox(height: 8),

          // Rating, Reviews, Price
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.gold,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                business['rating'].toString(),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${business['reviews']} reviews)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '•',
                style: TextStyle(color: Colors.white38),
              ),
              const SizedBox(width: 12),
              Text(
                priceRange.symbol,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 12),

          // Trust Badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (business['isVerified'] == true)
                _buildTrustBadge(
                  icon: Icons.verified_rounded,
                  label: 'Verified',
                  color: AppColors.successDeep,
                ),
              _buildTrustBadge(
                icon: _getGenderIcon(genderPolicy),
                label: genderPolicy.label,
                color: _getGenderColor(genderPolicy),
              ),
              if (business['hasPrivateRoom'] == true)
                _buildTrustBadge(
                  icon: Icons.meeting_room_outlined,
                  label: 'Private Room',
                  color: const Color(0xFF8B5CF6),
                ),
              if (business['hasParking'] == true)
                _buildTrustBadge(
                  icon: Icons.local_parking_outlined,
                  label: 'Parking',
                  color: const Color(0xFF3B82F6),
                ),
            ],
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),

          // Location & Response Time
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white54,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${business['distance']} km away',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time_rounded,
                color: Colors.white54,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Responds in ${business['responseTime']} min',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  Widget _buildTrustBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.phone_outlined,
              label: 'Call',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Message',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          _buildIconButton(
            icon: Icons.share_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildIconButton(
            icon: Icons.bookmark_outline_rounded,
            onTap: () {},
          ),
        ],
      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildFloatingAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color:
            _isHeaderCollapsed ? AppColors.backgroundDark : Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                if (_isHeaderCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getMockBusiness()['name'],
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(Map<String, dynamic> business) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    '₨${business['startingPrice']}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.royalGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDeep.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.push('/booking/create/${business['id']}',
                            extra: {
                              'serviceName': 'Premium Wedding Photography',
                              'price': business['startingPrice']
                            });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Book Now',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab Content Builders
  Widget _buildOverviewTab(Map<String, dynamic> business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            business['description'],
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildServicesTab(Map<String, dynamic> business) {
    return Center(
      child: Text(
        'Services coming soon',
        style: GoogleFonts.inter(color: Colors.white38),
      ),
    );
  }

  Widget _buildPortfolioTab(Map<String, dynamic> business) {
    return Center(
      child: Text(
        'Portfolio coming soon',
        style: GoogleFonts.inter(color: Colors.white38),
      ),
    );
  }

  Widget _buildAvailabilityTab(Map<String, dynamic> business) {
    return Center(
      child: Text(
        'Availability coming soon',
        style: GoogleFonts.inter(color: Colors.white38),
      ),
    );
  }

  Widget _buildReviewsTab(Map<String, dynamic> business) {
    return Center(
      child: Text(
        'Reviews coming soon',
        style: GoogleFonts.inter(color: Colors.white38),
      ),
    );
  }

  Widget _buildLocationTab(Map<String, dynamic> business) {
    return Center(
      child: Text(
        'Location coming soon',
        style: GoogleFonts.inter(color: Colors.white38),
      ),
    );
  }

  // Helper Methods
  IconData _getGenderIcon(GenderPolicy policy) {
    switch (policy) {
      case GenderPolicy.womenOnly:
        return Icons.woman_rounded;
      case GenderPolicy.menOnly:
        return Icons.man_rounded;
      case GenderPolicy.unisex:
        return Icons.people_rounded;
      case GenderPolicy.segregated:
        return Icons.family_restroom_rounded;
    }
  }

  Color _getGenderColor(GenderPolicy policy) {
    switch (policy) {
      case GenderPolicy.womenOnly:
        return const Color(0xFFDB2777);
      case GenderPolicy.menOnly:
        return const Color(0xFF2563EB);
      case GenderPolicy.unisex:
        return const Color(0xFF8B5CF6);
      case GenderPolicy.segregated:
        return const Color(0xFF10B981);
    }
  }

  Map<String, dynamic> _getMockBusiness() {
    return {
      'id': widget.businessId,
      'name': 'Premium Photography Studio',
      'category': BusinessCategory.photographyVideo,
      'rating': 4.8,
      'reviews': 234,
      'priceRange': PriceRange.premium,
      'distance': 3.5,
      'coverImage': 'https://picsum.photos/800/400?random=1',
      'photoCount': 45,
      'isVerified': true,
      'genderPolicy': GenderPolicy.unisex,
      'hasPrivateRoom': true,
      'hasParking': true,
      'responseTime': 30,
      'startingPrice': 25000,
      'description':
          'We are a premium photography studio specializing in wedding photography and videography. Our team of experienced photographers captures your special moments with artistic excellence and attention to detail. We offer complete packages including pre-wedding shoots, wedding day coverage, and professional editing.',
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.backgroundDark,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}
