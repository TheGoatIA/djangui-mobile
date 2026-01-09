import 'package:injectable/injectable.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_api_service.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import '../../../../core/network/api_response_extensions.dart';

abstract class ChallengeRemoteDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<List<UserChallengeModel>> getUserChallenges();
  Future<UserChallengeModel> joinChallenge(String id);
  Future<UserChallengeModel> validateWeek(
    String userChallengeId,
    int weekNumber,
    double amount,
  );
  Future<void> unjoinChallenge(String id);
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
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<List<UserChallengeModel>> getUserChallenges() async {
    final response = await _apiService.getUserChallenges();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<UserChallengeModel> joinChallenge(String id) async {
    final response = await _apiService.joinChallenge({'challengeId': id});
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<UserChallengeModel> validateWeek(
    String userChallengeId,
    int weekNumber,
    double amount,
  ) async {
    final response = await _apiService.validateWeek({
      'userChallengeId': userChallengeId,
      'weekNumber': weekNumber,
      'amount': amount,
    });
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    } else {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> unjoinChallenge(String id) async {
    final response = await _apiService.unjoinChallenge(id);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
