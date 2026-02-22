import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/config/theme/app_colors.dart';

class AdminShellPage extends StatefulWidget {
  final Widget child;
  const AdminShellPage({super.key, required this.child});

  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  int _selectedIndex = 0;

  final List<_AdminNavItem> _navItems = [
    _AdminNavItem(Icons.dashboard_rounded, 'Overview', '/admin/dashboard'),
    _AdminNavItem(
        Icons.devices_other_rounded, 'Devices & Telemetry', '/admin/devices'),
    _AdminNavItem(
        Icons.security_rounded, 'Permissions Audit', '/admin/permissions'),
    _AdminNavItem(Icons.lan_rounded, 'Network Intelligence', '/admin/network'),
    _AdminNavItem(Icons.people_alt_rounded, 'User Base', '/admin/users'),
    _AdminNavItem(
        Icons.storefront_rounded, 'Business Registry', '/admin/vendors'),
    _AdminNavItem(
        Icons.receipt_long_rounded, 'Inventory & Ops', '/admin/bookings'),
    _AdminNavItem(Icons.account_balance_wallet_rounded, 'Financial Flow',
        '/admin/finance'),
    _AdminNavItem(Icons.gavel_rounded, 'Legal & Disputes', '/admin/disputes'),
    _AdminNavItem(Icons.article_rounded, 'Content (CMS)', '/admin/cms'),
    _AdminNavItem(Icons.campaign_rounded, 'Growth Engine', '/admin/marketing'),
    _AdminNavItem(
        Icons.settings_suggest_rounded, 'Infrastructure', '/admin/config'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      drawer: !isDesktop
          ? Drawer(
              width: 300,
              backgroundColor: const Color(0xFF0F172A),
              child: _buildSidebar(context),
            )
          : null,
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryDeep.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Row(
            children: [
              if (isDesktop) _buildSidebar(context),
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(context, showMenu: !isDesktop),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: widget.child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
            right: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 48),
          _buildBrand(),
          const SizedBox(height: 48),
          Text(
            'DEPARTMENTAL CONTROL',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;
                return _buildNavTile(item, index, isSelected);
              },
            ),
          ),
          _buildAdminProfile(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDeep.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset('assets/images/logo.png', width: 28, height: 28),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BookMyEvent',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'EXECUTIVE PORTAL',
              style: GoogleFonts.inter(
                color: AppColors.primaryLight.withValues(alpha: 0.6),
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavTile(_AdminNavItem item, int index, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => _selectedIndex = index);
            context.go(item.route);
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.primaryDeep.withValues(alpha: 0.15),
                        AppColors.primaryDeep.withValues(alpha: 0.02),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(
                      color: AppColors.primaryDeep.withValues(alpha: 0.3))
                  : Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? AppColors.primaryLight : Colors.white24,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLight.withValues(alpha: 0.6),
                          blurRadius: 8,
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
    );
  }

  Widget _buildAdminProfile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?u=fahad'),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fahad Abbas',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                Text(
                  'Super Admin',
                  style: TextStyle(color: Colors.white24, fontSize: 11),
                ),
              ],
            ),
          ),
          _PulseAction(
            child: const Icon(Icons.settings_power_rounded,
                color: Colors.redAccent, size: 18),
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {bool showMenu = false}) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: Row(
        children: [
          if (showMenu) ...[
            Builder(
              builder: (scaffoldContext) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Search Command Bar
          Expanded(
            child: Container(
              height: 48,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: Colors.white24, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isMobile ? 'Search...' : 'Instant Search (CMD + K)',
                      style: GoogleFonts.inter(
                          color: Colors.white24,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isMobile) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('⌘ K',
                          style: GoogleFonts.inter(
                              color: Colors.white24,
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 32),
            _buildHealthStatus(),
            const SizedBox(width: 32),
            const _IconBadge(icon: Icons.notifications_none_rounded, count: 5),
          ],
        ],
      ),
    );
  }

  Widget _buildHealthStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            'NODE: OPTIMAL',
            style: GoogleFonts.inter(
              color: Colors.green.withValues(alpha: 0.8),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
          duration: 3.seconds, color: Colors.green.withValues(alpha: 0.2)),
    );
  }
}

class _AdminNavItem {
  final IconData icon;
  final String label;
  final String route;
  _AdminNavItem(this.icon, this.label, this.route);
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  const _IconBadge({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(icon, color: Colors.white60, size: 26),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: AppColors.primaryDeep, shape: BoxShape.circle),
            child: Text(
              count.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseAction extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PulseAction({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
