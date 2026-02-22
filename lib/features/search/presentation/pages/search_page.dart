import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';
import '../widgets/search_filter_drawer.dart';
import '../widgets/search_result_card.dart';
import '../widgets/map_list_toggle.dart';

class SearchPage extends StatefulWidget {
  final String? query;
  final BusinessCategory? category;

  const SearchPage({super.key, this.query, this.category});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isMapView = false;
  String _sortBy = 'recommended'; // recommended, price, rating, distance

  // Filters
  List<String> _selectedAreas = [];
  double _minBudget = 0;
  double _maxBudget = 100000;
  DateTime? _availabilityDate;
  double? _minRating;
  bool _verifiedOnly = false;
  bool _hasDeals = false;
  GenderPolicy? _genderFilter;

  @override
  void initState() {
    super.initState();
    if (widget.query != null) {
      _searchController.text = widget.query!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          // Search Header
          _buildSearchHeader(),

          // Quick Filters Bar
          _buildQuickFiltersBar(),

          // Results
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white),
                  onPressed: () => context.pop(),
                ),

                // Search Field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: widget.query == null,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search services...',
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
                      ),
                      onSubmitted: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Search for $value'),
                            behavior: SnackBarBehavior.floating));
                        setState(() {});
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Filter Button
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.white),
                    onPressed: _showFilterDrawer,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Results count & Sort
            Row(
              children: [
                Text(
                  '${_getMockResults().length} results',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
                const Spacer(),
                MapListToggle(
                  isMapView: _isMapView,
                  onToggle: (isMap) {
                    setState(() {
                      _isMapView = isMap;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _buildSortButton(),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildQuickFiltersBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildQuickFilterChip(
            label: 'Budget',
            icon: Icons.attach_money_rounded,
            isActive: _minBudget > 0 || _maxBudget < 100000,
            onTap: _showFilterDrawer,
          ),
          const SizedBox(width: 8),
          _buildQuickFilterChip(
            label: 'Date',
            icon: Icons.calendar_today_rounded,
            isActive: _availabilityDate != null,
            onTap: _showFilterDrawer,
          ),
          const SizedBox(width: 8),
          _buildQuickFilterChip(
            label: 'Distance',
            icon: Icons.location_on_rounded,
            isActive: _selectedAreas.isNotEmpty,
            onTap: _showFilterDrawer,
          ),
          const SizedBox(width: 8),
          _buildQuickFilterChip(
            label: 'Rating',
            icon: Icons.star_rounded,
            isActive: _minRating != null,
            onTap: _showFilterDrawer,
          ),
          const SizedBox(width: 8),
          _buildQuickFilterChip(
            label: 'Ladies-only',
            icon: Icons.woman_rounded,
            isActive: _genderFilter == GenderPolicy.womenOnly,
            onTap: () {
              setState(() {
                _genderFilter = _genderFilter == GenderPolicy.womenOnly
                    ? null
                    : GenderPolicy.womenOnly;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildQuickFilterChip(
            label: 'Men-only',
            icon: Icons.man_rounded,
            isActive: _genderFilter == GenderPolicy.menOnly,
            onTap: () {
              setState(() {
                _genderFilter = _genderFilter == GenderPolicy.menOnly
                    ? null
                    : GenderPolicy.menOnly;
              });
            },
          ),
          const SizedBox(width: 8),
          _buildQuickFilterChip(
            label: 'Verified',
            icon: Icons.verified_rounded,
            isActive: _verifiedOnly,
            onTap: () {
              setState(() {
                _verifiedOnly = !_verifiedOnly;
              });
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildQuickFilterChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryDeep.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primaryDeep
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primaryLight : Colors.white54,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primaryLight : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _sortBy = value;
        });
      },
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      itemBuilder: (context) => [
        _buildSortMenuItem('Recommended', 'recommended'),
        _buildSortMenuItem('Price: Low to High', 'price'),
        _buildSortMenuItem('Rating', 'rating'),
        _buildSortMenuItem('Distance', 'distance'),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sort_rounded,
              color: Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'Sort',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String label, String value) {
    final isSelected = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryLight : Colors.white,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(
              Icons.check_rounded,
              color: AppColors.primaryLight,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListView() {
    final results = _getMockResults();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: index < results.length - 1 ? 16 : 80),
          child: SearchResultCard(
            business: results[index],
            onTap: () => context.push('/business/${results[index]['id']}'),
          ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2, end: 0),
        );
      },
    );
  }

  Widget _buildMapView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.map_outlined,
            color: Colors.white24,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Map View',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SearchFilterDrawer(
        selectedAreas: _selectedAreas,
        minBudget: _minBudget,
        maxBudget: _maxBudget,
        availabilityDate: _availabilityDate,
        minRating: _minRating,
        verifiedOnly: _verifiedOnly,
        hasDeals: _hasDeals,
        genderFilter: _genderFilter,
        onApply: (filters) {
          setState(() {
            _selectedAreas = filters['areas'] as List<String>;
            _minBudget = filters['minBudget'] as double;
            _maxBudget = filters['maxBudget'] as double;
            _availabilityDate = filters['date'] as DateTime?;
            _minRating = filters['minRating'] as double?;
            _verifiedOnly = filters['verifiedOnly'] as bool;
            _hasDeals = filters['hasDeals'] as bool;
            _genderFilter = filters['genderFilter'] as GenderPolicy?;
          });
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getMockResults() {
    // Mock data - will be replaced with real search results
    return List.generate(10, (index) {
      return {
        'id': 'business_$index',
        'name': 'Premium ${widget.category?.label ?? "Service"} ${index + 1}',
        'category': widget.category ?? BusinessCategory.photographyVideo,
        'rating': 4.5 + (index * 0.05),
        'reviews': 100 + (index * 20),
        'priceRange': PriceRange.values[index % PriceRange.values.length],
        'distance': 2.5 + index,
        'imageUrl': 'https://picsum.photos/400/300?random=$index',
        'isVerified': index % 3 == 0,
        'hasDeals': index % 4 == 0,
        'genderPolicy': GenderPolicy.values[index % GenderPolicy.values.length],
        'responseTime': 30 + (index * 10),
      };
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
