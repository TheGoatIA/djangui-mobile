import 'package:injectable/injectable.dart';
import 'budget_api_service.dart';
import '../models/budget_model.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel> createBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
}

@LazySingleton(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final BudgetApiService _apiService;

  BudgetRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final response = await _apiService.getCurrentBudget();
    if (response.isSuccessful) {
      // The API returns a single budget, assume list for compatibility
      if (response.body != null) {
        return [response.body!];
      }
      return [];
    } else {
      // If 404 (no budget), return empty list?
      if (response.statusCode == 404) return [];
      throw Exception('Failed to fetch budgets');
    }
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel budget) async {
    final response = await _apiService.createBudget(budget);
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception('Failed to create budget');
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    final response = await _apiService.deleteBudget(id);
    if (!response.isSuccessful) {
      throw Exception('Failed to delete budget');
    }
  }
}
