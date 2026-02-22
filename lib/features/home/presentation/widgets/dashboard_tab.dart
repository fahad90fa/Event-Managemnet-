import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/domain/entities/notification_entities.dart';
import '../../../../core/config/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/localization/translator.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../analytics/presentation/pages/analytics_dashboard_page.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 0: Animated Background Mesh
        const _BackgroundMesh(),

        // Layer 1: Content
        RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh
            context.read<NotificationBloc>().add(LoadNotifications('user-1'));
            await Future.delayed(const Duration(seconds: 2));
          },
          color: AppColors.primaryDeep,
          backgroundColor: AppColors.surfaceLight,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Greeting & Profile
                    const _HeaderSection(),
                    const SizedBox(height: 32),

                    // Hero Countdown (Layer 1 with 3D tilt)
                    const _HeroCountdownCard(),
                    const SizedBox(height: 32),

                    // Metrics Grid
                    const _MetricsGrid(),
                    const SizedBox(height: 32),

                    // Planning Tools
                    BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, lang) => Text(
                        "planning_tools".tr(lang.language),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 16),
                    const _PlanningToolsGrid(),
                    const SizedBox(height: 32),

                    // Notifications Feed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<LanguageBloc, LanguageState>(
                          builder: (context, lang) => Text(
                            "latest_updates".tr(lang.language),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/notifications'),
                          child: BlocBuilder<LanguageBloc, LanguageState>(
                            builder: (context, lang) => Text(
                              "see_all".tr(lang.language),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 16),

                    BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is NotificationsLoaded &&
                            state.notifications.isNotEmpty) {
                          return Column(
                            children: state.notifications
                                .take(2)
                                .map((n) => _GlassNotificationCard(
                                      title: n.title,
                                      message: n.body,
                                      icon: n.title.contains('Payment')
                                          ? Icons.warning_amber_rounded
                                          : Icons.mark_email_read,
                                      color: n.priority ==
                                              NotificationPriority.urgent
                                          ? AppColors.warning
                                          : AppColors.secondary,
                                      delay: 200,
                                      onTap: () =>
                                          context.push('/notifications'),
                                    ))
                                .toList(),
                          );
                        }
                        return const Center(
                            child: Text("No new updates",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)));
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanningToolsGrid extends StatelessWidget {
  const _PlanningToolsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _ToolCard(
          title: "seating".tr(context.read<LanguageBloc>().state.language),
          subtitle: "Map layout",
          icon: Icons.chair_alt_rounded,
          color: Colors.purpleAccent,
          onTap: () => context.push('/seating'),
        ),
        _ToolCard(
          title: "wallet".tr(context.read<LanguageBloc>().state.language),
          subtitle: "Payments",
          icon: Icons.account_balance_wallet_rounded,
          color: Colors.greenAccent,
          onTap: () => context.push('/payments'),
        ),
        _ToolCard(
          title: "vendor_bids".tr(context.read<LanguageBloc>().state.language),
          subtitle: "8 active bids",
          icon: Icons.gavel_rounded,
          color: Colors.orangeAccent,
          onTap: () => context.push('/my-requests'),
        ),
        _ToolCard(
          title: "gifts".tr(context.read<LanguageBloc>().state.language),
          subtitle: "Registry",
          icon: Icons.card_giftcard_rounded,
          color: Colors.blueAccent,
          onTap: () => context.push('/gift-registry'),
        ),
        _ToolCard(
          title: "check_in".tr(context.read<LanguageBloc>().state.language),
          subtitle: "Scan tickets",
          icon: Icons.qr_code_scanner_rounded,
          color: Colors.tealAccent,
          onTap: () => context.push('/check-in-scanner'),
        ),
        _ToolCard(
          title: "guide".tr(context.read<LanguageBloc>().state.language),
          subtitle: "Cultural Rasala",
          icon: Icons.menu_book_rounded,
          color: Colors.amberAccent,
          onTap: () => context.push('/rasala-guide'),
        ),
        _ToolCard(
          title: "daftar".tr(context.read<LanguageBloc>().state.language),
          subtitle: "Legal & IDs",
          icon: Icons.gavel_rounded,
          color: Colors.deepPurpleAccent,
          onTap: () => context.push('/shadi-daftar'),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
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
        // Deep Base
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.midnightGradient,
          ),
        ),

        // Animated Orbs with Glass-refraction simulation
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.4),
                  Colors.transparent
                ],
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                  duration: 8.seconds,
                  begin: const Offset(1, 1),
                  end: const Offset(1.3, 1.3))
              .moveY(begin: 0, end: 100, duration: 10.seconds),
        ),

        Positioned(
          bottom: 100,
          left: -150,
          child: Container(
            width: 550,
            height: 550,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.2),
                  Colors.transparent
                ],
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveX(begin: 0, end: 50, duration: 12.seconds)
              .scale(
                  begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
        ),

        // Subtle Grain/Noise overlay simulation
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "wedding_in".tr(lang.language),
                  style: GoogleFonts.inter(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "greeting".tr(lang.language),
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 22, // Adjusted for local scripts
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Premium Language Toggle
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () =>
                            context.read<LanguageBloc>().add(ToggleLanguage()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            lang.language == AppLanguage.english
                                ? "اردو"
                                : "EN",
                            style: GoogleFonts.inter(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => context.push('/notifications'),
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is NotificationsLoaded) {
                        count = state.unreadCount;
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.heroGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryDeep
                                      .withValues(alpha: 0.3),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.backgroundDark,
                              child: Icon(Icons.person_outline,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          if (count > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.backgroundDark,
                                      width: 2),
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ).animate().scale(curve: Curves.elasticOut),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn().slideY(begin: -0.2, end: 0);
      },
    );
  }
}

