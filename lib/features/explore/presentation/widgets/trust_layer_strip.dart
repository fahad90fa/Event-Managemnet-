import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';

class TrustLayerStrip extends StatelessWidget {
  const TrustLayerStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildBadge(
            icon: Icons.verified_rounded,
            label: 'Verified Businesses',
            color: AppColors.successDeep,
          ),
          const SizedBox(width: 12),
          _buildBadge(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Cash/IBFT Supported',
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 12),
          _buildBadge(
            icon: Icons.woman_rounded,
            label: 'Women-only Options',
            color: const Color(0xFFDB2777),
          ),
          const SizedBox(width: 12),
          _buildBadge(
            icon: Icons.local_offer_outlined,
            label: 'Special Deals',
            color: AppColors.gold,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
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
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
          duration: 3.seconds,
          color: color.withValues(alpha: 0.2),
        );
  }
}
