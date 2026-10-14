import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';
import '../models/device_info_request.dart';
import '../models/connection_request.dart';
import '../models/country_change_request.dart';
import '../../../../core/network/models/base_response.dart';

part 'auth_api_service.chopper.dart';

@ChopperApi()
abstract class AuthApiService extends ChopperService {
  @POST(path: ApiConstants.login)
  Future<Response<BaseResponse<AuthResponse>>> login(@Body() LoginRequest body);

  @POST(path: ApiConstants.kycSubmit)
  Future<Response<BaseResponse<Map<String, dynamic>>>> submitKYC(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.firebaseAuth)
  Future<Response<AuthResponse>> firebaseLogin(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.appleAuth)
  Future<Response<AuthResponse>> appleLogin(@Body() Map<String, dynamic> body);

  @POST(path: ApiConstants.refresh)
  Future<Response<BaseResponse<Map<String, dynamic>>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.logout)
  Future<Response<BaseResponse<dynamic>>> logout();

  @POST(path: ApiConstants.fcmToken)
  Future<Response<BaseResponse<dynamic>>> updateFcmToken(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.linkPhone)
  Future<Response<BaseResponse<dynamic>>> linkPhone(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiConstants.register)
  Future<Response<BaseResponse<AuthResponse>>> register(
    @Body() RegisterRequest body,
  );

  @POST(path: ApiConstants.forgotPassword)
  Future<Response<BaseResponse<dynamic>>> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: '${ApiConstants.resetPassword}/{token}')
  Future<Response<BaseResponse<dynamic>>> resetPassword(
    @Path('token') String token,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: ApiConstants.verifyEmail)
  Future<Response<BaseResponse<dynamic>>> verifyEmail(
    @Query('token') String token,
  );

  @GET(path: ApiConstants.me)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getUserProfile();

  @PATCH(path: ApiConstants.me)
  Future<Response<BaseResponse<Map<String, dynamic>>>> updateProfile(
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: '/auth/device')
  Future<Response<BaseResponse<dynamic>>> updateDeviceInfo(
    @Body() DeviceInfoRequest body,
  );
  @PATCH(path: ApiConstants.changePassword)
  Future<Response<BaseResponse<dynamic>>> changePassword(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: ApiConstants.deleteMe)
  Future<Response<BaseResponse<dynamic>>> deleteAccount(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: ApiConstants.sessions)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getSessions();

  @DELETE(path: ApiConstants.sessions)
  Future<Response<BaseResponse<dynamic>>> revokeAllOtherSessions();

  @DELETE(path: '${ApiConstants.sessions}/{sessionId}')
  Future<Response<BaseResponse<dynamic>>> revokeSession(
    @Path('sessionId') String sessionId,
  );

  @POST(path: ApiConstants.connection)
  Future<Response<BaseResponse<dynamic>>> logConnection(
    @Body() ConnectionRequest body,
  );
  @POST(path: ApiConstants.requestCountryChange)
  Future<Response<BaseResponse<CountryChangeRequestModel>>>
  requestCountryChange(@Body() Map<String, dynamic> body);

  @PATCH(path: ApiConstants.updateLanguage)
  Future<Response<BaseResponse<dynamic>>> updateLanguage(
    @Body() Map<String, dynamic> body,
  );

  static AuthApiService create([ChopperClient? client]) =>
      _$AuthApiService(client);
}
