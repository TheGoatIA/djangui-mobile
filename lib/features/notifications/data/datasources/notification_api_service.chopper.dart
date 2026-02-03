// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$NotificationApiService extends NotificationApiService {
  _$NotificationApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = NotificationApiService;

  @override
  Future<Response<BaseListResponse<NotificationModel>>> getNotifications({
    int? page,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/notifications');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<BaseListResponse<NotificationModel>, NotificationModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<NotificationModel>>> markAsRead(String id) {
    final Uri $url = Uri.parse('/notifications/${id}/read');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<BaseResponse<NotificationModel>, NotificationModel>(
      $request,
    );
  }

  @override
  Future<Response<BaseResponse<dynamic>>> markAllAsRead() {
    final Uri $url = Uri.parse('/notifications/mark-all-read');
    final Request $request = Request('PATCH', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<dynamic>>> deleteNotification(String id) {
    final Uri $url = Uri.parse('/notifications/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<BaseResponse<dynamic>, BaseResponse<dynamic>>($request);
  }

  @override
  Future<Response<BaseResponse<Map<String, dynamic>>>> getUnreadCount() {
    final Uri $url = Uri.parse('/notifications/unread-count');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BaseResponse<Map<String, dynamic>>, Map<String, dynamic>>(
          $request,
        );
  }
}
