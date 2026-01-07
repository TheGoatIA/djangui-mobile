import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    int? page,
    int? limit,
  });
  Future<Either<Failure, NotificationModel>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, int>> getUnreadCount();
}
