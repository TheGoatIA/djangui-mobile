import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/challenge_local_datasource.dart';
import '../datasources/challenge_remote_datasource.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../models/challenge_model.dart';

@LazySingleton(as: ChallengeRepository)
class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeRemoteDataSource _remoteDataSource;
  final ChallengeLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ChallengeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<ChallengeModel>>> getChallenges({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final localChallenges = await _localDataSource.getChallenges();
      if (localChallenges.isNotEmpty) {
        return Right(localChallenges);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        print('🏆 [ChallengeRepository] Fetching remote challenges...');
        final remoteChallenges = await _remoteDataSource.getChallenges();
        print(
          '🏆 [ChallengeRepository] Received ${remoteChallenges.length} from remote',
        );

        try {
          print('🏆 [ChallengeRepository] Clearing and saving to local...');
          await _localDataSource.clearChallenges();
          await _localDataSource.saveChallenges(remoteChallenges);
          print('🏆 [ChallengeRepository] Local storage sync successful');
        } catch (localError) {
          print(
            '🏆 [ChallengeRepository] WARNING: Local storage sync failed: $localError',
          );
          // Still return remote results even if local save fails
        }

        return Right(remoteChallenges);
      } catch (e, stack) {
        print('🏆 [ChallengeRepository] ERROR in remote fetch: $e');
        print(stack);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final localChallenges = await _localDataSource.getChallenges();
      if (localChallenges.isNotEmpty) {
        return Right(localChallenges);
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserChallengeModel>>> getUserChallenges() async {
    // Try local cache first if offline
    if (!await _networkInfo.isConnected) {
      final localChallengesJson = _localDataSource.getUserChallenges();
      if (localChallengesJson.isNotEmpty) {
        final localModels = localChallengesJson
            .map((e) => UserChallengeModel.fromJson(e))
            .toList();
        return Right(localModels);
      }
      return Left(NetworkFailure());
    }

    // Fetch from remote and cache
    try {
      final result = await _remoteDataSource.getUserChallenges();
      // Cache the result
      _localDataSource.saveUserChallenges(
        result.map((e) => e.toJson()).toList(),
      );
      return Right(result);
    } catch (e) {
      // Fallback to cache on error
      final localChallengesJson = _localDataSource.getUserChallenges();
      if (localChallengesJson.isNotEmpty) {
        final localModels = localChallengesJson
            .map((e) => UserChallengeModel.fromJson(e))
            .toList();
        return Right(localModels);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinChallenge(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.joinChallenge(id);
        // We might want to refresh challenges or user challenges here
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> validateWeek({
    required String userChallengeId,
    required int weekNumber,
    required double amount,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.validateWeek(
          userChallengeId,
          weekNumber,
          amount,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
