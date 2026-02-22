import 'package:flutter/material.dart';

class AppColors {
  // Midnight Celebration Palette

  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F0F0F); // Deepest charcoal
  static const Color backgroundLight = Color(0xFF1A1A1A); // Lighter charcoal
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF252525);

  // Primary Accents (Royal Purple to Violet)
  static const Color primaryDeep = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFA78BFA);

  // Secondary Accents (Rose Gold Metallic)
  static const Color secondary = Color(0xFFE8B4B8);
  static const Color secondaryLight =
      Color(0xFFF3EAC2); // Champagne / Light Rose Gold
  static const Color gold = Color(0xFFFFD700);

  // Tertiary Accents (Emerald Success)
  static const Color successDeep = Color(0xFF059669);
  static const Color successLight = Color(0xFF10B981);

  // Text Colors
  static const Color textPrimary = Color(0xFFF5F5F5); // Soft white
  static const Color textSecondary = Color(0xFFA3A3A3); // Warm gray
  static const Color textTertiary = Color(0xFF737373); // Muted gray
  static const Color textInverse = Colors.black; // For light buttons

  // Functional Colors
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = successDeep; // Alias for compatibility

  // Gradients
  static const LinearGradient midnightGradient = LinearGradient(
    colors: [backgroundDark, backgroundLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDeep, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFFFDF80), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryDeep, Color(0xFFE8B4B8), gold], // Purple -> Pink -> Gold
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surfaceDark, surfaceLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient royalGradient = LinearGradient(
    colors: [Color(0xFF4B0082), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient glassGradient(Color color) => LinearGradient(
        colors: [
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Shadows
  static BoxShadow glassShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 24,
    offset: const Offset(0, 8),
  );

  static BoxShadow glowShadow = BoxShadow(
    color: primaryDeep.withValues(alpha: 0.4),
    blurRadius: 20,
    spreadRadius: -4,
    offset: const Offset(0, 8),
  );

  static BoxShadow goldShadow = BoxShadow(
    color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );

  // Aliases for compatibility
  static const Color primary = primaryLight;
  static const Color background = backgroundDark;
  static const Color surface = surfaceDark;
  static const Color goldAccent = gold;
  static const LinearGradient initialGradient = primaryGradient;

  static BoxShadow lightShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.12),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow darkShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );

  // Glassmorphism System
  static Color glassColor = Colors.black.withValues(alpha: 0.6); // Dark glass
  static Color glassBorder = Colors.white.withValues(alpha: 0.1);
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);
}
