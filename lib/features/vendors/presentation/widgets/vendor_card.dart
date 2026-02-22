import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../domain/vendor_entity.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';

class VendorCard extends StatelessWidget {
  final VendorEntity vendor;
  final VoidCallback onTap;
  final int index;
  final bool isAiMatch;

  const VendorCard({
    super.key,
    required this.vendor,
    required this.onTap,
    required this.index,
    this.isAiMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    final language = context.read<LanguageBloc>().state.language;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(0.02),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Section with Aspect Ratio
                    AspectRatio(
                      aspectRatio: 1.1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.primaries[
                                          index % Colors.primaries.length]
                                      .withValues(alpha: 0.15),
                                  AppColors.surface
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Icon(Icons.storefront_rounded,
                                color: Colors
                                    .primaries[index % Colors.primaries.length]
                                    .withValues(alpha: 0.3),
                                size: 50),
                          ),
                          // Premium Overlay Gradient
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.backgroundDark
                                        .withValues(alpha: 0.9),
                                  ],
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          if (vendor.isFeatured || isAiMatch)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: isAiMatch
                                      ? AppColors.primaryGradient
                                      : AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isAiMatch
                                              ? AppColors.primaryDeep
                                              : AppColors.gold)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                        isAiMatch
                                            ? Icons.auto_awesome
                                            : Icons.star,
                                        color: isAiMatch
                                            ? Colors.white
                                            : Colors.black,
                                        size: 12),
                                    const SizedBox(width: 6),
                                    Text(
                                      isAiMatch
                                          ? "best_value".tr(language)
                                          : "Featured",
                                      style: GoogleFonts.inter(
                                        color: isAiMatch
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .animate(
                                      onPlay: (c) => c.repeat(period: 4000.ms))
                                  .shimmer(
                                      delay: 1.seconds, duration: 2.seconds),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryDeep.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              vendor.category.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            vendor.name,
                            style: GoogleFonts.playfairDisplay(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 16, color: AppColors.gold),
                              const SizedBox(width: 4),
                              Text(
                                vendor.rating.toString(),
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "(${vendor.reviewsCount})",
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "starts_from".tr(language),
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    vendor.startPrice,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: AppColors.textTertiary, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .scale(begin: const Offset(0.9, 0.9), delay: (index * 50).ms)
        .fadeIn(duration: 600.ms, delay: (100 * index).ms);
  }
}
