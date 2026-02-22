import 'dart:async';
import '../../domain/entities/notification_entities.dart';
import '../../domain/repositories/notification_repository.dart';

class MockNotificationService implements NotificationRepository {
  final List<WeddingNotification> _notifications = [];
  final _controller = StreamController<List<WeddingNotification>>.broadcast();

  MockNotificationService() {
    _notifications.addAll([
      WeddingNotification(
        id: 'n-1',
        recipientUserId: 'user-1',
        title: 'Payment Deadline',
        body: 'Post-event balance for Royal Marquee is due tomorrow.',
        channels: const ['push', 'in_app'],
        priority: NotificationPriority.urgent,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      WeddingNotification(
        id: 'n-2',
        recipientUserId: 'user-1',
        title: 'New RSVP - Bride Side',
        body: 'Amna Zafar +3 family members have confirmed (Lahore).',
        channels: const ['in_app'],
        priority: NotificationPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ]);

    _controller.add(List.from(_notifications));

    // Simulate "Smart" real-time notifications arriving
    Timer(const Duration(seconds: 15), () {
      _addNewNotification(
        title: 'Real-time RSVP',
        body: 'Zaid & Sara just confirmed for the Valima.',
        priority: NotificationPriority.medium,
      );
    });

    Timer(const Duration(seconds: 40), () {
      _addNewNotification(
        title: 'Urgent Payment',
        body: 'Catering deposit for Tuscany Courtyard is pending.',
        priority: NotificationPriority.high,
      );
    });
  }

  void _addNewNotification(
      {required String title,
      required String body,
      required NotificationPriority priority}) {
    final newNotif = WeddingNotification(
      id: 'n-${DateTime.now().millisecondsSinceEpoch}',
      recipientUserId: 'user-1',
      title: title,
      body: body,
      channels: const ['in_app', 'push'],
      priority: priority,
      createdAt: DateTime.now(),
    );
    _notifications.insert(0, newNotif);
    _controller.add(List.from(_notifications));
  }

  @override
  Future<List<WeddingNotification>> getNotifications(String userId) async {
    return _notifications.where((n) => n.recipientUserId == userId).toList();
  }

  @override
  Stream<List<WeddingNotification>> getNotificationStream(String userId) {
    return _controller.stream
        .map((list) => list.where((n) => n.recipientUserId == userId).toList());
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final n = _notifications[index];
      _notifications[index] = WeddingNotification(
        id: n.id,
        recipientUserId: n.recipientUserId,
        title: n.title,
        body: n.body,
        channels: n.channels,
        priority: n.priority,
        createdAt: n.createdAt,
        isRead: true,
      );
      _controller.add(List.from(_notifications));
    }
  }

  @override
  Future<void> updatePreferences(
      String userId, Map<String, dynamic> preferences) async {}

  @override
  Future<Map<String, dynamic>> getPreferences(String userId) async {
    return {
      'guest_updates': {'push': true, 'email': true},
      'payment_reminders': {'push': true, 'sms': true},
    };
  }
}
