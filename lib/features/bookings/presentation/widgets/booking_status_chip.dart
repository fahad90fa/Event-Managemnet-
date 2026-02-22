import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../marketplace/domain/enums/marketplace_enums.dart';

class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;
  final bool isLarge;

  const BookingStatusChip({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 14 : 10,
        vertical: isLarge ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: config['color'].withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(isLarge ? 10 : 8),
        border: Border.all(
          color: config['color'].withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config['icon'],
            color: config['color'],
            size: isLarge ? 16 : 12,
          ),
          SizedBox(width: isLarge ? 6 : 4),
          Text(
            config['label'],
            style: GoogleFonts.inter(
              fontSize: isLarge ? 13 : 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return {
          'label': 'Pending',
          'icon': Icons.schedule_rounded,
          'color': const Color(0xFFF59E0B),
        };
      case BookingStatus.confirmed:
        return {
          'label': 'Confirmed',
          'icon': Icons.check_circle_rounded,
          'color': AppColors.successDeep,
        };
      case BookingStatus.inProgress:
        return {
          'label': 'In Progress',
          'icon': Icons.autorenew_rounded,
          'color': const Color(0xFF3B82F6),
        };
      case BookingStatus.completed:
        return {
          'label': 'Completed',
          'icon': Icons.done_all_rounded,
          'color': const Color(0xFF10B981),
        };
      case BookingStatus.cancelled:
        return {
          'label': 'Cancelled',
          'icon': Icons.cancel_rounded,
          'color': AppColors.error,
        };
      case BookingStatus.refunded:
        return {
          'label': 'Refunded',
          'icon': Icons.money_off_rounded,
          'color': const Color(0xFF9CA3AF),
        };
    }
  }
}
