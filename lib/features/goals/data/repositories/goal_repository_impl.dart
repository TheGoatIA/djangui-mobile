import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
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

  GoalRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
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
    if (await _networkInfo.isConnected) {
      try {
        final remoteGoal = await _remoteDataSource.createGoal(goal);
        await _localDataSource.saveGoal(remoteGoal);
        return Right(remoteGoal);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteGoal(id);
        await _localDataSource.deleteGoal(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GoalModel>> updateGoalAmount(
    String id,
    double amount,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteGoal = await _remoteDataSource.updateGoalAmount(id, amount);
        await _localDataSource.saveGoal(remoteGoal);
        return Right(remoteGoal);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
