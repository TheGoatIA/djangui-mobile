import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/notification_model.dart';

part 'notification_api_service.chopper.dart';

@ChopperApi()
abstract class NotificationApiService extends ChopperService {
  @GET(path: ApiConstants.notifications)
  Future<Response<BaseListResponse<NotificationModel>>> getNotifications({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @PATCH(path: '${ApiConstants.notifications}/{id}/read')
  Future<Response<BaseResponse<NotificationModel>>> markAsRead(
    @Path('id') String id,
  );

  @PATCH(path: ApiConstants.notificationsMarkRead)
  Future<Response<BaseResponse<dynamic>>> markAllAsRead();

  @DELETE(path: '${ApiConstants.notifications}/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteNotification(
    @Path('id') String id,
  );

  @GET(path: ApiConstants.notificationsUnreadCount)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getUnreadCount();

  static NotificationApiService create(ChopperClient client) =>
      _$NotificationApiService(client);
}

