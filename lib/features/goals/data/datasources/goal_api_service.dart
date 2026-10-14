import 'package:chopper/chopper.dart';
import '../models/goal_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'goal_api_service.chopper.dart';

@ChopperApi(baseUrl: '/goals')
abstract class GoalApiService extends ChopperService {
  static GoalApiService create([ChopperClient? client]) =>
      _$GoalApiService(client);

  @GET()
  Future<Response<BaseListResponse<GoalModel>>> getGoals();

  @POST()
  Future<Response<BaseResponse<GoalModel>>> createGoal(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteGoal(@Path('id') String id);

  @POST(path: '/{id}/contribute')
  Future<Response<BaseResponse<GoalModel>>> contributeToGoal(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/{id}/redeem')
  Future<Response<BaseResponse<GoalModel>>> redeemGoal(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/{id}/share')
  Future<Response<BaseResponse<Map<String, dynamic>>>> shareGoal(
    @Path('id') String id,
  );

  @POST(path: '/join')
  Future<Response<BaseResponse<GoalModel>>> joinGoal(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/{id}/participants')
  Future<Response<BaseListResponse<GoalParticipantModel>>> getParticipants(
    @Path('id') String id,
  );

  @DELETE(path: '/{id}/participants/{participantId}')
  Future<Response<BaseResponse<dynamic>>> removeParticipant(
    @Path('id') String id,
    @Path('participantId') String participantId,
  );

  @POST(path: '/{id}/leave')
  Future<Response<BaseResponse<dynamic>>> leaveGoal(@Path('id') String id);
}
