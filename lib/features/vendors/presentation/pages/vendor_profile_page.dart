import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../domain/vendor_entity.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProfilePage extends StatelessWidget {
  final VendorEntity vendor;

  const VendorProfilePage({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Parallax Hero Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ).animate().fadeIn(delay: 500.ms),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ).animate().fadeIn(delay: 600.ms),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ).animate().fadeIn(delay: 700.ms),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder Gradient/Image
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.5,
                        colors: [
                          AppColors.primaryDeep.withValues(alpha: 0.4),
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.storefront,
                          size: 80, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                  // Title on Image
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDeep,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            vendor.category.toUpperCase(),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          vendor.name,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.goldAccent, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              "${vendor.rating} (${vendor.reviewsCount} Reviews)",
                              style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.location_on,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            const Text(
                              "Islamabad",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ).animate().slideY(begin: 0.2, end: 0, duration: 600.ms),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs (Package / Portfolio / Reviews)
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _TabChip(label: "Packages", isSelected: true),
                        _TabChip(label: "Portfolio", isSelected: false),
                        _TabChip(label: "Reviews", isSelected: false),
                        _TabChip(label: "About", isSelected: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Package Section
                  Text("Popular Packages",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 16),

                  const _PackageCard(
                    title: "Silver Package",
                    price: "PKR 350,000",
                    features: [
                      "1 Day Coverage",
                      "1 Senior Photographer",
                      "Digital Album",
                      "100 Edited Photos"
                    ],
                    isHighlighted: false,
                  ),
                  const _PackageCard(
                    title: "Gold Package",
                    price: "PKR 550,000",
                    features: [
                      "2 Days Coverage",
                      "2 Senior Photographers",
                      "Drone Coverage",
                      "Storybook Album"
                    ],
                    isHighlighted: true,
                  ),

                  const SizedBox(height: 120), // Space for Sticky Bottom Bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          boxShadow: [AppColors.darkShadow],
          border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Starting from",
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary, fontSize: 12)),
                Text(vendor.startPrice,
                    style: GoogleFonts.inter(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Book or Chat
                },
                child: const Text("Request Quote"),
              ),
            ),
          ],
        ),
      )
          .animate()
          .slideY(begin: 1, end: 0, delay: 800.ms, curve: Curves.easeOutBack),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TabChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.primaryGradient : null,
        color: isSelected ? null : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isHighlighted;

  const _PackageCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: isHighlighted
            ? Border.all(color: AppColors.gold, width: 1.5)
            : Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textPrimary)),
              if (isHighlighted) const Icon(Icons.star, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: 12),
          Text(price,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.primaryLight)),
          const SizedBox(height: 24),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.successLight, size: 20),
                    const SizedBox(width: 12),
                    Text(f,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}
