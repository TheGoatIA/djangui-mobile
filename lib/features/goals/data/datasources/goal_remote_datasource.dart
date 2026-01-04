import 'package:injectable/injectable.dart';
import 'goal_api_service.dart';
import '../models/goal_model.dart';

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
    final response = await _apiService.getGoals();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to fetch goals',
      );
    }
  }

  @override
  Future<GoalModel> createGoal(GoalModel goal) async {
    final response = await _apiService.createGoal(goal);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to create goal',
      );
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    final response = await _apiService.deleteGoal(id);
    if (!response.isSuccessful) {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to delete goal',
      );
    }
  }

  @override
  Future<void> contributeToGoal(String id, double amount) async {
    final response = await _apiService.contributeToGoal(id, {'amount': amount});
    if (!response.isSuccessful) {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to contribute to goal',
      );
    }
  }
}
