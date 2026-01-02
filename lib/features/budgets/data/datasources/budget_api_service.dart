import 'package:chopper/chopper.dart';
import '../models/budget_model.dart';

part 'budget_api_service.chopper.dart';

@ChopperApi(baseUrl: '/budgets')
abstract class BudgetApiService extends ChopperService {
  static BudgetApiService create([ChopperClient? client]) =>
      _$BudgetApiService(client);

  @Get()
  Future<Response<List<BudgetModel>>> getBudgets();

  @Post()
  Future<Response<BudgetModel>> createBudget(@Body() BudgetModel budget);

  @Delete(path: '/{id}')
  Future<Response<void>> deleteBudget(@Path('id') String id);
}
