import 'package:chopper/chopper.dart';
import '../models/budget_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'budget_api_service.chopper.dart';

@ChopperApi(baseUrl: '/budgets')
abstract class BudgetApiService extends ChopperService {
  static BudgetApiService create([ChopperClient? client]) =>
      _$BudgetApiService(client);

  @Get(path: '/current')
  Future<Response<BaseResponse<BudgetModel>>> getCurrentBudget();

  @Get()
  Future<Response<BaseListResponse<BudgetModel>>> getBudgets({
    @Query('year') int? year,
    @Query('month') int? month,
  });

  @Post()
  Future<Response<BaseResponse<BudgetModel>>> createBudget(
    @Body() Map<String, dynamic> body,
  );

  @Put(path: '/{id}')
  Future<Response<BaseResponse<BudgetModel>>> updateBudget(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteBudget(@Path('id') String id);
}
