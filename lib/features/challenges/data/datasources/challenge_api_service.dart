import 'package:chopper/chopper.dart';
import '../models/challenge_model.dart';

part 'challenge_api_service.chopper.dart';

@ChopperApi(baseUrl: '/challenges')
abstract class ChallengeApiService extends ChopperService {
  static ChallengeApiService create([ChopperClient? client]) =>
      _$ChallengeApiService(client);

  @Get()
  Future<Response<List<ChallengeModel>>> getChallenges();

  @Post(path: '/{id}/join')
  Future<Response<ChallengeModel>> joinChallenge(@Path('id') String id);

  @Patch(path: '/{id}/progress')
  Future<Response<ChallengeModel>> updateProgress(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
