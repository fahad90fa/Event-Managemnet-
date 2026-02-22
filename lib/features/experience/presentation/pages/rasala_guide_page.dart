import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/core/config/theme/app_colors.dart';
import 'package:wedding_app/features/experience/domain/rasala_entities.dart';
import 'package:wedding_app/features/experience/data/mock_rasala_service.dart';
import 'package:wedding_app/core/config/localization/language_bloc.dart';
import 'package:wedding_app/core/config/localization/translator.dart';

class RasalaGuidePage extends StatefulWidget {
  const RasalaGuidePage({super.key});

  @override
  State<RasalaGuidePage> createState() => _RasalaGuidePageState();
}

class _RasalaGuidePageState extends State<RasalaGuidePage>
    with TickerProviderStateMixin {
  final MockRasalaService _service = MockRasalaService();
  List<RasalaGuide> _guides = [];
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    final guides = await _service.getGuides();
    setState(() {
      _guides = guides;
      _loading = false;
      _tabController = TabController(length: _guides.length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    const _BackgroundMesh(),
                    Column(
                      children: [
                        _buildPremiumAppBar(context, lang.language),
                        _buildPremiumTabBar(lang.language),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: _guides
                                .map((g) => _buildImmersiveGuideDetail(
                                    g, lang.language))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildPremiumAppBar(BuildContext context, AppLanguage language) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 20, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Text("rasala_title".tr(language),
                style: GoogleFonts.playfairDisplay(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 24)),
            IconButton(
              onPressed: () =>
                  context.read<LanguageBloc>().add(ToggleLanguage()),
              icon: const Icon(Icons.translate, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumTabBar(AppLanguage language) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.secondary,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        labelColor: Colors.white,
        labelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
        unselectedLabelColor: Colors.white38,
        unselectedLabelStyle:
            GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
        tabs: _guides
            .map((g) => Tab(text: g.ceremonyName.toUpperCase()))
            .toList(),
      ),
    );
  }

  Widget _buildImmersiveGuideDetail(RasalaGuide guide, AppLanguage language) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // Immersive Hero Section
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    guide.premiumBackgroundUrl ??
                        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guide.ceremonyName.toUpperCase(),
                          style: GoogleFonts.inter(
                              color: AppColors.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3)),
                      const SizedBox(height: 4),
                      Text(guide.venueName,
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900)),
                      Text(guide.ceremonyDate,
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),

        const SizedBox(height: 40),

        // About Content
        _SectionHeader(title: "about_ceremony".tr(language)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            guide.description,
            style: GoogleFonts.inter(
                color: Colors.white70, fontSize: 15, height: 1.6),
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 40),

        // Traditions Grid
        _SectionHeader(title: "key_traditions".tr(language)),
        const SizedBox(height: 20),
        ...guide.traditions
            .map((t) => _TraditionGlassCard(tradition: t, language: language)),

        const SizedBox(height: 40),

        // Dos & Donts
        _buildPremiumDosAndDonts(guide, language),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildPremiumDosAndDonts(RasalaGuide guide, AppLanguage language) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: _DosDontsBox(
                title: "dos".tr(language),
                items: guide.dos,
                color: Colors.greenAccent)),
        const SizedBox(width: 16),
        Expanded(
            child: _DosDontsBox(
                title: "donts".tr(language),
                items: guide.donts,
                color: Colors.redAccent)),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5),
    );
  }
}

class _TraditionGlassCard extends StatelessWidget {
  final CeremonyTradition tradition;
  final AppLanguage language;
  const _TraditionGlassCard({required this.tradition, required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded,
                        color: AppColors.secondary, size: 20),
                    const SizedBox(width: 12),
                    Text(tradition.title,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(tradition.description,
                    style: GoogleFonts.inter(
                        color: Colors.white70, fontSize: 14, height: 1.5)),
                if (tradition.culturalSignificance != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: AppColors.secondary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${"significance".tr(language)}: ${tradition.culturalSignificance}",
                            style: GoogleFonts.inter(
                                color: AppColors.secondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05, end: 0);
  }
}

class _DosDontsBox extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;

  const _DosDontsBox(
      {required this.title, required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                  title.contains('?')
                      ? Icons.close_rounded
                      : Icons.check_rounded,
                  color: color,
                  size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.inter(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("•",
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(item,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12))),
                  ],
                ),
              )),
        ],
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
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.midnightGradient)),
        Positioned(
          top: 200,
          right: -150,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.15),
                  Colors.transparent
                ],
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: 100, duration: 15.seconds),
        ),
      ],
    );
  }
}
