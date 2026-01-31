import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/goal_local_datasource.dart';
import '../datasources/goal_remote_datasource.dart';
import '../../domain/repositories/goal_repository.dart';
import '../models/goal_model.dart';

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

  @override
  Future<Either<Failure, List<GoalModel>>> getGoals({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final localGoals = await _localDataSource.getGoals();
      if (localGoals.isNotEmpty) {
        return Right(localGoals);
      }
    }

    if (await _networkInfo.isConnected) {
      try {
        final remoteGoals = await _remoteDataSource.getGoals();
        await _localDataSource.clearGoals();
        await _localDataSource.saveGoals(remoteGoals);
        return Right(remoteGoals);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      final localGoals = await _localDataSource.getGoals();
      if (localGoals.isNotEmpty) {
        return Right(localGoals);
      }
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GoalModel>> createGoal(GoalModel goal) async {
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
        return Right(remoteGoal);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Offline: Queue it
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
    await _localDataSource.deleteGoal(id);

    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteGoal(id);
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
    double amount,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.contributeToGoal(id, amount);
        final updatedGoal = await _remoteDataSource.getGoals().then(
          (goals) => goals.firstWhere((g) => g.id == id),
        );
        await _localDataSource.saveGoal(updatedGoal);
        return Right(updatedGoal);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
