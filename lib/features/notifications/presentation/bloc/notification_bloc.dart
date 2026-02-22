import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entities.dart';
import '../../domain/repositories/notification_repository.dart';

// Events
abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;
  LoadNotifications(this.userId);
  @override
  List<Object?> get props => [userId];
}

class StartNotificationSubscription extends NotificationEvent {
  final String userId;
  StartNotificationSubscription(this.userId);
  @override
  List<Object?> get props => [userId];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;
  MarkNotificationAsRead(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class _NotificationsUpdated extends NotificationEvent {
  final List<WeddingNotification> notifications;
  _NotificationsUpdated(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

// States
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<WeddingNotification> notifications;
  final int unreadCount;
  final bool isLatestBatch; // Used to trigger animations or toasters

  NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
    this.isLatestBatch = false,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, isLatestBatch];
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  StreamSubscription? _subscription;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await repository.getNotifications(event.userId);
        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(NotificationsLoaded(
            notifications: notifications, unreadCount: unreadCount));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<StartNotificationSubscription>((event, emit) {
      _subscription?.cancel();
      _subscription = repository
          .getNotificationStream(event.userId)
          .listen((notifications) {
        add(_NotificationsUpdated(notifications));
      });
    });

    on<_NotificationsUpdated>((event, emit) {
      final unreadCount = event.notifications.where((n) => !n.isRead).length;
      bool hasNew = false;

      if (state is NotificationsLoaded) {
        final current = (state as NotificationsLoaded).notifications;
        if (event.notifications.length > current.length) {
          hasNew = true;
        }
      }

      emit(NotificationsLoaded(
        notifications: event.notifications,
        unreadCount: unreadCount,
        isLatestBatch: hasNew,
      ));
    });

    on<MarkNotificationAsRead>((event, emit) async {
      try {
        await repository.markAsRead(event.notificationId);
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
