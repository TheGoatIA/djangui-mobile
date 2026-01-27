import 'package:chopper/chopper.dart';
import '../models/budget_model.dart';
import '../models/auto_budget_response.dart';
import '../../../../core/network/models/base_response.dart';

part 'budget_api_service.chopper.dart';

@ChopperApi()
abstract class BudgetApiService extends ChopperService {
  static BudgetApiService create([ChopperClient? client]) =>
      _$BudgetApiService(client);

  @Get(path: '/budgets/current')
  Future<Response<BaseResponse<BudgetModel>>> getCurrentBudget();

  @Get(path: '/budgets')
  Future<Response<BaseListResponse<BudgetModel>>> getBudgets({
    @Query('year') int? year,
    @Query('month') int? month,
  });

  @Post(path: '/budgets')
  Future<Response<BaseResponse<BudgetModel>>> createBudget(
    @Body() Map<String, dynamic> body,
  );

  @Put(path: '/budgets/{id}')
  Future<Response<BaseResponse<BudgetModel>>> updateBudget(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: '/budgets/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteBudget(@Path('id') String id);

  @Post(path: '/premium/auto-budget')
  Future<Response<BaseResponse<AutoBudgetResponse>>> generateAutoBudget();
}
