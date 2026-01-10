import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'goal_api_service.dart';
import '../models/goal_model.dart';
import '../../../../core/network/api_response_extensions.dart';

abstract class GoalRemoteDataSource {
  Future<List<GoalModel>> getGoals();
  Future<GoalModel> createGoal(GoalModel goal);
  Future<void> deleteGoal(String id);
  Future<void> contributeToGoal(String id, double amount);
}

@LazySingleton(as: GoalRemoteDataSource)
class GoalRemoteDataSourceImpl implements GoalRemoteDataSource {
  final GoalApiService _apiService;

  GoalRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<GoalModel>> getGoals() async {
    try {
      final response = await _apiService.getGoals();
      if (response.isSuccessful && response.body?.data != null) {
        return response.body!.data!;
      } else {
        throw Exception(response.errorMessage);
      }
    } catch (e, stack) {
      debugPrint('🚨 [GoalRemote] Failed to fetch/parse goals: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  @override
  Future<GoalModel> createGoal(GoalModel goal) async {
    final json = goal.toJson();
    final Map<String, dynamic> cleanBody = {};
    json.forEach((key, value) {
      if (key != '_id' && key != 'id') {
        cleanBody[key] = value;
      }
    });

    final response = await _apiService.createGoal(cleanBody);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    final response = await _apiService.deleteGoal(id);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> contributeToGoal(String id, double amount) async {
    final response = await _apiService.contributeToGoal(id, {'amount': amount});
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
