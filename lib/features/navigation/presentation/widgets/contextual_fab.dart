import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';

class ContextualFAB extends StatelessWidget {
  final int currentIndex;

  const ContextualFAB({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show FAB on certain pages
    if (currentIndex == 4) {
      // Hide on Profile page
      return const SizedBox.shrink();
    }

    final config = _getFABConfig(currentIndex);

    return Container(
      decoration: BoxDecoration(
        gradient: config['gradient'] as Gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleFABTap(context, currentIndex),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  config['icon'] as IconData,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  config['label'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getFABConfig(int index) {
    switch (index) {
      case 0: // Explore
        return {
          'icon': Icons.search_rounded,
          'label': 'Search Services',
          'gradient': AppColors.heroGradient,
        };
      case 1: // Categories
        return {
          'icon': Icons.filter_list_rounded,
          'label': 'Filter',
          'gradient': AppColors.royalGradient,
        };
      case 2: // Bookings
        return {
          'icon': Icons.add_rounded,
          'label': 'New Booking',
          'gradient': AppColors.heroGradient,
        };
      case 3: // Messages
        return {
          'icon': Icons.edit_rounded,
          'label': 'New Message',
          'gradient': AppColors.royalGradient,
        };
      default:
        return {
          'icon': Icons.add_rounded,
          'label': 'Add',
          'gradient': AppColors.heroGradient,
        };
    }
  }

  void _handleFABTap(BuildContext context, int index) {
    switch (index) {
      case 0: // Explore - Open search
        context.push('/search');
        break;
      case 1: // Categories - Show filter
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Filter feature coming soon!'),
            backgroundColor: AppColors.primaryDeep));
        break;
      case 2: // Bookings - New booking
        context.push('/explore');
        break;
      case 3: // Messages - New message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Business selector coming soon!'),
            backgroundColor: AppColors.primaryDeep));
        break;
    }
  }
}
