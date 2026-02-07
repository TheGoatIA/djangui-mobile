import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl(this._remoteDataSource, this._networkInfo);

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    int? page,
    int? limit,
  }) async {
    _logger.info(
      'Récupération des notifications (page: $page, limit: $limit)...',
      component: 'NotificationRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getNotifications(
          page: page,
          limit: limit,
        );
        final notifications = response.data ?? [];
        _logger.info(
          '${notifications.length} notifications récupérées du serveur.',
          component: 'NotificationRepository',
        );
        return Right(notifications);
      } catch (e) {
        _logger.error(
          'Erreur lors de la récupération des notifications',
          error: e,
          component: 'NotificationRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de récupérer les notifications hors-ligne.',
        component: 'NotificationRepository',
      );
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationModel>> markAsRead(String id) async {
    _logger.info(
      'Marquage de la notification $id comme lue.',
      component: 'NotificationRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.markAsRead(id);
        _logger.info(
          'Notification marquée comme lue avec succès.',
          component: 'NotificationRepository',
        );
        return Right(response.data!);
      } catch (e) {
        _logger.error(
          'Erreur lors du marquage comme lue',
          error: e,
          component: 'NotificationRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de marquer comme lue hors-ligne.',
        component: 'NotificationRepository',
      );
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    _logger.info(
      'Marquage de toutes les notifications comme lues.',
      component: 'NotificationRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markAllAsRead();
        _logger.info(
          'Toutes les notifications ont été marquées comme lues.',
          component: 'NotificationRepository',
        );
        return const Right(null);
      } catch (e) {
        _logger.error(
          'Erreur lors du marquage global comme lue',
          error: e,
          component: 'NotificationRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de marquer tout comme lu hors-ligne.',
        component: 'NotificationRepository',
      );
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteNotification(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    _logger.info(
      'Récupération du nombre de notifications non lues...',
      component: 'NotificationRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final count = await _remoteDataSource.getUnreadCount();
        _logger.info(
          'Nombre de notifications non lues: $count',
          component: 'NotificationRepository',
        );
        return Right(count);
      } catch (e) {
        _logger.error(
          'Erreur lors de la récupération du décompte',
          error: e,
          component: 'NotificationRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
