import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/database/database.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/core/network/network_info.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_local_datasource.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_remote_datasource.dart';
import 'package:kauri/features/challenges/domain/repositories/challenge_repository.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';

@LazySingleton(as: ChallengeRepository)
class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeRemoteDataSource _remoteDataSource;
  final ChallengeLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppDatabase _database;

  ChallengeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._database,
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
        debugPrint('🏆 [ChallengeRepository] Fetching remote challenges...');
        final remoteChallenges = await _remoteDataSource.getChallenges();
        debugPrint(
          '🏆 [ChallengeRepository] Received ${remoteChallenges.length} from remote',
        );

        try {
          debugPrint(
            '🏆 [ChallengeRepository] Clearing and saving to local...',
          );
          await _localDataSource.clearChallenges();
          await _localDataSource.saveChallenges(remoteChallenges);
          debugPrint('🏆 [ChallengeRepository] Local storage sync successful');
        } catch (localError) {
          debugPrint(
            '🏆 [ChallengeRepository] WARNING: Local storage sync failed: $localError',
          );
          // Still return remote results even if local save fails
        }

        return Right(remoteChallenges);
      } catch (e, stack) {
        debugPrint('🏆 [ChallengeRepository] ERROR in remote fetch: $e');
        debugPrint(stack.toString());
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
    final localChallengesJson = await _localDataSource.getUserChallenges();

    if (!await _networkInfo.isConnected) {
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
      await _localDataSource.saveUserChallenges(
        result.map((e) => e.toJson()).toList(),
      );
      return Right(result);
    } catch (e) {
      // Fallback to cache on error
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
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'challenges',
              action: 'join',
              payload: jsonEncode({'id': id}),
            ),
          );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> validateWeek({
    required String userChallengeId,
    required int weekNumber,
    required double amount,
    required String proofPath,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.validateWeek(
          userChallengeId,
          weekNumber,
          amount,
          proofPath,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'challenges',
              action: 'validate_week',
              payload: jsonEncode({
                'userChallengeId': userChallengeId,
                'weekNumber': weekNumber,
                'amount': amount,
                'proofPath': proofPath,
              }),
            ),
          );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> unjoinChallenge(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.unjoinChallenge(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'challenges',
              action: 'unjoin',
              payload: jsonEncode({'id': id}),
            ),
          );
      return const Right(null);
    }
  }
}
