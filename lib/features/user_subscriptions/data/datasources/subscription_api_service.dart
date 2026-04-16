import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/subscription_model.dart';

part 'subscription_api_service.chopper.dart';

@ChopperApi()
abstract class SubscriptionApiService extends ChopperService {
  @GET(path: ApiConstants.subscriptions)
  Future<Response<BaseListResponse<SubscriptionModel>>> getSubscriptions();

  @POST(path: ApiConstants.subscriptions)
  Future<Response<BaseResponse<SubscriptionModel>>> addSubscription(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '${ApiConstants.subscriptions}/{id}')
  Future<Response<BaseResponse<SubscriptionModel>>> getSubscriptionDetails(
    @Path('id') String id,
  );

  @PATCH(path: '${ApiConstants.subscriptions}/{id}')
  Future<Response<BaseResponse<SubscriptionModel>>> updateSubscription(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '${ApiConstants.subscriptions}/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteSubscription(
    @Path('id') String id,
  );

  @POST(path: ApiConstants.subscriptionsDetect)
  Future<Response<BaseListResponse<SubscriptionSuggestion>>>
  detectSubscriptions();

  static SubscriptionApiService create(ChopperClient client) =>
      _$SubscriptionApiService(client);
}
