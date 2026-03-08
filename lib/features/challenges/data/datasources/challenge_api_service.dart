import 'package:chopper/chopper.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import 'package:kauri/core/network/models/base_response.dart';

part 'challenge_api_service.chopper.dart';

@ChopperApi(baseUrl: '/challenges')
abstract class ChallengeApiService extends ChopperService {
  static ChallengeApiService create([ChopperClient? client]) =>
      _$ChallengeApiService(client);

  @Get()
  Future<Response<BaseListResponse<ChallengeModel>>> getChallenges();

  @Get(path: '/my-challenges')
  Future<Response<BaseListResponse<UserChallengeModel>>> getUserChallenges();

  @Post(path: '/join')
  Future<Response<BaseResponse<UserChallengeModel>>> joinChallenge(
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/{id}/validate-week')
  Future<Response<BaseResponse<UserChallengeModel>>> validateWeek(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
  @Delete(path: '/{id}')
  Future<Response<BaseResponse<dynamic>>> unjoinChallenge(
    @Path('id') String id,
  );

  @Post(path: '/{id}/skip')
  Future<Response<BaseResponse<UserChallengeModel>>> skipWeek(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/{id}/postpone')
  Future<Response<BaseResponse<UserChallengeModel>>> postponeDeadline(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Post(path: '/{id}/redeem')
  Future<Response<BaseResponse<ChallengeRedeemModel>>> redeemChallenge(
    @Path('id') String id,
  );
}
