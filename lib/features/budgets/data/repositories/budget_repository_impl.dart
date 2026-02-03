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

  @override
  Future<Either<Failure, List<BudgetModel>>> getBudgets({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final localBudgets = await _localDataSource.getBudgets();
      if (localBudgets.isNotEmpty) {
        return Right(localBudgets);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        final remoteBudgets = await _remoteDataSource.getBudgets();
        await _localDataSource.clearBudgets();
        await _localDataSource.saveBudgets(remoteBudgets);
        return Right(remoteBudgets);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final localBudgets = await _localDataSource.getBudgets();
      if (localBudgets.isNotEmpty) {
        return Right(localBudgets);
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, BudgetModel>> createBudget(BudgetModel budget) async {
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
        return Right(remoteBudget);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
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
    // Save locally first
    await _localDataSource.saveBudget(budget);

    if (await _networkInfo.isConnected) {
      try {
        final remoteBudget = await _remoteDataSource.updateBudget(budget);
        await _localDataSource.saveBudget(remoteBudget);
        return Right(remoteBudget);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
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
    await _localDataSource.deleteBudget(id);

    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteBudget(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
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
  Future<Either<Failure, AutoBudgetResponse>> generateAutoBudget() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDataSource.generateAutoBudget();
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
