import 'package:injectable/injectable.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_api_service.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import '../../../../core/network/api_response_extensions.dart';

abstract class ChallengeRemoteDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<List<UserChallengeModel>> getUserChallenges();
  Future<UserChallengeModel> joinChallenge(String id);
  Future<UserChallengeModel> validateWeek(
    String userChallengeId,
    int weekNumber,
    double amount,
    String? proofPath,
  );
  Future<void> unjoinChallenge(String id);
  Future<void> skipWeek(String userChallengeId);
  Future<void> postponeDeadline(String userChallengeId);
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
    String? proofPath,
  ) async {
    http.MultipartFile? multipartFile;

    if (proofPath != null) {
      final extension = path.extension(proofPath).toLowerCase();
      String mimeType = 'image/jpeg';
      if (extension == '.png') {
        mimeType = 'image/png';
      } else if (extension == '.webp') {
        mimeType = 'image/webp';
      } else if (extension == '.pdf') {
        mimeType = 'application/pdf';
      }

      multipartFile = await http.MultipartFile.fromPath(
        'proof',
        proofPath,
        contentType: MediaType.parse(mimeType),
      );
    }

    final response = await _apiService.validateWeek(
      userChallengeId,
      weekNumber,
      amount,
      multipartFile,
    );
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

  @override
  Future<void> skipWeek(String userChallengeId) async {
    final response = await _apiService.skipWeek(userChallengeId);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> postponeDeadline(String userChallengeId) async {
    final response = await _apiService.postponeDeadline(userChallengeId);
    if (!response.isSuccessful) {
      throw Exception(response.errorMessage);
    }
  }
}
