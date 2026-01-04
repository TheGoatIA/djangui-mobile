import 'package:injectable/injectable.dart';
import 'challenge_api_service.dart';
import '../models/challenge_model.dart';

abstract class ChallengeRemoteDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<List<dynamic>> getUserChallenges();
  Future<dynamic> joinChallenge(String id);
  Future<dynamic> validateWeek(
    String userChallengeId,
    int weekNumber,
    double amount,
  );
  // Future<ChallengeModel> updateProgress(String id, double value); // Removed
}

@LazySingleton(as: ChallengeRemoteDataSource)
class ChallengeRemoteDataSourceImpl implements ChallengeRemoteDataSource {
  final ChallengeApiService _apiService;

  ChallengeRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ChallengeModel>> getChallenges() async {
    final response = await _apiService.getChallenges();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to fetch challenges',
      );
    }
  }

  @override
  Future<List<dynamic>> getUserChallenges() async {
    final response = await _apiService.getUserChallenges();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to fetch user challenges',
      );
    }
  }

  @override
  Future<dynamic> joinChallenge(String id) async {
    final response = await _apiService.joinChallenge({'challengeId': id});
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to join challenge',
      );
    }
  }

  @override
  Future<dynamic> validateWeek(
    String userChallengeId,
    int weekNumber,
    double amount,
  ) async {
    final response = await _apiService.validateWeek({
      'userChallengeId': userChallengeId,
      'weekNumber': weekNumber,
      'amount': amount,
    });
    if (response.isSuccessful) {
      return response.body?.data;
    } else {
      throw Exception(
        response.body?.message ??
            response.error?.toString() ??
            'Failed to validate week',
      );
    }
  }
}
