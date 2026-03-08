import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/database/database.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/core/network/network_info.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_local_datasource.dart';
import 'package:kauri/features/challenges/data/datasources/challenge_remote_datasource.dart';
import 'package:kauri/features/challenges/domain/repositories/challenge_repository.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';

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

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<ChallengeModel>>> getChallenges({
    bool forceRefresh = false,
  }) async {
    _logger.info(
      'Récupération de la liste des défis (forceRefresh: $forceRefresh)...',
      component: 'ChallengeRepository',
    );
    if (!forceRefresh) {
      final localChallenges = await _localDataSource.getChallenges();
      if (localChallenges.isNotEmpty) {
        _logger.info(
          '${localChallenges.length} défis récupérés du cache local.',
          component: 'ChallengeRepository',
        );
        return Right(localChallenges);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        _logger.info(
          'Récupération des défis depuis le serveur...',
          component: 'ChallengeRepository',
        );
        final remoteChallenges = await _remoteDataSource.getChallenges();
        _logger.info(
          '${remoteChallenges.length} défis reçus du serveur.',
          component: 'ChallengeRepository',
        );

        try {
          _logger.info(
            'Synchronisation des défis vers le cache local...',
            component: 'ChallengeRepository',
          );
          await _localDataSource.clearChallenges();
          await _localDataSource.saveChallenges(remoteChallenges);
          _logger.info(
            'Synchronisation réussie.',
            component: 'ChallengeRepository',
          );
        } catch (localError) {
          _logger.warning(
            'Échec de la synchronisation locale des défis',
            metadata: {'error': localError.toString()},
            component: 'ChallengeRepository',
          );
        }

        return Right(remoteChallenges);
      } catch (e) {
        _logger.error(
          'Erreur lors de la récupération des défis (Serveur)',
          error: e,
          component: 'ChallengeRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final localChallenges = await _localDataSource.getChallenges();
      if (localChallenges.isNotEmpty) {
        _logger.info(
          '${localChallenges.length} défis récupérés du cache (mode hors-ligne).',
          component: 'ChallengeRepository',
        );
        return Right(localChallenges);
      }
      _logger.warning(
        'Aucun défi trouvé en cache et pas de connexion réseau.',
        component: 'ChallengeRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserChallengeModel>>> getUserChallenges() async {
    _logger.info(
      'Récupération de mes défis en cours...',
      component: 'ChallengeRepository',
    );
    // Try local cache first if offline
    final localChallengesJson = await _localDataSource.getUserChallenges();

    if (!await _networkInfo.isConnected) {
      if (localChallengesJson.isNotEmpty) {
        final localModels = localChallengesJson
            .map((e) => UserChallengeModel.fromJson(e))
            .toList();
        _logger.info(
          '${localModels.length} défis utilisateur récupérés du cache (hors-ligne).',
          component: 'ChallengeRepository',
        );
        return Right(localModels);
      }
      return Left(NetworkFailure());
    }

    // Fetch from remote and cache
    try {
      final result = await _remoteDataSource.getUserChallenges();
      _logger.info(
        '${result.length} défis utilisateur récupérés du serveur.',
        component: 'ChallengeRepository',
      );
      // Cache the result
      await _localDataSource.saveUserChallenges(
        result.map((e) => e.toJson()).toList(),
      );
      return Right(result);
    } catch (e) {
      // Fallback to cache on error
      if (localChallengesJson.isNotEmpty) {
        _logger.error(
          'Erreur serveur (getUserChallenges), fallback sur le cache.',
          error: e,
          component: 'ChallengeRepository',
        );
        final localModels = localChallengesJson
            .map((e) => UserChallengeModel.fromJson(e))
            .toList();
        return Right(localModels);
      }
      _logger.error(
        'Échec de la récupération des défis utilisateur.',
        error: e,
        component: 'ChallengeRepository',
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinChallenge(String id) async {
    _logger.info('Inscription au défi: $id', component: 'ChallengeRepository');
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.joinChallenge(id);
        _logger.info(
          'Inscription réussie sur le serveur.',
          component: 'ChallengeRepository',
        );
        return const Right(null);
      } catch (e) {
        _logger.error(
          'Échec de l\'inscription au défi sur le serveur',
          error: e,
          component: 'ChallengeRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      _logger.info(
        'Mode hors-ligne: Inscription ajoutée à la file d\'attente.',
        component: 'ChallengeRepository',
      );
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
    String? note,
  }) async {
    _logger.info(
      'Validation de la semaine $weekNumber pour le défi: $userChallengeId',
      component: 'ChallengeRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.validateWeek(
          userChallengeId,
          weekNumber,
          amount,
          note,
        );
        _logger.info(
          'Validation réussie sur le serveur.',
          component: 'ChallengeRepository',
        );
        return const Right(null);
      } catch (e) {
        _logger.error(
          'Échec de la validation de la semaine sur le serveur',
          error: e,
          component: 'ChallengeRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
      _logger.info(
        'Mode hors-ligne: Validation ajoutée à la file d\'attente.',
        component: 'ChallengeRepository',
      );
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
                'note': note,
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

  @override
  Future<Either<Failure, void>> skipWeek(
    String userChallengeId,
    int weekNumber,
  ) async {
    _logger.info(
      'Saut de semaine: $userChallengeId',
      component: 'ChallengeRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.skipWeek(userChallengeId, weekNumber);
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
              action: 'skip_week',
              payload: jsonEncode({
                'userChallengeId': userChallengeId,
                'weekNumber': weekNumber,
              }),
            ),
          );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> postponeDeadline(
    String userChallengeId,
    int weekNumber,
  ) async {
    _logger.info(
      'Report de deadline: $userChallengeId',
      component: 'ChallengeRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.postponeDeadline(userChallengeId, weekNumber);
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
              action: 'postpone_deadline',
              payload: jsonEncode({
                'userChallengeId': userChallengeId,
                'weekNumber': weekNumber,
              }),
            ),
          );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, ChallengeRedeemModel>> redeemChallenge(
    String id,
  ) async {
    _logger.info(
      'Récupération des fonds du défi: $id',
      component: 'ChallengeRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.redeemChallenge(id);
        _logger.info(
          'Fonds récupérés avec succès sur le serveur.',
          component: 'ChallengeRepository',
        );
        return Right(result);
      } catch (e) {
        _logger.error(
          'Échec de la récupération des fonds sur le serveur',
          error: e,
          component: 'ChallengeRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
