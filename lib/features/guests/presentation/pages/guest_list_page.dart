import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';
import '../bloc/guest_bloc.dart';
import '../widgets/guest_list_item.dart';

class GuestListPage extends StatelessWidget {
  const GuestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestBloc()..add(LoadGuests()),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, lang) {
          final language = lang.language;
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Stack(
              children: [
                // Global Premium Background
                const _BackgroundMesh(),

                SafeArea(
                  bottom: false,
                  child: BlocBuilder<GuestBloc, GuestState>(
                    builder: (context, state) {
                      if (state is GuestLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is GuestInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is GuestLoaded) {
                        return CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            _buildPremiumHeader(context, state, language),

                            // Search and Filter Pod
                            SliverToBoxAdapter(
                              child: _buildSearchAndFilterPod(
                                  context, state, language),
                            ),

                            if (state.filteredGuests.isEmpty)
                              const SliverFillRemaining(
                                hasScrollBody: false,
                                child: _EmptyState(),
                              )
                            else
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final guest = state.filteredGuests[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: GuestListItem(
                                          guest: guest,
                                          index: index,
                                          onDelete: () => context
                                              .read<GuestBloc>()
                                              .add(DeleteGuest(guest.id)),
                                        )
                                            .animate()
                                            .fadeIn(delay: (index * 50).ms)
                                            .slideX(begin: 0.1, end: 0),
                                      );
                                    },
                                    childCount: state.filteredGuests.length,
                                  ),
                                ),
                              ),
                            const SliverPadding(
                                padding: EdgeInsets.only(bottom: 120)),
                          ],
                        );
                      }
                      return const Center(
                          child: Text("Something went wrong",
                              style: TextStyle(color: Colors.white70)));
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'guest_fab',
              onPressed: () {},
              backgroundColor: AppColors.primaryDeep,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_rounded),
              label: Text("add_guest".tr(language).toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, letterSpacing: 1)),
            )
                .animate()
                .slideY(begin: 1, end: 0, delay: 500.ms)
                .scale(curve: Curves.easeOutBack),
          );
        },
      ),
    );
  }

  Widget _buildPremiumHeader(
      BuildContext context, GuestLoaded state, AppLanguage language) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 20, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                Text(
                  "guest_list_title".tr(language),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.royalGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primaryDeep.withValues(alpha: 0.3),
                      blurRadius: 10)
                ],
              ),
              child: Text(
                "${state.guests.length} ${"families".tr(language)}",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: -0.1, end: 0),
    );
  }

  Widget _buildSearchAndFilterPod(
      BuildContext context, GuestLoaded state, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          // Elegant Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (q) => context.read<GuestBloc>().add(SearchGuests(q)),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "search_vendors"
                    .tr(language), // Reusing vendor search key for consistency
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.secondary),
                border: InputBorder.none,
              ),
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // Side-Style Filter Chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildFilterChip(
                    context, "all".tr(language), "all", state.activeFilter),
                _buildFilterChip(
                    context,
                    "bride_side".tr(language).toUpperCase(),
                    "bride",
                    state.activeFilter),
                _buildFilterChip(
                    context,
                    "groom_side".tr(language).toUpperCase(),
                    "groom",
                    state.activeFilter),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildFilterChip(
      BuildContext context, String label, String value, String activeFilter) {
    final isSelected = activeFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            )),
        selected: isSelected,
        onSelected: (_) => context.read<GuestBloc>().add(FilterGuests(value)),
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.secondary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide.none,
        showCheckmark: false,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        final language = lang.language;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_off_rounded,
                size: 80, color: Colors.white10),
            const SizedBox(height: 24),
            Text(
              "no_guests_found".tr(language),
              style: GoogleFonts.playfairDisplay(
                  color: Colors.white38,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ).animate().fadeIn();
      },
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
          bottom: -100,
          right: -100,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.15),
                  Colors.transparent
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 15.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.3, 1.3)),
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