class _HeroCountdownCard extends StatelessWidget {
  const _HeroCountdownCard();

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(0.05),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated Glare
                Positioned.fill(
                  child: Container().animate(onPlay: (c) => c.repeat()).shimmer(
                      duration: 3.seconds,
                      color: Colors.white.withValues(alpha: 0.1)),
                ),

                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CountdownUnit("45", "days"),
                      _Divider(),
                      _CountdownUnit("12", "hours"),
                      _Divider(),
                      _CountdownUnit("30", "mins"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack).fadeIn();
  }
}

class _CountdownUnit extends StatelessWidget {
  final String value;
  final String label;

  const _CountdownUnit(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.heroGradient.createShader(bounds),
          child: Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          label.tr(context.read<LanguageBloc>().state.language),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0),
          ],
        )));
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _MetricCard(
              label: "AI Budget",
              value: "Forecast",
              icon: Icons.auto_awesome,
              color: AppColors.secondary,
              onTap: () => context.push('/budget-ai'),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, lang) => _MetricCard(
                label: "guests".tr(lang.language),
                value: "240",
                icon: Icons.people,
                color: AppColors.primaryLight,
                onTap: () => _navigateToAnalytics(context),
              ),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, lang) => _MetricCard(
                label: "social_feed".tr(lang.language),
                value: "Live",
                icon: Icons.forum_outlined,
                color: Colors.purple,
                onTap: () => context.push('/social'),
              ),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, lang) => _MetricCard(
                label: "seating".tr(lang.language),
                value: "Planner",
                icon: Icons.event_seat,
                color: Colors.orange,
                onTap: () => context.push('/seating'),
              ),
            )),
          ],
        ),
      ],
    ).animate().slideY(begin: 0.2, end: 0, delay: 300.ms);
  }

  void _navigateToAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalyticsDashboardPage(
          weddingId: 'mock-wedding-123',
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.all(20),
                height: 130,
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient(color),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().scale(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1, 1),
        duration: 400.ms,
        curve: Curves.easeOutBack);
  }
}

class _GlassNotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final int delay;
  final VoidCallback? onTap;

  const _GlassNotificationCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.delay,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.glassColor.withValues(alpha: 0.4),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: AppColors.textTertiary, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: 0.1, end: 0);
  }
}
