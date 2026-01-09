import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';
import '../models/device_info_request.dart';
import '../models/connection_request.dart';
import '../../../../core/network/models/base_response.dart';

part 'auth_api_service.chopper.dart';

@ChopperApi()
abstract class AuthApiService extends ChopperService {
  @Post(path: ApiConstants.login)
  Future<Response<BaseResponse<AuthResponse>>> login(@Body() LoginRequest body);

  @Post(path: ApiConstants.firebaseAuth)
  Future<Response<BaseResponse<AuthResponse>>> firebaseLogin(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/auth/google')
  Future<Response<BaseResponse<AuthResponse>>> googleLogin(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.refresh)
  Future<Response<BaseResponse<Map<String, dynamic>>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.logout)
  Future<Response<BaseResponse<dynamic>>> logout();

  @Post(path: ApiConstants.fcmToken)
  Future<Response<BaseResponse<dynamic>>> updateFcmToken(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.linkPhone)
  Future<Response<BaseResponse<dynamic>>> linkPhone(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.register)
  Future<Response<BaseResponse<AuthResponse>>> register(
    @Body() RegisterRequest body,
  );

  @Post(path: ApiConstants.forgotPassword)
  Future<Response<BaseResponse<dynamic>>> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @Patch(path: '${ApiConstants.resetPassword}/{token}')
  Future<Response<BaseResponse<dynamic>>> resetPassword(
    @Path('token') String token,
    @Body() Map<String, dynamic> body,
  );

  @Get(path: ApiConstants.verifyEmail)
  Future<Response<BaseResponse<dynamic>>> verifyEmail(
    @Query('token') String token,
  );

  @Get(path: ApiConstants.me)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getUserProfile();

  @Patch(path: ApiConstants.me)
  Future<Response<BaseResponse<Map<String, dynamic>>>> updateProfile(
    @Body() Map<String, dynamic> body,
  );

  @Patch(path: '/auth/device')
  Future<Response<BaseResponse<dynamic>>> updateDeviceInfo(
    @Body() DeviceInfoRequest body,
  );
  @Patch(path: ApiConstants.changePassword)
  Future<Response<BaseResponse<dynamic>>> changePassword(
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: ApiConstants.deleteMe)
  Future<Response<BaseResponse<dynamic>>> deleteAccount();

  @Get(path: ApiConstants.sessions)
  Future<Response<BaseResponse<Map<String, dynamic>>>> getSessions();

  @Delete(path: ApiConstants.sessions)
  Future<Response<BaseResponse<dynamic>>> revokeAllOtherSessions();

  @Delete(path: '${ApiConstants.sessions}/{sessionId}')
  Future<Response<BaseResponse<dynamic>>> revokeSession(
    @Path('sessionId') String sessionId,
  );

  @Post(path: ApiConstants.connection)
  Future<Response<BaseResponse<dynamic>>> logConnection(
    @Body() ConnectionRequest body,
  );

  static AuthApiService create(ChopperClient client) =>
      _$AuthApiService(client);
}
