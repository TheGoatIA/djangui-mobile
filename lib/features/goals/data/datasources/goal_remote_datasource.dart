import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'goal_api_service.dart';
import '../models/goal_model.dart';
import '../../../../core/network/api_response_extensions.dart';

abstract class GoalRemoteDataSource {
  Future<List<GoalModel>> getGoals();
  Future<GoalModel> createGoal(GoalModel goal);
  Future<void> deleteGoal(String id);
  Future<GoalModel> contributeToGoal(
    String id,
    double amount, {
    String? note,
    String? idempotencyKey,
  });
  Future<GoalModel> redeemGoal(String id, {double? amount});
  Future<String> shareGoal(String id);
  Future<GoalModel> joinGoal(String inviteCode);
  Future<List<GoalParticipantModel>> getParticipants(String id);
  Future<void> removeParticipant(String id, String participantId);
  Future<void> leaveGoal(String id);
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
  Future<GoalModel> contributeToGoal(
    String id,
    double amount, {
    String? note,
    String? idempotencyKey,
  }) async {
    final response = await _apiService.contributeToGoal(id, {
      'amount': amount,
      if (note != null) 'note': note,
      // Rejeu stable de la file hors-ligne (K-17) : le serveur lit ce champ
      // en repli si l'en-tête Idempotency-Key n'est pas fourni (voir
      // djangui-api/src/middleware/idempotency.ts).
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
    });
    if (!response.isSuccessful || response.body?.data == null) {
      throw Exception(response.body?.message ?? 'Failed to contribute');
    }
    return response.body!.data!;
  }

  @override
  Future<GoalModel> redeemGoal(String id, {double? amount}) async {
    final response = await _apiService.redeemGoal(id, {
      if (amount != null) 'amount': amount,
    });
    if (!response.isSuccessful || response.body?.data == null) {
      throw Exception(response.body?.message ?? 'Failed to redeem funds');
    }
    return response.body!.data!;
  }

  @override
  Future<String> shareGoal(String id) async {
    final response = await _apiService.shareGoal(id);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!['inviteCode'] as String;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<GoalModel> joinGoal(String inviteCode) async {
    final response = await _apiService.joinGoal({'inviteCode': inviteCode});
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<List<GoalParticipantModel>> getParticipants(String id) async {
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
  Future<void> leaveGoal(String id) async {
    final response = await _apiService.leaveGoal(id);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
