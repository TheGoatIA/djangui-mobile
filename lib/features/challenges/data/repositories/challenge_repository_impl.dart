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
        final remoteChallenges = await _remoteDataSource.getChallenges();
        await _localDataSource.clearChallenges();
        await _localDataSource.saveChallenges(remoteChallenges);
        return Right(remoteChallenges);
      } catch (e) {
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
  Future<Either<Failure, List<dynamic>>> getUserChallenges() async {
    // Try local cache first if offline
    if (!await _networkInfo.isConnected) {
      final localChallenges = _localDataSource.getUserChallenges();
      if (localChallenges.isNotEmpty) {
        return Right(localChallenges);
      }
      return Left(NetworkFailure());
    }

    // Fetch from remote and cache
    try {
      final result = await _remoteDataSource.getUserChallenges();
      // Cache the result
      _localDataSource.saveUserChallenges(
        result.map((e) => e as Map<String, dynamic>).toList(),
      );
      return Right(result);
    } catch (e) {
      // Fallback to cache on error
      final localChallenges = _localDataSource.getUserChallenges();
      if (localChallenges.isNotEmpty) {
        return Right(localChallenges);
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
