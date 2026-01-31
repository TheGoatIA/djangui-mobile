import 'package:chopper/chopper.dart';
import '../models/goal_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'goal_api_service.chopper.dart';

@ChopperApi(baseUrl: '/goals')
abstract class GoalApiService extends ChopperService {
  static GoalApiService create([ChopperClient? client]) =>
      _$GoalApiService(client);

  @Get()
  Future<Response<BaseListResponse<GoalModel>>> getGoals();

  @Post()
  Future<Response<BaseResponse<GoalModel>>> createGoal(
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteGoal(@Path('id') String id);

  @Post(path: '/{id}/contribute')
  Future<Response<BaseResponse<GoalModel>>> contributeToGoal(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
