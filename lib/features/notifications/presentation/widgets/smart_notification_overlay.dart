import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/notification_bloc.dart';
import '../../domain/entities/notification_entities.dart';

class SmartNotificationOverlay extends StatelessWidget {
  final Widget child;

  const SmartNotificationOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationsLoaded && state.isLatestBatch) {
          final latest = state.notifications.first;
          _showTopNotification(context, latest);
        }
      },
      child: child,
    );
  }

  void _showTopNotification(
      BuildContext context, WeddingNotification notification) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
              border: Border.all(
                  color: _getBorderColor(notification.priority), width: 2),
            ),
            child: Row(
              children: [
                _getIcon(notification.priority),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(notification.title,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(notification.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => entry.remove(),
                )
              ],
            ),
          )
              .animate()
              .slideY(
                  begin: -1,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutBack)
              .fadeIn()
              .then(delay: 4.seconds)
              .slideY(begin: 0, end: -1, duration: 400.ms, curve: Curves.easeIn)
              .fadeOut()
              .callback(callback: (_) => entry.remove()),
        ),
      ),
    );

    overlay.insert(entry);
  }

  Color _getBorderColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.urgent:
        return Colors.redAccent;
      case NotificationPriority.high:
        return Colors.orangeAccent;
      case NotificationPriority.medium:
        return Colors.blueAccent;
      default:
        return Colors.greenAccent;
    }
  }

  Widget _getIcon(NotificationPriority priority) {
    IconData icon;
    Color color;
    switch (priority) {
      case NotificationPriority.urgent:
        icon = Icons.warning_rounded;
        color = Colors.red;
        break;
      case NotificationPriority.high:
        icon = Icons.priority_high_rounded;
        color = Colors.orange;
        break;
      case NotificationPriority.medium:
        icon = Icons.info_rounded;
        color = Colors.blue;
        break;
      default:
        icon = Icons.notifications_active_rounded;
        color = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
