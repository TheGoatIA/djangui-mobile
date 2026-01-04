import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
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

  @Post(path: '/v1/auth/google')
  Future<Response<BaseResponse<AuthResponse>>> googleLogin(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/v1/auth/refresh')
  Future<Response<BaseResponse<Map<String, dynamic>>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/v1/auth/logout')
  Future<Response<BaseResponse<dynamic>>> logout();

  @Post(path: '/v1/auth/fcm-token')
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
  Future<Response<BaseResponse<UserModel>>> getProfile();

  @Patch(path: ApiConstants.me)
  Future<Response<BaseResponse<UserModel>>> updateProfile(
    @Body() Map<String, dynamic> body,
  );

  static AuthApiService create(ChopperClient client) =>
      _$AuthApiService(client);
}
