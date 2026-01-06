import 'package:injectable/injectable.dart';
import 'budget_api_service.dart';
import '../models/budget_model.dart';
import '../../../../core/network/api_response_extensions.dart';

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
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel budget) async {
    final json = budget.toJson();
    final Map<String, dynamic> cleanBody = {};
    json.forEach((key, value) {
      if (key != '_id' && key != 'id') {
        cleanBody[key] = value;
      }
    });

    final response = await _apiService.createBudget(cleanBody);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
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
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    final response = await _apiService.deleteBudget(id);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
