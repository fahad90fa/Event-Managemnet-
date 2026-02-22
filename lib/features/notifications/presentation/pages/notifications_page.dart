import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final notifications = _getMockNotifications();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('All notifications marked as read'),
                  backgroundColor: AppColors.primaryDeep));
            },
            child: Text(
              'Mark all read',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < notifications.length - 1 ? 12 : 0,
                  ),
                  child: _NotificationCard(
                    notification: notifications[index],
                  )
                      .animate()
                      .fadeIn(delay: (index * 50).ms)
                      .slideX(begin: 0.2, end: 0),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white24,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white24,
            ),
          ),
        ],
      ).animate().fadeIn().scale(),
    );
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'id': 'notif_1',
        'type': 'booking_confirmed',
        'title': 'Booking Confirmed',
        'message':
            'Your booking at Glam Studio has been confirmed for tomorrow at 10 AM',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'isRead': false,
        'icon': Icons.check_circle_rounded,
        'color': AppColors.successDeep,
      },
      {
        'id': 'notif_2',
        'type': 'new_message',
        'title': 'New Message',
        'message': 'Royal Banquet sent you a message',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'icon': Icons.chat_bubble_rounded,
        'color': const Color(0xFF3B82F6),
      },
      {
        'id': 'notif_3',
        'type': 'deal',
        'title': 'Special Deal',
        'message': '20% off on wedding photography packages this week!',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'isRead': true,
        'icon': Icons.local_offer_rounded,
        'color': const Color(0xFFF59E0B),
      },
      {
        'id': 'notif_4',
        'type': 'reminder',
        'title': 'Booking Reminder',
        'message': 'Your appointment at Taste of Lahore is in 2 days',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'icon': Icons.schedule_rounded,
        'color': const Color(0xFF8B5CF6),
      },
    ];
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] as bool;
    final timestamp = notification['timestamp'] as DateTime;

    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? Colors.white.withValues(alpha: 0.03)
            : AppColors.primaryDeep.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.primaryDeep.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (notification['type'] == 'booking_confirmed') {
              context.push('/booking/booking_1');
            } else if (notification['type'] == 'new_message') {
              context.push('/messages/chat/conv_1?name=Royal Banquet');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Tapped: ${notification['title']}'),
                  backgroundColor: AppColors.primaryDeep));
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        (notification['color'] as Color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification['icon'] as IconData,
                    color: notification['color'] as Color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(timestamp),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }
}
