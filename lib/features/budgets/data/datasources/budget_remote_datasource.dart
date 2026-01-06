import 'package:injectable/injectable.dart';
import 'budget_api_service.dart';
import '../models/budget_model.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel> createBudget(BudgetModel budget);
  Future<BudgetModel> updateBudget(String id, double totalAllocated);
  Future<void> deleteBudget(String id);
}

@LazySingleton(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final BudgetApiService _apiService;

  BudgetRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final response = await _apiService.getCurrentBudget();
    if (response.isSuccessful && response.body?.data != null) {
      return [response.body!.data!];
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to fetch budgets',
      );
    }
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel budget) async {
    final json = budget.toJson();
    json.remove('_id');
    final response = await _apiService.createBudget(json);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to create budget',
      );
    }
  }

  @override
  Future<BudgetModel> updateBudget(String id, double totalAllocated) async {
    final response = await _apiService.updateBudget(id, {
      'totalAllocated': totalAllocated,
    });
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to update budget',
      );
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    final response = await _apiService.deleteBudget(id);
    if (!response.isSuccessful) {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to delete budget',
      );
    }
  }
}
