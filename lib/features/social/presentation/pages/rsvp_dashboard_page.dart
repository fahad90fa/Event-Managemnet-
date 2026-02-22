import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wedding_app/features/guests/presentation/bloc/guest_bloc.dart';
import 'package:wedding_app/features/guests/domain/guest_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';

class RsvpDashboardPage extends StatelessWidget {
  const RsvpDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Stack(
            children: [
              // Consistent Dynamic Background
              const _BackgroundMesh(),

              BlocBuilder<GuestBloc, GuestState>(
                builder: (context, state) {
                  if (state is GuestLoading || state is GuestInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GuestLoaded) {
                    return _buildPremiumDashboard(
                        context, state.guests, lang.language);
                  }
                  return Center(
                    child: Text('failed_to_load'.tr(lang.language),
                        style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPremiumDashboard(
      BuildContext context, List<GuestEntity> guests, AppLanguage language) {
    final confirmed =
        guests.where((g) => g.rsvpStatus == RSVPStatus.attending).length;
    final pending =
        guests.where((g) => g.rsvpStatus == RSVPStatus.pending).length;
    final declined =
        guests.where((g) => g.rsvpStatus == RSVPStatus.declined).length;
    final notSent =
        guests.where((g) => g.rsvpStatus == RSVPStatus.notSent).length;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context, language),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildSummaryGrid(
                  confirmed, pending, declined, notSent, language),
              const SizedBox(height: 40),
              _buildChartSection(
                  confirmed, pending, declined, notSent, language),
              const SizedBox(height: 40),
              Text("recent_responses".tr(language),
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              _buildRecentResponses(guests, language),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, AppLanguage language) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text("rsvp_title".tr(language),
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            )),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 50, bottom: 16),
      ),
      actions: [
        IconButton(
          onPressed: () => context.read<LanguageBloc>().add(ToggleLanguage()),
          icon: const Icon(Icons.translate, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid(int confirmed, int pending, int declined,
      int notSent, AppLanguage language) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _PremiumSummaryCard(
          label: "confirmed".tr(language),
          value: confirmed.toString(),
          color: Colors.greenAccent,
          icon: Icons.check_circle_outline_rounded,
          delay: 0,
        ),
        _PremiumSummaryCard(
          label: "pending".tr(language),
          value: pending.toString(),
          color: Colors.orangeAccent,
          icon: Icons.hourglass_empty_rounded,
          delay: 100,
        ),
        _PremiumSummaryCard(
          label: "declined".tr(language),
          value: declined.toString(),
          color: Colors.redAccent,
          icon: Icons.cancel_outlined,
          delay: 200,
        ),
        _PremiumSummaryCard(
          label: "not_sent".tr(language),
          value: notSent.toString(),
          color: Colors.white54,
          icon: Icons.send_and_archive_rounded,
          delay: 300,
        ),
      ],
    );
  }

  Widget _buildChartSection(int confirmed, int pending, int declined,
      int notSent, AppLanguage language) {
    final total = confirmed + pending + declined + notSent;
    if (total == 0) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text("distribution".tr(language).toUpperCase(),
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: confirmed.toDouble(),
                    color: Colors.greenAccent,
                    radius: 30,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: pending.toDouble(),
                    color: Colors.orangeAccent,
                    radius: 25,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: declined.toDouble(),
                    color: Colors.redAccent,
                    radius: 20,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: notSent.toDouble(),
                    color: Colors.white24,
                    radius: 15,
                    showTitle: false,
                  ),
                ],
                centerSpaceRadius: 60,
                sectionsSpace: 4,
              ),
            ),
          ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecentResponses(List<GuestEntity> guests, AppLanguage language) {
    final responsiveGuests =
        guests.where((g) => g.rsvpStatus != RSVPStatus.notSent).toList();

    return Column(
      children: responsiveGuests
          .take(5)
          .map((guest) => _PremiumGuestTile(guest: guest))
          .toList(),
    );
  }
}

class _PremiumSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final int delay;

  const _PremiumSummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.delay,
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
              spreadRadius: -5)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.1), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900)),
                    Text(label,
                        style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: delay.ms).fadeIn().scale(begin: const Offset(0.9, 0.9));
  }
}

class _PremiumGuestTile extends StatelessWidget {
  final GuestEntity guest;

  const _PremiumGuestTile({required this.guest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: guest.side == GuestSide.bride
                ? AppColors.royalGradient
                : AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            backgroundColor: AppColors.backgroundDark,
            child: Text(guest.name[0],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        title: Text(guest.name,
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.w700)),
        subtitle: Text(guest.relation,
            style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: _rsvpPremiumBadge(guest.rsvpStatus),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _rsvpPremiumBadge(RSVPStatus status) {
    Color color;
    switch (status) {
      case RSVPStatus.attending:
        color = Colors.greenAccent;
        break;
      case RSVPStatus.pending:
        color = Colors.orangeAccent;
        break;
      case RSVPStatus.declined:
        color = Colors.redAccent;
        break;
      case RSVPStatus.notSent:
        color = Colors.white24;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(status.name.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5)),
    );
  }
}

class _BackgroundMesh extends StatelessWidget {
  const _BackgroundMesh();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.midnightGradient)),
        Positioned(
          top: 100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.2),
                  Colors.transparent
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 12.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.4, 1.4)),
        ),
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
