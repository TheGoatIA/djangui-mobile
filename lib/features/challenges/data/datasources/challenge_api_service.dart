import 'package:chopper/chopper.dart';
import 'package:djangui/core/constants/api_constants.dart';
import 'package:djangui/features/challenges/data/models/challenge_model.dart';
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
  Future<Response<BaseResponse<UserChallengeModel>>> joinChallenge(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: ApiConstants.validateWeek)
  Future<Response<BaseResponse<UserChallengeModel>>> validateWeek(
    @Body() Map<String, dynamic> body,
  );
  @Delete(path: '${ApiConstants.challenges}/{id}')
  Future<Response<BaseResponse<dynamic>>> unjoinChallenge(
    @Path('id') String id,
  );
}
