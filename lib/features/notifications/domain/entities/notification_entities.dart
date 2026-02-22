import 'package:equatable/equatable.dart';

enum NotificationCategory {
  guestUpdates,
  paymentReminders,
  vendorCommunication,
  eventAlerts,
  systemNotifications
}

class NotificationTemplate extends Equatable {
  final String id;
  final String templateCode;
  final String templateName;
  final NotificationCategory category;
  final String defaultTitle;
  final String defaultBody;
  final List<String> supportedChannels;

  const NotificationTemplate({
    required this.id,
    required this.templateCode,
    required this.templateName,
    required this.category,
    required this.defaultTitle,
    required this.defaultBody,
    required this.supportedChannels,
  });

  @override
  List<Object?> get props => [
        id,
        templateCode,
        templateName,
        category,
        defaultTitle,
        defaultBody,
        supportedChannels
      ];
}

enum NotificationPriority { low, medium, high, urgent }

class WeddingNotification extends Equatable {
  final String id;
  final String recipientUserId;
  final String? weddingProjectId;
  final String title;
  final String body;
  final Map<String, dynamic>? dataPayload;
  final List<String> channels;
  final NotificationPriority priority;
  final DateTime createdAt;
  final bool isRead;

  const WeddingNotification({
    required this.id,
    required this.recipientUserId,
    this.weddingProjectId,
    required this.title,
    required this.body,
    this.dataPayload,
    required this.channels,
    this.priority = NotificationPriority.low,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
        id,
        recipientUserId,
        weddingProjectId,
        title,
        body,
        dataPayload,
        channels,
        priority,
        createdAt,
        isRead
      ];
}
