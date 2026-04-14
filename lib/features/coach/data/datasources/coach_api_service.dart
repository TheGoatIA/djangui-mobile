import 'package:chopper/chopper.dart';

part 'coach_api_service.chopper.dart';

@ChopperApi(baseUrl: '/coach')
abstract class CoachApiService extends ChopperService {
  static CoachApiService create([ChopperClient? client]) =>
      _$CoachApiService(client);

  @POST(path: '/ask')
  Future<Response<dynamic>> ask(@Body() Map<String, dynamic> body);

  @GET(path: '/history')
  Future<Response<dynamic>> getChatHistory();
}

