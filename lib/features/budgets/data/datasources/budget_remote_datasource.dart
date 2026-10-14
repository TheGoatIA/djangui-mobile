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
  Future<List<BudgetCategoryHistoryPointModel>> getCategoryHistory(
    String category, {
    int months = 6,
  });
  Future<String> shareBudget(String id);
  Future<BudgetModel> joinBudget(String inviteCode);
  Future<List<BudgetParticipantModel>> getParticipants(String id);
  Future<void> removeParticipant(String id, String participantId);
  Future<void> leaveBudget(String id);
}

@LazySingleton(as: BudgetRemoteDataSource)
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final BudgetApiService _apiService;

  BudgetRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<BudgetModel>> getBudgets() async {
    // Appelait auparavant getCurrentBudget() (`/budgets/current`), qui ne
    // renvoie QUE le budget du mois en cours côté serveur (ou aucun) — donc
    // au mieux 1 seul budget, jamais l'historique complet. Un budget créé
    // pour un autre mois que le mois serveur en cours ne pouvait jamais
    // apparaître, et pire : chaque rafraîchissement forcé écrasait le cache
    // local avec cette liste tronquée (voir BudgetRepositoryImpl.getBudgets,
    // `clearBudgets()` + `saveBudgets(...)`), faisant disparaître les autres
    // budgets déjà visibles. `/budgets` (liste complète) est le bon endpoint.
    final response = await _apiService.getBudgets();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
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

  @override
  Future<List<BudgetCategoryHistoryPointModel>> getCategoryHistory(
    String category, {
    int months = 6,
  }) async {
    final response = await _apiService.getCategoryHistory(
      category: category,
      months: months,
    );
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<String> shareBudget(String id) async {
    final response = await _apiService.shareBudget(id);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!['inviteCode'] as String;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<BudgetModel> joinBudget(String inviteCode) async {
    final response = await _apiService.joinBudget({'inviteCode': inviteCode});
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<List<BudgetParticipantModel>> getParticipants(String id) async {
    final response = await _apiService.getParticipants(id);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> removeParticipant(String id, String participantId) async {
    final response = await _apiService.removeParticipant(id, participantId);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> leaveBudget(String id) async {
    final response = await _apiService.leaveBudget(id);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
