import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    int? page,
    int? limit,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getNotifications(
          page: page,
          limit: limit,
        );
        return Right(response.data ?? []);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationModel>> markAsRead(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.markAsRead(id);
        return Right(response.data!);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markAllAsRead();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
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
    if (await _networkInfo.isConnected) {
      try {
        final count = await _remoteDataSource.getUnreadCount();
        return Right(count);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
