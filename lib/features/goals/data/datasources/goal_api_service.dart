import 'package:chopper/chopper.dart';
import '../models/goal_model.dart';

part 'goal_api_service.chopper.dart';

@ChopperApi(baseUrl: '/goals')
abstract class GoalApiService extends ChopperService {
  static GoalApiService create([ChopperClient? client]) =>
      _$GoalApiService(client);

  @Get()
  Future<Response<List<GoalModel>>> getGoals();

  @Post()
  Future<Response<GoalModel>> createGoal(@Body() GoalModel goal);

  @Delete(path: '/{id}')
  Future<Response<void>> deleteGoal(@Path('id') String id);

  @Post(path: '/{id}/contribute')
  Future<Response<void>> contributeToGoal(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
