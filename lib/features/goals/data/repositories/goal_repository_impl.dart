import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/goal_local_datasource.dart';
import '../datasources/goal_remote_datasource.dart';
import '../../domain/repositories/goal_repository.dart';
import '../models/goal_model.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/core/error/error_mapper.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  final GoalRemoteDataSource _remoteDataSource;
  final GoalLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppDatabase _database;

  GoalRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._database,
  );

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<GoalModel>>> getGoals({
    bool forceRefresh = false,
  }) async {
    _logger.info(
      'Récupération des objectifs (forceRefresh: $forceRefresh)...',
      component: 'GoalRepository',
    );
    if (!forceRefresh) {
      final localGoals = await _localDataSource.getGoals();
      if (localGoals.isNotEmpty) {
        _logger.info(
          '${localGoals.length} objectifs récupérés du cache local.',
          component: 'GoalRepository',
        );
        return Right(localGoals);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        final remoteGoals = await _remoteDataSource.getGoals();
        await _localDataSource.clearGoals();
        await _localDataSource.saveGoals(remoteGoals);
        _logger.info(
          '${remoteGoals.length} objectifs récupérés du serveur.',
          component: 'GoalRepository',
        );
        return Right(remoteGoals);
      } catch (e) {
        _logger.error(
          'Erreur lors de la récupération des objectifs du serveur',
          error: e,
          component: 'GoalRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      final localGoals = await _localDataSource.getGoals();
      if (localGoals.isNotEmpty) {
        _logger.info(
          '${localGoals.length} objectifs récupérés du cache (mode hors-ligne).',
          component: 'GoalRepository',
        );
        return Right(localGoals);
      }
      _logger.warning(
        'Aucun objectif trouvé et pas de connexion réseau.',
        component: 'GoalRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GoalModel>> createGoal(GoalModel goal) async {
    _logger.info(
      'Création d\'un objectif: ${goal.name}',
      component: 'GoalRepository',
    );
    // Save locally first (Optimistic UI)
    await _localDataSource.saveGoal(goal);

    if (await _networkInfo.isConnected) {
      try {
        final remoteGoal = await _remoteDataSource.createGoal(goal);
        // Update local with remote version (might have real ID)
        if (remoteGoal.id != goal.id) {
          await _localDataSource.deleteGoal(goal.id);
        }
        await _localDataSource.saveGoal(remoteGoal);
        _logger.info(
          'Objectif créé avec succès sur le serveur.',
          component: 'GoalRepository',
          metadata: {'id': remoteGoal.id},
        );
        return Right(remoteGoal);
      } catch (e) {
        // Le serveur a rejeté la création : l'objectif optimiste écrit en
        // local n'existe nulle part ailleurs, donc on le retire plutôt que
        // de laisser un objectif fantôme dans le cache.
        await _localDataSource.deleteGoal(goal.id);
        _logger.error(
          'Échec de la création de l\'objectif sur le serveur',
          error: e,
          component: 'GoalRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Offline: Queue it
      _logger.info(
        'Mode hors-ligne: Objectif ajouté à la file d\'attente de synchronisation.',
        component: 'GoalRepository',
      );
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'goals',
              action: 'create',
              payload: jsonEncode(goal.toJson()),
            ),
          );
      return Right(goal);
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    _logger.info(
      'Suppression de l\'objectif: $id',
      component: 'GoalRepository',
    );

    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteGoal(id);
        // On ne retire du cache local qu'une fois la suppression confirmée
        // par le serveur : sinon un objectif dont l'argent est toujours
        // détenu par le serveur (échec réseau, rejet) disparaîtrait
        // silencieusement de l'app alors que rien n'a réellement été
        // supprimé ni remboursé.
        await _localDataSource.deleteGoal(id);
        _logger.info(
          'Objectif supprimé avec succès du serveur.',
          component: 'GoalRepository',
          metadata: {'id': id},
        );
        return const Right(null);
      } catch (e) {
        _logger.error(
          'Échec de la suppression de l\'objectif sur le serveur',
          error: e,
          component: 'GoalRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Offline: Queue it (suppression optimiste assumée ici, rejouée plus
      // tard par SyncService)
      await _localDataSource.deleteGoal(id);
      _logger.info(
        'Mode hors-ligne: Suppression ajoutée à la file d\'attente de synchronisation.',
        component: 'GoalRepository',
      );
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'goals',
              action: 'delete',
              payload: jsonEncode({'id': id}),
            ),
          );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, GoalModel>> updateGoalAmount(
    String id,
    double amount, {
    String? note,
  }) async {
    _logger.info(
      'Contribution à l\'objectif: $id (montant: $amount, note: $note)',
      component: 'GoalRepository',
    );
    final localGoals = await _localDataSource.getGoals();
    final goal = localGoals.firstWhereOrNull((g) => g.id == id);

    if (goal != null) {
      // Optimistic update
      final updatedLocalGoal = goal.copyWith(
        currentAmount: goal.currentAmount + amount,
        progress: ((goal.currentAmount + amount) / goal.targetAmount).clamp(
          0.0,
          1.0,
        ),
      );
      await _localDataSource.saveGoal(updatedLocalGoal);
    }

    if (await _networkInfo.isConnected) {
      try {
        final updatedGoal = await _remoteDataSource.contributeToGoal(
          id,
          amount,
          note: note,
        );
        await _localDataSource.saveGoal(updatedGoal);
        _logger.info(
          'Contribution enregistrée avec succès sur le serveur.',
          component: 'GoalRepository',
          metadata: {'id': id},
        );
        return Right(updatedGoal);
      } catch (e) {
        // Le serveur a rejeté la contribution : on annule l'écriture
        // optimiste locale, sinon le prochain `getGoals(forceRefresh: false)`
        // lirait un montant que le serveur n'a jamais appliqué.
        if (goal != null) {
          await _localDataSource.saveGoal(goal);
        }
        _logger.error(
          'Échec de la contribution sur le serveur',
          error: e,
          component: 'GoalRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Offline: Queue it
      _logger.info(
        'Mode hors-ligne: Contribution ajoutée à la file d\'attente de synchronisation.',
        component: 'GoalRepository',
      );
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'goals',
              action: 'contribute',
              // Clé générée une seule fois ici et réutilisée à chaque
              // tentative de rejeu par SyncService (K-17).
              payload: jsonEncode({
                'id': id,
                'amount': amount,
                'note': note,
                'idempotencyKey': const Uuid().v4(),
              }),
            ),
          );

      // Return the optimistic goal if available, else a dummy
      return Right(
        goal?.copyWith(currentAmount: goal.currentAmount + amount) ??
            GoalModel(
              id: id,
              name: '',
              targetAmount: 0,
              currentAmount: amount,
              deadline: DateTime.now(),
              createdAt: DateTime.now(),
            ),
      );
    }
  }

  @override
  Future<Either<Failure, GoalModel>> redeemGoal(
    String id,
    double? amount,
  ) async {
    _logger.info(
      'Rachat de l\'objectif: $id (montant: ${amount ?? "tout"})',
      component: 'GoalRepository',
    );

    if (await _networkInfo.isConnected) {
      try {
        final updatedGoal = await _remoteDataSource.redeemGoal(
          id,
          amount: amount,
        );
        await _localDataSource.saveGoal(updatedGoal);
        _logger.info(
          'Rachat enregistré avec succès sur le serveur.',
          component: 'GoalRepository',
          metadata: {'id': id},
        );
        return Right(updatedGoal);
      } catch (e) {
        _logger.error(
          'Échec du rachat sur le serveur',
          error: e,
          component: 'GoalRepository',
        );
        return Left(ServerFailure(ErrorMapper.safeMessage(e)));
      }
    } else {
      // Offline redemption is tricky because it affects balance immediately.
      // For now, let's treat it as a server-only action or queue it.
      return Left(ServerFailure('Connexion requise pour le rachat de fonds.'));
    }
  }

  // ─── PARTAGE ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> shareGoal(String id) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());
    try {
      final code = await _remoteDataSource.shareGoal(id);
      return Right(code);
    } catch (e) {
      _logger.error(
        'Échec du partage de l\'objectif',
        error: e,
        component: 'GoalRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, GoalModel>> joinGoal(String inviteCode) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());
    try {
      final goal = await _remoteDataSource.joinGoal(inviteCode);
      await _localDataSource.saveGoal(goal);
      return Right(goal);
    } catch (e) {
      _logger.error(
        'Échec pour rejoindre l\'objectif',
        error: e,
        component: 'GoalRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<GoalParticipantModel>>> getParticipants(
    String id,
  ) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());
    try {
      final result = await _remoteDataSource.getParticipants(id);
      return Right(result);
    } catch (e) {
      _logger.error(
        'Échec de la récupération des participants',
        error: e,
        component: 'GoalRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> removeParticipant(
    String id,
    String participantId,
  ) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());
    try {
      await _remoteDataSource.removeParticipant(id, participantId);
      return const Right(null);
    } catch (e) {
      _logger.error(
        'Échec du retrait du participant',
        error: e,
        component: 'GoalRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGoal(String id) async {
    if (!await _networkInfo.isConnected) return Left(NetworkFailure());
    try {
      await _remoteDataSource.leaveGoal(id);
      await _localDataSource.deleteGoal(id);
      return const Right(null);
    } catch (e) {
      _logger.error(
        'Échec pour quitter l\'objectif',
        error: e,
        component: 'GoalRepository',
      );
      return Left(ServerFailure(ErrorMapper.safeMessage(e)));
    }
  }
}
