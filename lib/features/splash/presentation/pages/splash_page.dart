import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // Simulations of loading/initializing
    Future.delayed(const Duration(seconds: 5), () async {
      // Check if it's first time permissions
      final prefs = await SharedPreferences.getInstance();
      final permissionsRequested =
          prefs.getBool('permissions_requested') ?? false;

      if (mounted) {
        if (!permissionsRequested) {
          context.go('/permissions');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Gradient Background
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      AppColors.primary,
                      Color(0xFF8E44AD), // Slightly lighter purple
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // Simple alignment interpolation for movement effect
                    transform: GradientRotation(
                        _gradientController.value * 2 * pi * 0.1),
                  ),
                ),
              );
            },
          ),

          // 2. Particles
          const ParticleOverlay(),

          // 3. Content (Logo + Tagline)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ).animate().fade(duration: 800.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                    curve: Curves.easeOutBack),

                const SizedBox(height: 24),

                // Tagline with Typing Effect
                const TypingText(
                  text: "Plan Your Dream Event",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                  duration: Duration(milliseconds: 2000),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),

          // 4. Loading Indicator (bottom)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                strokeWidth: 2,
              ).animate().fade(delay: 1000.ms),
            ),
          )
        ],
      ),
    );
  }
}

// Simple Typing Text Widget
class TypingText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const TypingText({
    super.key,
    required this.text,
    required this.style,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: text.length),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          text.substring(0, value),
          style: style,
        );
      },
    );
  }
}

// Particle Overlay
class ParticleOverlay extends StatelessWidget {
  const ParticleOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate some random particles
    // For performance, we create a fixed number of widgets
    return IgnorePointer(
      child: Stack(
        children: List.generate(15, (index) {
          final random = Random(index);
          return Positioned(
            left: random.nextDouble() * 400, // rough screen width
            top: random.nextDouble() * 800, // rough screen height
            child: Container(
              width: random.nextDouble() * 4 + 2,
              height: random.nextDouble() * 4 + 2,
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: random.nextDouble() * 0.5),
                shape: BoxShape.circle,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .moveY(
                  begin: 0,
                  end: -100 - random.nextDouble() * 100,
                  duration: Duration(seconds: 5 + random.nextInt(5)),
                )
                .fadeOut(
                  curve: Curves.easeIn,
                  duration: Duration(seconds: 5 + random.nextInt(5)),
                ),
          );
        }),
      ),
    );
  }
}
