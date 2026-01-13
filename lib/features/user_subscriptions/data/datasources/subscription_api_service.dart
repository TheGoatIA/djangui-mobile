import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/subscription_model.dart';

part 'subscription_api_service.chopper.dart';

@ChopperApi()
abstract class SubscriptionApiService extends ChopperService {
  @Get(path: ApiConstants.subscriptions)
  Future<Response<BaseListResponse<SubscriptionModel>>> getSubscriptions();

  @Post(path: ApiConstants.subscriptions)
  Future<Response<BaseResponse<SubscriptionModel>>> addSubscription(
    @Body() Map<String, dynamic> body,
  );

  @Get(path: '${ApiConstants.subscriptions}/{id}')
  Future<Response<BaseResponse<SubscriptionModel>>> getSubscriptionDetails(
    @Path('id') String id,
  );

  @Patch(path: '${ApiConstants.subscriptions}/{id}')
  Future<Response<BaseResponse<SubscriptionModel>>> updateSubscription(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '${ApiConstants.subscriptions}/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteSubscription(
    @Path('id') String id,
  );

  @Post(path: ApiConstants.subscriptionsDetect)
  Future<Response<BaseListResponse<SubscriptionSuggestion>>>
  detectSubscriptions();

  static SubscriptionApiService create(ChopperClient client) =>
      _$SubscriptionApiService(client);
}
