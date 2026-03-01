import 'package:chopper/chopper.dart';
import 'package:kauri/core/constants/api_constants.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import 'package:kauri/core/network/models/base_response.dart';
import 'package:http/http.dart' show MultipartFile;

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
  @Multipart()
  Future<Response<BaseResponse<UserChallengeModel>>> validateWeek(
    @Part('userChallengeId') String userChallengeId,
    @Part('weekNumber') int weekNumber,
    @Part('amount') double amount,
    @PartFile('proof') MultipartFile? proof,
  );
  @Delete(path: '${ApiConstants.challenges}/{id}')
  Future<Response<BaseResponse<dynamic>>> unjoinChallenge(
    @Path('id') String id,
  );

  @Post(path: '${ApiConstants.challenges}/skip/{id}')
  Future<Response<BaseResponse<dynamic>>> skipWeek(@Path('id') String id);

  @Post(path: '${ApiConstants.challenges}/postpone/{id}')
  Future<Response<BaseResponse<dynamic>>> postponeDeadline(
    @Path('id') String id,
  );
}
