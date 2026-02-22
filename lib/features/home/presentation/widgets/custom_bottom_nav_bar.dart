import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated Indicator Pill
                AnimatedPositioned(
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                  left: _getIndicatorPosition(context),
                  top: 15,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDeep.withValues(alpha: 0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(duration: 2.seconds),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.grid_view_rounded,
                      label: "Home",
                      isSelected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavBarItem(
                      icon: Icons.people_outline_rounded,
                      label: "Guests",
                      isSelected: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                    _NavBarItem(
                      icon: Icons.storefront_outlined,
                      label: "Vendors",
                      isSelected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                    _NavBarItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: "Wallet",
                      isSelected: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(
        begin: 1.0, end: 0, duration: 600.ms, curve: Curves.easeOutBack);
  }

  double _getIndicatorPosition(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width - 40; // Total width minus margins
    final itemWidth = width / 4;
    return (currentIndex * itemWidth) +
        (itemWidth / 2) -
        25; // Center of item minus half pill width
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24,
            )
                .animate(target: isSelected ? 1 : 0)
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
            const SizedBox(height: 4),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().moveY(begin: 5, end: 0)
            else
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
