import 'package:injectable/injectable.dart';
import 'budget_api_service.dart';
import '../models/budget_model.dart';
import '../models/auto_budget_response.dart';
import '../../../../core/network/api_response_extensions.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel> createBudget(BudgetModel budget);
  Future<BudgetModel> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
  Future<AutoBudgetResponse> generateAutoBudget({int? month, int? year});
}

@LazySingleton(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final BudgetApiService _apiService;

  BudgetRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    final response = await _apiService.getCurrentBudget();
    if (response.isSuccessful) {
      if (response.body?.data != null) {
        return [response.body!.data!];
      }
      // Si la requête réussit mais data est null, cela signifie qu'il n'y a pas de budget courant.
      return [];
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
  Future<BudgetModel> updateBudget(BudgetModel budget) async {
    final json = budget.toJson();
    final Map<String, dynamic> cleanBody = {};
    json.forEach((key, value) {
      if (key != '_id' && key != 'id') {
        cleanBody[key] = value;
      }
    });

    final response = await _apiService.updateBudget(budget.id, cleanBody);
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

  @override
  Future<AutoBudgetResponse> generateAutoBudget({int? month, int? year}) async {
    final response = await _apiService.generateAutoBudget(
      month: month,
      year: year,
    );
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
