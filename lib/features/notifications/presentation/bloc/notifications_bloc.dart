import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/di/injection.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

@lazySingleton
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _repository;
  LogService get _logger => getIt<LogService>();

  NotificationsBloc(this._repository) : super(const NotificationsState()) {
    on<FetchNotificationsRequested>(_onFetchNotificationsRequested);
    on<MarkNotificationAsReadRequested>(_onMarkNotificationAsReadRequested);
    on<MarkAllNotificationsAsReadRequested>(
      _onMarkAllNotificationsAsReadRequested,
    );
    on<DeleteNotificationRequested>(_onDeleteNotificationRequested);
    on<FetchUnreadCountRequested>(_onFetchUnreadCountRequested);
  }

  Future<void> _onFetchNotificationsRequested(
    FetchNotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    _logger.info(
      'Récupération des notifications (page: ${state.page}, refresh: ${event.refresh})...',
      component: 'NotificationsBloc',
    );
    if (event.refresh) {
      emit(
        state.copyWith(
          status: NotificationsStatus.loading,
          notifications: [],
          page: 1,
          hasReachedMax: false,
        ),
      );
    }

    if (state.hasReachedMax && !event.refresh) return;

    final result = await _repository.getNotifications(
      page: state.page,
      limit: 20,
    );

    result.fold(
      (failure) {
        _logger.error(
          'Échec de la récupération des notifications',
          error: failure.message,
          component: 'NotificationsBloc',
        );
        emit(
          state.copyWith(
            status: NotificationsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (notifications) {
        _logger.info(
          '${notifications.length} notifications récupérées.',
          component: 'NotificationsBloc',
        );
        List<NotificationModel> allNotifications;
        if (event.refresh) {
          allNotifications = notifications;
        } else {
          allNotifications = List.of(state.notifications)
            ..addAll(notifications);
        }

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: allNotifications,
            hasReachedMax: notifications.isEmpty || notifications.length < 20,
            page: state.page + 1,
          ),
        );

        add(FetchUnreadCountRequested());
      },
    );
  }

  Future<void> _onMarkNotificationAsReadRequested(
    MarkNotificationAsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    _logger.info(
      'Marquage de la notification comme lue: ${event.id}',
      component: 'NotificationsBloc',
    );
    final result = await _repository.markAsRead(event.id);
    result.fold(
      (failure) {
        _logger.warning(
          'Échec du marquage de la notification comme lue',
          component: 'NotificationsBloc',
          metadata: {'error': failure.message},
        );
        // Silently fail or show error
      },
      (updatedNotification) {
        _logger.info(
          'Notification marquée comme lue avec succès.',
          component: 'NotificationsBloc',
        );
        final updatedList = state.notifications.map((n) {
          return n.id == event.id ? updatedNotification : n;
        }).toList();
        emit(state.copyWith(notifications: updatedList));
        add(FetchUnreadCountRequested());
      },
    );
  }

  Future<void> _onMarkAllNotificationsAsReadRequested(
    MarkAllNotificationsAsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    _logger.info(
      'Marquage de toutes les notifications comme lues...',
      component: 'NotificationsBloc',
    );
    final result = await _repository.markAllAsRead();
    result.fold(
      (failure) {
        _logger.error(
          'Échec du marquage global des notifications',
          error: failure.message,
          component: 'NotificationsBloc',
        );
      },
      (_) {
        _logger.info(
          'Toutes les notifications marquées comme lues.',
          component: 'NotificationsBloc',
        );
        final updatedList = state.notifications
            .map((n) => n.copyWith(isRead: true))
            .toList();

        emit(state.copyWith(notifications: updatedList, unreadCount: 0));
      },
    );
  }

  Future<void> _onDeleteNotificationRequested(
    DeleteNotificationRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    _logger.info(
      'Suppression de la notification: ${event.id}',
      component: 'NotificationsBloc',
    );
    final result = await _repository.deleteNotification(event.id);
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la suppression de la notification',
          error: failure.message,
          component: 'NotificationsBloc',
        );
        emit(state.copyWith(errorMessage: failure.message));
      },
      (_) {
        _logger.info(
          'Notification supprimée avec succès.',
          component: 'NotificationsBloc',
        );
        final updatedList = state.notifications
            .where((n) => n.id != event.id)
            .toList();
        emit(state.copyWith(notifications: updatedList));
        add(FetchUnreadCountRequested());
      },
    );
  }

  Future<void> _onFetchUnreadCountRequested(
    FetchUnreadCountRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _repository.getUnreadCount();
    result.fold(
      (failure) {},
      (count) => emit(state.copyWith(unreadCount: count)),
    );
  }
}
