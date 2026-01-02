import 'package:chopper/chopper.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';

part 'auth_api_service.chopper.dart';

@ChopperApi()
abstract class AuthApiService extends ChopperService {
  @Post(path: ApiConstants.login)
  Future<Response<AuthResponse>> login(@Body() LoginRequest body);

  @Post(path: ApiConstants.register)
  Future<Response<AuthResponse>> register(@Body() RegisterRequest body);

  static AuthApiService create(ChopperClient client) =>
      _$AuthApiService(client);
}
