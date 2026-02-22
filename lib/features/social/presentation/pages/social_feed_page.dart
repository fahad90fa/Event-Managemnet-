import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';
import '../bloc/social_bloc.dart';
import '../widgets/post_card.dart';

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Stack(
            children: [
              // Animated Background Mesh (consistent with Dashboard)
              const _BackgroundMesh(),

              BlocBuilder<SocialBloc, SocialState>(
                builder: (context, state) {
                  if (state is SocialInitial) {
                    context.read<SocialBloc>().add(LoadPosts());
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SocialLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SocialError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.white)));
                  }
                  if (state is SocialLoaded) {
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        _buildAppBar(context, lang.language),
                        SliverToBoxAdapter(
                          child: _buildStorySection(lang.language)
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.1, end: 0),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return PostCard(
                                        post: state.posts[index], index: index)
                                    .animate()
                                    .fadeIn(
                                        duration: 600.ms,
                                        delay: (index * 100).ms)
                                    .scale(
                                        begin: const Offset(0.95, 0.95),
                                        end: const Offset(1, 1));
                              },
                              childCount: state.posts.length,
                            ),
                          ),
                        ),
                        const SliverPadding(
                            padding: EdgeInsets.only(bottom: 120)),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddPostSheet(context, lang.language),
            backgroundColor: AppColors.primaryDeep,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_a_photo, size: 20),
            label: Text("share_memory".tr(lang.language),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ).animate().scale(delay: 1.seconds, curve: Curves.easeOutBack),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, AppLanguage language) {
    return SliverAppBar(
      expandedHeight: 140.0,
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
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text("social_title".tr(language),
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            )),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 50, bottom: 16),
      ),
      actions: [
        // Live Mode Indicator Button
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: InkWell(
                  onTap: () => context.push('/live-event-screen'),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .fadeIn(duration: 500.ms)
                          .fadeOut(duration: 500.ms),
                      const SizedBox(width: 8),
                      Text("LIVE",
                          style: GoogleFonts.inter(
                              color: Colors.red,
                              fontWeight: FontWeight.w900,
                              fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.read<LanguageBloc>().add(ToggleLanguage()),
          icon: const Icon(Icons.translate, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildStorySection(AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Text(
            "stories".tr(language).toUpperCase(),
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 8,
            itemBuilder: (context, index) {
              if (index == 0) return _buildAddStory(language);
              return _buildStoryItem(index);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddStory(AppLanguage language) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primaryDeep.withValues(alpha: 0.3),
                    blurRadius: 10)
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text("your_story".tr(language),
              style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStoryItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(26)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://i.pravatar.cc/150?u=wedding_$index',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Guest $index',
              style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showAddPostSheet(BuildContext context, AppLanguage language) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 30),
              Text("share_memory".tr(language),
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Say something beautiful...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined,
                        size: 50, color: AppColors.primaryLight),
                    const SizedBox(height: 12),
                    Text("upload_photos".tr(language),
                        style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context
                          .read<SocialBloc>()
                          .add(CreatePost(controller.text, const []));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: AppColors.primaryDeep.withValues(alpha: 0.5),
                  ),
                  child: Text("post_to_feed".tr(language),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
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
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.midnightGradient)),
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDeep.withValues(alpha: 0.3),
                  Colors.transparent
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 10.seconds,
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2)),
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
