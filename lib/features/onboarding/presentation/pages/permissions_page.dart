import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/theme/app_colors.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _isRequesting = false;

  final List<PermissionItem> _permissions = [
    PermissionItem(
      permission: Permission.location,
      title: 'Location Access',
      subtitle: 'To find vendors and venues near your celebration area.',
      icon: Icons.location_on_rounded,
      color: const Color(0xFF6366F1),
    ),
    PermissionItem(
      permission: Permission.storage,
      title: 'Storage & Gallery',
      subtitle: 'To upload photos for your event feed and vendor requirements.',
      icon: Icons.photo_library_rounded,
      color: const Color(0xFFEC4899),
    ),
    PermissionItem(
      permission: Permission.contacts,
      title: 'Contacts',
      subtitle: 'To easily invite your family and friends to the events.',
      icon: Icons.people_alt_rounded,
      color: const Color(0xFF10B981),
    ),
    PermissionItem(
      permission: Permission.phone,
      title: 'Phone & Call Logs',
      subtitle: 'To synchronize vendor communication and call history.',
      icon: Icons.call_rounded,
      color: const Color(0xFFF59E0B),
    ),
  ];

  Future<void> _requestAllPermissions() async {
    setState(() => _isRequesting = true);

    try {
      // Request one by one for better UX
      for (var item in _permissions) {
        await item.permission.request();
      }

      // Mark permissions as requested
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('permissions_requested', true);

      if (mounted) {
        context.go('/login');
      }
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Premium Background
          const _PremiumBackground(),

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Header
                _buildHeader(),

                const SizedBox(height: 40),

                // Permission List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _permissions.length,
                    itemBuilder: (context, index) {
                      return _buildPermissionCard(_permissions[index], index);
                    },
                  ),
                ),

                // Action Button
                _buildActionButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.security_rounded,
              color: AppColors.secondary,
              size: 32,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            "Essential Permissions",
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 12),
          Text(
            "BookMyEvent needs these permissions to provide a complete and personalized experience.",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white60,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(PermissionItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white.withValues(alpha: 0.05),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icon, color: item.color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (600 + index * 100).ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(20),
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
            onTap: _isRequesting ? null : _requestAllPermissions,
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: _isRequesting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "ALLOW PERMISSIONS",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.5, end: 0);
  }
}

class PermissionItem {
  final Permission permission;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  PermissionItem({
    required this.permission,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Animated Orbs
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 8.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2)),
        ),

        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 10.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.3, 1.3)),
        ),
      ],
    );
  }
}
