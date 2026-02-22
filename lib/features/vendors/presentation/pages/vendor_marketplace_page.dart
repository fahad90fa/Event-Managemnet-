import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../domain/vendor_entity.dart';
import '../widgets/vendor_card.dart';
import 'vendor_profile_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';

class VendorMarketplacePage extends StatefulWidget {
  const VendorMarketplacePage({super.key});

  @override
  State<VendorMarketplacePage> createState() => _VendorMarketplacePageState();
}

class _VendorMarketplacePageState extends State<VendorMarketplacePage> {
  // Mock Data
  final List<VendorEntity> _vendors = [
    const VendorEntity(
        id: '1',
        name: 'Pearl Continental',
        category: 'Venue',
        rating: 4.8,
        reviewsCount: 124,
        startPrice: 'PKR 3500/head',
        imageUrl: '',
        isFeatured: true),
    const VendorEntity(
        id: '2',
        name: 'Studios 89',
        category: 'Photography',
        rating: 4.9,
        reviewsCount: 89,
        startPrice: 'PKR 150k',
        imageUrl: ''),
    const VendorEntity(
        id: '3',
        name: 'Hanif Jewelers',
        category: 'Jewelry',
        rating: 4.7,
        reviewsCount: 302,
        startPrice: 'PKR 500k',
        imageUrl: '',
        isFeatured: true),
    const VendorEntity(
        id: '4',
        name: 'Sana Safinaz',
        category: 'Bridal Wear',
        rating: 4.6,
        reviewsCount: 56,
        startPrice: 'PKR 250k',
        imageUrl: ''),
    const VendorEntity(
        id: '5',
        name: 'Tuscany Courtyard',
        category: 'Catering',
        rating: 4.5,
        reviewsCount: 20,
        startPrice: 'PKR 2800/head',
        imageUrl: ''),
    const VendorEntity(
        id: '6',
        name: 'Events by Nabila',
        category: 'Decor',
        rating: 4.9,
        reviewsCount: 45,
        startPrice: 'PKR 500k',
        imageUrl: ''),
  ];

  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    "all",
    "venues",
    "photography",
    "catering",
    "bridal_wear",
    "makeup"
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Stack(
            children: [
              // Signature Animated Background
              const _BackgroundMesh(),

              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildPremiumAppBar(context, lang.language),

                  // AI Recommendation Section
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: AppColors.secondary, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                "smart_match".tr(lang.language).toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                        ),
                        SizedBox(
                          height: 220,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: 3,
                            separatorBuilder: (c, i) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final vendor = _vendors[index];
                              return SizedBox(
                                width: 170,
                                child: VendorCard(
                                  vendor: vendor,
                                  index: index,
                                  isAiMatch: true,
                                  onTap: () => _navigateToProfile(vendor),
                                ),
                              );
                            },
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.1, end: 0),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // Categories Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Text(
                        "all_vendors".tr(lang.language).toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textSecondary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  // Category Chips
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _categories.length,
                          separatorBuilder: (c, i) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final isSelected = index == _selectedCategoryIndex;
                            return GestureDetector(
                              onTap: () => setState(
                                  () => _selectedCategoryIndex = index),
                              child: AnimatedContainer(
                                duration: 300.ms,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? AppColors.royalGradient
                                      : null,
                                  color: isSelected
                                      ? null
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Colors.white12,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryDeep
                                                .withValues(alpha: 0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  _categories[index].tr(lang.language),
                                  style: GoogleFonts.inter(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(delay: (50 * index).ms)
                                .scale(begin: const Offset(0.9, 0.9));
                          },
                        ),
                      ),
                    ),
                  ),

                  // Grid of Vendors
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return VendorCard(
                            vendor: _vendors[index],
                            index: index,
                            onTap: () => _navigateToProfile(_vendors[index]),
                          );
                        },
                        childCount: _vendors.length,
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'vendor_fab',
            onPressed: () => context.push('/create-bid-request'),
            label: Text("post_requirement".tr(lang.language).toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900, letterSpacing: 1)),
            icon: const Icon(Icons.auto_awesome_rounded),
            backgroundColor: AppColors.primaryDeep,
            foregroundColor: Colors.white,
          )
              .animate()
              .slideY(begin: 1, end: 0, delay: 600.ms)
              .scale(curve: Curves.easeOutBack),
        );
      },
    );
  }

  Widget _buildPremiumAppBar(BuildContext context, AppLanguage language) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      pinned: true,
      centerTitle: false,
      expandedHeight: 120,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: Text(
          "marketplace".tr(language),
          style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              fontSize: 22),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.read<LanguageBloc>().add(ToggleLanguage()),
          icon: const Icon(Icons.translate, color: Colors.white70),
        ),
        IconButton(
          onPressed: () => context.push('/my-requests'),
          tooltip: 'my_requests'.tr(language),
          icon: const Icon(Icons.assignment_ind_rounded, color: Colors.white70),
        ),
      ],
    );
  }

  void _navigateToProfile(VendorEntity vendor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VendorProfilePage(vendor: vendor),
      ),
    );
  }
}

class _BackgroundMesh extends StatelessWidget {
  const _BackgroundMesh();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.midnightGradient)),
        Positioned(
          top: -150,
          left: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.2),
                  Colors.transparent
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 10.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.3, 1.3)),
        ),
        Opacity(
          opacity: 0.03,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.transparenttextures.com/patterns/stardust.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
