import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/dashboard_tab.dart';
import '../../../guests/presentation/pages/guest_list_page.dart';
import '../../../vendors/presentation/pages/vendor_marketplace_page.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../notifications/presentation/widgets/smart_notification_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardTab(),
    const GuestListPage(),
    const VendorMarketplacePage(),
    const WalletPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Start listening for real-time notifications
    // context
    //     .read<NotificationBloc>()
    //     .add(StartNotificationSubscription('user-1'));
    // Commented out until NotificationBloc is fully ready or mocked
  }

  @override
  Widget build(BuildContext context) {
    return SmartNotificationOverlay(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Body Content
              IndexedStack(
                index: _currentIndex,
                children: _tabs,
              ),

              // Premium Gold Floating Action Button
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        AppColors.goldShadow,
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 10,
                          spreadRadius: -2,
                          offset: Offset(-2, -2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Expand logic
                        },
                        customBorder: const CircleBorder(),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 36),
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                          delay: 3000.ms,
                          duration: 1500.ms,
                          color: Colors.white.withValues(alpha: 0.5))
                      .animate()
                      .scale(
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0.5, 0.5)),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
