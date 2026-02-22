import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class BookingDetailPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    // Mock booking data
    final booking = {
      'id': bookingId,
      'businessName': 'Glam Studio',
      'serviceName': 'Bridal Makeup Package',
      'providerName': 'Sarah Khan',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '10:00 AM',
      'status': BookingStatus.confirmed,
      'price': 15000,
      'address': '123 Main Blvd, Gulberg, Lahore',
      'imageUrl': 'https://picsum.photos/400/300',
    };

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, booking),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatusBanner(booking['status'] as BookingStatus),
                const SizedBox(height: 24),
                _buildBookingInfo(booking),
                const SizedBox(height: 24),
                _buildPaymentSummary(booking),
                const SizedBox(height: 24),
                _buildActionButtons(context, booking),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Map<String, dynamic> booking) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.backgroundDark,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing booking details...')),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              booking['imageUrl'] as String,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BookingStatus status) {
    Color color;
    IconData icon;
    String message;

    switch (status) {
      case BookingStatus.confirmed:
        color = AppColors.success;
        icon = Icons.check_circle_rounded;
        message = 'Your booking is confirmed. See you there!';
        break;
      case BookingStatus.pending:
        color = AppColors.warning;
        icon = Icons.access_time_filled_rounded;
        message = 'Waiting for provider confirmation.';
        break;
      case BookingStatus.cancelled:
        color = AppColors.error;
        icon = Icons.cancel_rounded;
        message = 'This booking has been cancelled.';
        break;
      case BookingStatus.completed:
        color = AppColors.primaryLight;
        icon = Icons.task_alt_rounded;
        message = 'Booking completed. How was it?';
        break;
      default:
        color = Colors.grey;
        icon = Icons.info_rounded;
        message = 'Status unknown';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildBookingInfo(Map<String, dynamic> booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          booking['serviceName'] as String,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'by ${booking['businessName']}',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.primaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        _buildInfoRow(Icons.calendar_today_rounded,
            DateFormat('EEEE, MMMM d, y').format(booking['date'] as DateTime)),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.access_time_rounded, booking['time'] as String),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.location_on_rounded, booking['address'] as String),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.person_rounded, booking['providerName'] as String,
            label: 'Provider'),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildInfoRow(IconData icon, String text, {String? label}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null)
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary(Map<String, dynamic> booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentRow('Service Price', booking['price'] as int),
          const SizedBox(height: 8),
          _buildPaymentRow(
              'Tax (5%)', ((booking['price'] as int) * 0.05).round()),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white12),
          ),
          _buildPaymentRow(
              'Total Amount', ((booking['price'] as int) * 1.05).round(),
              isTotal: true),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildPaymentRow(String label, int amount, {bool isTotal = false}) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.white : Colors.white70,
          ),
        ),
        Text(
          currencyFormat.format(amount),
          style: GoogleFonts.inter(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.primaryLight : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, Map<String, dynamic> booking) {
    final status = booking['status'] as BookingStatus;

    if (status == BookingStatus.cancelled) {
      return const Center(
          child: Text(
        'Booking Cancelled',
        style: TextStyle(color: Colors.white54),
      ));
    }

    return Column(
      children: [
        if (status == BookingStatus.confirmed ||
            status == BookingStatus.pending) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push(
                    '/messages/chat/${booking['businessId'] ?? '123'}?name=${booking['businessName']}');
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Message Provider'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDeep,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showCancelDialog(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Cancel Booking'),
            ),
          ),
        ],
        if (status == BookingStatus.completed)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review feature coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Write a Review'),
            ),
          ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.surfaceDark,
              title: const Text(
                'Cancel Booking?',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Are you sure you want to cancel? This action cannot be undone.',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Perform cancellation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking cancelled successfully'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      context.pop();
                    },
                    child: const Text(
                      'Yes, Cancel',
                      style: TextStyle(color: AppColors.error),
                    )),
              ],
            ));
  }
}
