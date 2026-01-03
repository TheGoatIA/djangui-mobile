import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';
import '../models/challenge_model.dart';

part 'challenge_api_service.chopper.dart';

@ChopperApi()
abstract class ChallengeApiService extends ChopperService {
  static ChallengeApiService create([ChopperClient? client]) =>
      _$ChallengeApiService(client);

  @Get(path: ApiConstants.challenges)
  Future<Response<List<ChallengeModel>>> getChallenges();

  @Get(path: ApiConstants.myChallenges)
  Future<Response<List<dynamic>>> getUserChallenges();

  @Post(path: '${ApiConstants.challenges}/join')
  Future<Response<dynamic>> joinChallenge(@Body() Map<String, dynamic> body);

  @Post(path: ApiConstants.validateWeek)
  Future<Response<dynamic>> validateWeek(@Body() Map<String, dynamic> body);
}
