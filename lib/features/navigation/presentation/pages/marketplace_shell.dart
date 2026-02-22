import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../bookings/presentation/pages/bookings_page.dart';
import '../../../messages/presentation/pages/messages_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/marketplace_bottom_nav.dart';
import '../widgets/contextual_fab.dart';

class MarketplaceShell extends StatefulWidget {
  const MarketplaceShell({super.key});

  @override
  State<MarketplaceShell> createState() => _MarketplaceShellState();
}

class _MarketplaceShellState extends State<MarketplaceShell> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const ExplorePage(),
    const CategoriesPage(),
    const BookingsPage(),
    const MessagesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: MarketplaceBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      floatingActionButton: ContextualFAB(
        currentIndex: _currentIndex,
      ).animate().scale(delay: 500.ms),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
