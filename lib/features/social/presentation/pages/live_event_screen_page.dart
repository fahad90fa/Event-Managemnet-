import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../bloc/social_bloc.dart';
import '../../domain/entities/social_post.dart';

class LiveEventScreenPage extends StatefulWidget {
  const LiveEventScreenPage({super.key});

  @override
  State<LiveEventScreenPage> createState() => _LiveEventScreenPageState();
}

class _LiveEventScreenPageState extends State<LiveEventScreenPage> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<SocialBloc, SocialState>(
        builder: (context, state) {
          if (state is SocialLoaded && state.posts.isNotEmpty) {
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final post = state.posts[index % state.posts.length];
                    return _buildPostSlide(post);
                  },
                ),
                _buildSidebarOverlay(),
                _buildBottomOverlay(),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPostSlide(SocialPost post) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: post.imageUrls.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(post.imageUrls.first),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.darken,
                ),
              )
            : null,
        gradient: post.imageUrls.isEmpty
            ? const LinearGradient(
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (post.userImageUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(post.userImageUrl!),
                ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
              const SizedBox(height: 20),
              Text(
                post.userName,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '"${post.content}"',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 48,
                  fontStyle: FontStyle.italic,
                  height: 1.3,
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarOverlay() {
    return Positioned(
      right: 40,
      top: 40,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            QrImageView(
              data: 'https://wedding-os.app/social',
              version: QrVersions.auto,
              size: 150.0,
            ),
            const SizedBox(height: 10),
            Text(
              'SCAN TO POST',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 1.seconds),
    );
  }

  Widget _buildBottomOverlay() {
    return Positioned(
      bottom: 40,
      left: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#SalmanWedsAyesha',
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
          Text(
            'LIVE EVENT FEED',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
