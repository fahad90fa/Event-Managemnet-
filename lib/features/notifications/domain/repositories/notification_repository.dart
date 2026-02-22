import '../../domain/entities/notification_entities.dart';

abstract class NotificationRepository {
  Future<List<WeddingNotification>> getNotifications(String userId);
  Stream<List<WeddingNotification>> getNotificationStream(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> updatePreferences(
      String userId, Map<String, dynamic> preferences);
  Future<Map<String, dynamic>> getPreferences(String userId);
}
