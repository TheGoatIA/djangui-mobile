import 'package:injectable/injectable.dart';
import '../../../../core/network/models/base_response.dart';
import 'notification_api_service.dart';
import 'notification_remote_datasource.dart';
import '../models/notification_model.dart';

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NotificationApiService _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<BaseListResponse<NotificationModel>> getNotifications({
    int? page,
    int? limit,
  }) async {
    final response = await _apiService.getNotifications(
      page: page,
      limit: limit,
    );
    if (response.isSuccessful) {
      return response.body!;
    } else {
      throw Exception(response.error);
    }
  }

  @override
  Future<BaseResponse<NotificationModel>> markAsRead(String id) async {
    final response = await _apiService.markAsRead(id);
    if (response.isSuccessful) {
      return response.body!;
    } else {
      throw Exception(response.error);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final response = await _apiService.markAllAsRead();
    if (!response.isSuccessful) {
      throw Exception(response.error);
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    final response = await _apiService.deleteNotification(id);
    if (!response.isSuccessful) {
      throw Exception(response.error);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiService.getUnreadCount();
    if (response.isSuccessful) {
      return response.body?.data?['count'] ?? 0;
    } else {
      throw Exception(response.error);
    }
  }
}
