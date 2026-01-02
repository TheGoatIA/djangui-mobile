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
  Future<Either<Failure, ChallengeModel>> joinChallenge(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final challenge = await _remoteDataSource.joinChallenge(id);
        await _localDataSource.saveChallenge(challenge);
        return Right(challenge);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ChallengeModel>> updateProgress(
    String id,
    double value,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final challenge = await _remoteDataSource.updateProgress(id, value);
        await _localDataSource.saveChallenge(challenge);
        return Right(challenge);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
