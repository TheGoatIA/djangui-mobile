import 'package:chopper/chopper.dart';
import '../models/budget_model.dart';
import '../models/auto_budget_response.dart';
import '../../../../core/network/models/base_response.dart';

part 'budget_api_service.chopper.dart';

@ChopperApi()
abstract class BudgetApiService extends ChopperService {
  static BudgetApiService create([ChopperClient? client]) =>
      _$BudgetApiService(client);

  @GET(path: '/budgets/current')
  Future<Response<BaseResponse<BudgetModel>>> getCurrentBudget();

  @GET(path: '/budgets')
  Future<Response<BaseListResponse<BudgetModel>>> getBudgets({
    @Query('year') int? year,
    @Query('month') int? month,
  });

  @POST(path: '/budgets')
  Future<Response<BaseResponse<BudgetModel>>> createBudget(
    @Body() Map<String, dynamic> body,
  );

  @PUT(path: '/budgets/{id}')
  Future<Response<BaseResponse<BudgetModel>>> updateBudget(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/budgets/{id}')
  Future<Response<BaseResponse<dynamic>>> deleteBudget(@Path('id') String id);

  @GET(path: '/premium/auto-budget')
  Future<Response<BaseResponse<AutoBudgetResponse>>> generateAutoBudget({
    @Query('month') int? month,
    @Query('year') int? year,
  });
}
