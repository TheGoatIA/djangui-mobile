import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/budget_local_datasource.dart';
import '../datasources/budget_remote_datasource.dart';
import '../../domain/repositories/budget_repository.dart';
import '../models/budget_model.dart';
import '../models/auto_budget_response.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;
  final BudgetLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppDatabase _database;

  BudgetRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
    this._database,
  );

  LogService get _logger => getIt<LogService>();

  @override
  Future<Either<Failure, List<BudgetModel>>> getBudgets({
    bool forceRefresh = false,
  }) async {
    _logger.info(
      'Récupération des budgets (forceRefresh: $forceRefresh)...',
      component: 'BudgetRepository',
    );
    if (!forceRefresh) {
      final localBudgets = await _localDataSource.getBudgets();
      if (localBudgets.isNotEmpty) {
        _logger.info(
          '${localBudgets.length} budgets récupérés du cache local.',
          component: 'BudgetRepository',
        );
        return Right(localBudgets);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        final remoteBudgets = await _remoteDataSource.getBudgets();
        await _localDataSource.clearBudgets();
        await _localDataSource.saveBudgets(remoteBudgets);
        _logger.info(
          '${remoteBudgets.length} budgets récupérés du serveur.',
          component: 'BudgetRepository',
        );
        return Right(remoteBudgets);
      } catch (e) {
        _logger.error(
          'Erreur lors de la récupération des budgets du serveur',
          error: e,
          component: 'BudgetRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final localBudgets = await _localDataSource.getBudgets();
      if (localBudgets.isNotEmpty) {
        _logger.info(
          '${localBudgets.length} budgets récupérés du cache (mode hors-ligne).',
          component: 'BudgetRepository',
        );
        return Right(localBudgets);
      }
      _logger.warning(
        'Aucun budget trouvé et pas de connexion réseau.',
        component: 'BudgetRepository',
      );
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget) async {
    _logger.info(
      "Création d'un budget pour ${budget.period.month}/${budget.period.year}",
      component: 'BudgetRepository',
    );
    // Save locally first (Optimistic)
    final tempId = budget.id.isEmpty
        ? 'temp_${DateTime.now().millisecondsSinceEpoch}'
        : budget.id;
    final budgetToSave = budget.copyWith(id: tempId);
    await _localDataSource.saveBudget(budgetToSave);

    if (await _networkInfo.isConnected) {
      try {
        final remoteBudget = await _remoteDataSource.createBudget(budget);
        await _localDataSource.deleteBudget(tempId); // Remove temp
        await _localDataSource.saveBudget(remoteBudget);
        _logger.info(
          'Budget créé avec succès sur le serveur.',
          component: 'BudgetRepository',
          metadata: {'id': remoteBudget.id},
        );
        return Right(remoteBudget);
      } catch (e) {
        _logger.error(
          'Échec de la création du budget sur le serveur',
          error: e,
          component: 'BudgetRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.info(
        'Mode hors-ligne: Budget ajouté à la file d\'attente de synchronisation.',
        component: 'BudgetRepository',
      );
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'budgets',
              action: 'create',
              payload: jsonEncode(budgetToSave.toJson()),
            ),
          );
      return Right(budgetToSave);
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> updateBudget(BudgetModel budget) async {
    _logger.info(
      "Mise à jour du budget pour ${budget.period.month}/${budget.period.year} (${budget.id})",
      component: 'BudgetRepository',
    );
    // Save locally first
    await _localDataSource.saveBudget(budget);

    if (await _networkInfo.isConnected) {
      try {
        final remoteBudget = await _remoteDataSource.updateBudget(budget);
        await _localDataSource.saveBudget(remoteBudget);
        _logger.info(
          'Budget mis à jour avec succès sur le serveur.',
          component: 'BudgetRepository',
          metadata: {'id': budget.id},
        );
        return Right(remoteBudget);
      } catch (e) {
        _logger.error(
          'Échec de la mise à jour du budget sur le serveur',
          error: e,
          component: 'BudgetRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.info(
        'Mode hors-ligne: Mise à jour ajoutée à la file d\'attente de synchronisation.',
        component: 'BudgetRepository',
      );
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'budgets',
              action: 'update',
              payload: jsonEncode(budget.toJson()),
            ),
          );
      return Right(budget);
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    _logger.info('Suppression du budget: $id', component: 'BudgetRepository');
    await _localDataSource.deleteBudget(id);

    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteBudget(id);
        _logger.info(
          'Budget supprimé avec succès du serveur.',
          component: 'BudgetRepository',
          metadata: {'id': id},
        );
        return const Right(null);
      } catch (e) {
        _logger.error(
          'Échec de la suppression du budget sur le serveur',
          error: e,
          component: 'BudgetRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.info(
        'Mode hors-ligne: Suppression ajoutée à la file d\'attente de synchronisation.',
        component: 'BudgetRepository',
      );
      await _database
          .into(_database.syncRequests)
          .insert(
            SyncRequestsCompanion.insert(
              table: 'budgets',
              action: 'delete',
              payload: jsonEncode({'id': id}),
            ),
          );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, AutoBudgetResponse>> generateAutoBudget({
    int? month,
    int? year,
  }) async {
    _logger.info(
      'Génération automatique d\'un budget (month: $month, year: $year)...',
      component: 'BudgetRepository',
    );
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.generateAutoBudget(
          month: month,
          year: year,
        );
        _logger.info(
          'Budget automatique généré avec succès.',
          component: 'BudgetRepository',
        );
        return Right(result);
      } catch (e) {
        _logger.error(
          'Échec de la génération automatique du budget',
          error: e,
          component: 'BudgetRepository',
        );
        return Left(ServerFailure(e.toString()));
      }
    } else {
      _logger.warning(
        'Impossible de générer un budget automatique hors-ligne.',
        component: 'BudgetRepository',
      );
      return Left(NetworkFailure());
    }
  }
}
