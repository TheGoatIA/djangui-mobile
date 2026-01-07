import '../../../../core/network/models/base_response.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<BaseListResponse<NotificationModel>> getNotifications({
    int? page,
    int? limit,
  });
  Future<BaseResponse<NotificationModel>> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<int> getUnreadCount();
}
