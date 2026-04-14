import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';
import 'package:kauri/core/network/models/base_response.dart';

part 'premium_api_service.chopper.dart';

@ChopperApi()
abstract class PremiumApiService extends ChopperService {
  static PremiumApiService create([ChopperClient? client]) =>
      _$PremiumApiService(client);

  @POST(path: ApiConstants.coachAsk)
  Future<Response<BaseResponse<Map<String, dynamic>>>> askCoach(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: ApiConstants.premiumAutoBudget)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getAutoBudget();

  @GET(path: ApiConstants.premiumReport)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getPremiumReport();
}

