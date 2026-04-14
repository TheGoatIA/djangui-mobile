import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/analytics_models.dart';

part 'analytics_api_service.chopper.dart';

@ChopperApi(baseUrl: ApiConstants.analytics)
abstract class AnalyticsApiService extends ChopperService {
  static AnalyticsApiService create([ChopperClient? client]) =>
      _$AnalyticsApiService(client);

  @POST(path: '/events')
  Future<Response<dynamic>> trackEvent(@Body() Map<String, dynamic> body);

  @POST(path: '/sessions/start')
  Future<Response<BaseResponse<SessionStartResponse>>> startSession(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/sessions/end')
  Future<Response<BaseResponse<dynamic>>> endSession(
    @Body() Map<String, dynamic> body,
  );
}

