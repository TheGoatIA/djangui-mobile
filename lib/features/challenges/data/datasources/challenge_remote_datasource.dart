import 'package:injectable/injectable.dart';
import 'challenge_api_service.dart';
import '../models/challenge_model.dart';

abstract class ChallengeRemoteDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<ChallengeModel> joinChallenge(String id);
  Future<ChallengeModel> updateProgress(String id, double value);
}

@LazySingleton(as: ChallengeRemoteDataSource)
class ChallengeRemoteDataSourceImpl implements ChallengeRemoteDataSource {
  final ChallengeApiService _apiService;

  ChallengeRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ChallengeModel>> getChallenges() async {
    final response = await _apiService.getChallenges();
    if (response.isSuccessful) {
      return response.body ?? [];
    } else {
      throw Exception('Failed to fetch challenges');
    }
  }

  @override
  Future<ChallengeModel> joinChallenge(String id) async {
    final response = await _apiService.joinChallenge(id);
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception('Failed to join challenge');
    }
  }

  @override
  Future<ChallengeModel> updateProgress(String id, double value) async {
    final response = await _apiService.updateProgress(id, {
      'currentValue': value,
    });
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      throw Exception('Failed to update challenge progress');
    }
  }
}
