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
}

