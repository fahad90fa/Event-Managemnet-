import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PremiumSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const PremiumSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  factory PremiumSkeleton.circle(double size) {
    return PremiumSkeleton(width: size, height: size, borderRadius: size / 2);
  }

  factory PremiumSkeleton.text({double height = 16, double width = 100}) {
    return PremiumSkeleton(width: width, height: height, borderRadius: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.white.withValues(alpha: 0.05),
      highlightColor: highlightColor ?? Colors.white.withValues(alpha: 0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
