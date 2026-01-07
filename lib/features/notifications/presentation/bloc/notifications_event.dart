part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsRequested extends NotificationsEvent {
  final bool refresh;
  const FetchNotificationsRequested({this.refresh = false});
}

class MarkNotificationAsReadRequested extends NotificationsEvent {
  final String id;
  const MarkNotificationAsReadRequested(this.id);
  @override
  List<Object> get props => [id];
}

class MarkAllNotificationsAsReadRequested extends NotificationsEvent {}

class DeleteNotificationRequested extends NotificationsEvent {
  final String id;
  const DeleteNotificationRequested(this.id);
  @override
  List<Object> get props => [id];
}

class FetchUnreadCountRequested extends NotificationsEvent {}
