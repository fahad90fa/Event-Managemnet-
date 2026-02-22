import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/security/behavioral_analytics_service.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../domain/entities/admin_models.dart';
import '../bloc/admin_bloc.dart';
import '../services/security_monitor_service.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 20,
              vertical: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 48),
                _buildMetricsGrid(context, state),
                const SizedBox(height: 48),
                _buildChartsSection(context, isDesktop, state),
                const SizedBox(height: 48),
                _buildTrafficMonitor(context),
                const SizedBox(height: 48),
                _buildSecondaryLowerSection(context, isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Mission Control Dashboard',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'System-wide analytics, performance tracking, and live oversight.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildMetricsGrid(BuildContext context, AdminState state) {
    final double width = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (width < 600) {
      crossAxisCount = 1;
    } else if (width < 1000) {
      crossAxisCount = 2;
    }

    final double totalRevenue =
        state.vendors.fold(0.0, (sum, item) => sum + item.revenue);
    final int pendingVendors = state.vendors
        .where((v) => v.status == VendorStatus.pendingApproval)
        .length;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: width < 600 ? 2.2 : 1.8,
      children: [
        _buildMetricCard(
          'Platform Revenue',
          'Rs. ${(totalRevenue / 1000).toStringAsFixed(1)}K',
          '+14.5%',
          true,
          Icons.account_balance_wallet_rounded,
          AppColors.primaryDeep,
        ),
        _buildMetricCard(
          'Platform Users',
          state.users.length.toString(),
          '+2.2%',
          true,
          Icons.people_alt_rounded,
          Colors.blueAccent,
        ),
        _buildMetricCard(
          'Approved Vendors',
          state.vendors
              .where((v) => v.status == VendorStatus.verified)
              .length
              .toString(),
          '+5.8%',
          true,
          Icons.storefront_rounded,
          AppColors.secondary,
        ),
        _buildMetricCard(
          'Pending Approval',
          pendingVendors.toString(),
          pendingVendors > 5 ? '+15%' : 'Stable',
          pendingVendors <= 5,
          Icons.hourglass_empty_rounded,
          pendingVendors > 5 ? AppColors.error : Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String growth,
      bool isPositive, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    _buildGrowthBadge(growth, isPositive),
                  ],
                ),
                const Spacer(),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildGrowthBadge(String growth, bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              (isPositive ? Colors.green : Colors.red).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 14,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            growth,
            style: GoogleFonts.inter(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(
      BuildContext context, bool isDesktop, AdminState state) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildProfessionalChart(context)),
          const SizedBox(width: 32),
          Expanded(flex: 1, child: _recentLivePulse(context, state)),
        ],
      );
    }
    return Column(
      children: [
        _buildProfessionalChart(context),
        const SizedBox(height: 32),
        _recentLivePulse(context, state),
      ],
    );
  }

  Widget _buildProfessionalChart(BuildContext context) {
    return _buildGlassContainer(
      context: context,
      title: 'Revenue Distribution & Growth',
      onAction: () {},
      child: Container(
        height: 350,
        padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (v) => FlLine(
                  color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ];
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(days[value.toInt()],
                            style: GoogleFonts.inter(
                                color: Colors.white24, fontSize: 11)),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 3.2),
                  const FlSpot(1, 4.5),
                  const FlSpot(2, 4.1),
                  const FlSpot(3, 5.8),
                  const FlSpot(4, 5.2),
                  const FlSpot(5, 7.1),
                  const FlSpot(6, 8.5),
                ],
                isCurved: true,
                gradient: const LinearGradient(
                    colors: [AppColors.primaryDeep, AppColors.primaryLight]),
                barWidth: 6,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryDeep.withValues(alpha: 0.15),
                      Colors.transparent
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentLivePulse(BuildContext context, AdminState state) {
    return _buildGlassContainer(
      context: context,
      title: 'Real-time Booking Pulse',
      onAction: () {},
      height: 440,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: state.bookings.length,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final booking = state.bookings[index];
          return Row(
            children: [
              _buildPulseDot(booking.status == BookingStatus.pending),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.white70),
                        children: [
                          TextSpan(
                              text: '${booking.userName} ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          TextSpan(text: 'booked ${booking.vendorName}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${booking.amount.toInt()} • Status: ${booking.status.name.toUpperCase()}',
                      style: GoogleFonts.inter(
                          color: Colors.white24,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPulseDot(bool isActive) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isActive)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                duration: 2.seconds,
                begin: const Offset(1, 1),
                end: const Offset(2.5, 2.5),
              )
              .fadeOut(),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : Colors.white12,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildTrafficMonitor(BuildContext context) {
    return _buildGlassContainer(
      context: context,
      title: 'Global Node Traffic & Density',
      onAction: () {},
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            const Opacity(
              opacity: 0.1,
              child: Center(
                child:
                    Icon(Icons.public_rounded, size: 250, color: Colors.white),
              ),
            ),
            _buildMapNode(0.3, 0.4, 'London', true, context),
            _buildMapNode(0.7, 0.3, 'Tokyo', true, context),
            _buildMapNode(0.5, 0.6, 'Lahore', true, context, isMajor: true),
            _buildMapNode(0.2, 0.7, 'New York', false, context),
            _buildMapNode(0.8, 0.8, 'Sydney', true, context),
            Positioned(
              bottom: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLegendItem('Major Hub', AppColors.primaryLight),
                  _buildLegendItem('Active Node', Colors.blueAccent),
                  _buildLegendItem('Dormant', Colors.white24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapNode(
      double x, double y, String label, bool active, BuildContext context,
      {bool isMajor = false}) {
    final color = isMajor
        ? AppColors.primaryLight
        : active
            ? Colors.blueAccent
            : Colors.white24;

    return Align(
      alignment: Alignment(x * 2 - 1, y * 2 - 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isMajor ? 12 : 8,
            height: isMajor ? 12 : 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                if (active)
                  BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                duration: 1.seconds,
                begin: const Offset(1, 1),
                end: isMajor ? const Offset(1.3, 1.3) : const Offset(1.1, 1.1),
              ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: GoogleFonts.inter(color: Colors.white24, fontSize: 9)),
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    final logs = SecurityMonitorService.getRecentLogs();

    return _buildGlassContainer(
      context: context,
      title: 'Active Security Intel (IDS/IPS)',
      onAction: () {},
      child: Column(
        children: logs.map((log) {
          final color = log.level == SecurityLevel.critical
              ? Colors.redAccent
              : log.level == SecurityLevel.warning
                  ? Colors.amberAccent
                  : Colors.greenAccent;

          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                log.level == SecurityLevel.critical
                    ? Icons.gpp_bad_rounded
                    : log.level == SecurityLevel.warning
                        ? Icons.gpp_maybe_rounded
                        : Icons.gpp_good_rounded,
                color: color,
                size: 20,
              ),
            ),
            title: Text(
              log.type,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
            subtitle: Text(
              '${log.message}\n${log.timestamp.hour}:${log.timestamp.minute} • IP: ${log.ipAddress ?? 'INTERNAL'}',
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
            ),
            isThreeLine: true,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Text(
                log.level.name.toUpperCase(),
                style: GoogleFonts.inter(
                    color: color, fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSecondaryLowerSection(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildValueCard(
                  'Audit Compliance', '98.2%', Icons.verified_user_rounded),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildValueCard(
                  'Handshake Latency', '84ms', Icons.bolt_rounded),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 24),
              Expanded(
                child: _buildValueCard(
                    'Success Rate', '99.9%', Icons.cloud_done_rounded),
              ),
            ],
          ],
        ),
        const SizedBox(height: 32),
        _buildSecuritySection(context),
      ],
    );
  }

  Widget _buildValueCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white24, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.2),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({
    required BuildContext context,
    required String title,
    required Widget child,
    required VoidCallback onAction,
    double? height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    if (title.contains('Security Intel'))
                      TextButton.icon(
                        icon: const Icon(Icons.warning_amber_rounded,
                            size: 16, color: Colors.orange),
                        label: const Text('ID ANOMALY TEST',
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          context
                              .read<BehavioralAnalyticsService>()
                              .simulateBotAttack();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Identity Anomaly Triggered. Watch for Adaptive Auth prompt.')),
                          );
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded,
                          color: Colors.white38),
                      onPressed: onAction,
                    ),
                  ],
                ),
              ),
              Divider(
                  color: Colors.white.withValues(alpha: 0.05), thickness: 1),
              if (height != null) Expanded(child: child) else child,
            ],
          ),
        ),
      ),
    );
  }
}
