import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';
import '../models/challenge_model.dart';
import 'package:djangui/core/network/models/base_response.dart';

part 'challenge_api_service.chopper.dart';

@ChopperApi()
abstract class ChallengeApiService extends ChopperService {
  static ChallengeApiService create([ChopperClient? client]) =>
      _$ChallengeApiService(client);

  @Get(path: ApiConstants.challenges)
  Future<Response<BaseListResponse<ChallengeModel>>> getChallenges();

  @Get(path: ApiConstants.myChallenges)
  Future<Response<BaseListResponse<UserChallengeModel>>> getUserChallenges();

  @Post(path: '${ApiConstants.challenges}/join')
  Future<Response<BaseResponse<dynamic>>> joinChallenge(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.validateWeek)
  Future<Response<BaseResponse<dynamic>>> validateWeek(
    @Body() Map<String, dynamic> body,
  );
}
