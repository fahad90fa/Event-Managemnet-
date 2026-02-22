import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';
import 'booking_status_chip.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = booking['businessCategory'] as BusinessCategory;
    final status = booking['status'] as BookingStatus;
    final date = booking['date'] as DateTime;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: AppColors.surfaceDark,
            child: Column(
              children: [
                // Image Header
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundDark,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        booking['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surfaceDark,
                            child: const Icon(
                              Icons.image_outlined,
                              color: Colors.white24,
                              size: 48,
                            ),
                          );
                        },
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Status Badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: BookingStatusChip(status: status),
                      ),

                      // Category Badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category.label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business Name
                      Text(
                        booking['businessName'],
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Service Name
                      Text(
                        booking['serviceName'],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Date & Time
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primaryLight,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('MMM dd, yyyy').format(date),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.primaryLight,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            booking['time'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Price & Actions
                      Row(
                        children: [
                          Text(
                            '₨${NumberFormat('#,###').format(booking['price'])}',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondary,
                            ),
                          ),
                          const Spacer(),
                          if (status == BookingStatus.pending ||
                              status == BookingStatus.confirmed)
                            _buildActionButton(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: 'Message',
                              onTap: () {
                                context.push(
                                    '/messages/chat/${booking['businessId'] ?? '123'}?name=${booking['businessName']}');
                              },
                            ),
                          if (status == BookingStatus.pending) ...[
                            const SizedBox(width: 8),
                            _buildActionButton(
                              icon: Icons.close_rounded,
                              label: 'Cancel',
                              color: AppColors.error,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cancellation requested'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: (color ?? AppColors.primaryDeep).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (color ?? AppColors.primaryDeep).withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color ?? AppColors.primaryLight,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
