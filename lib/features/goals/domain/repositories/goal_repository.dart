import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/goal_model.dart';

abstract class GoalRepository {
  Future<Either<Failure, List<GoalModel>>> getGoals({
    bool forceRefresh = false,
  });
  Future<Either<Failure, GoalModel>> createGoal(GoalModel goal);
  Future<Either<Failure, void>> deleteGoal(String id);
  Future<Either<Failure, GoalModel>> updateGoalAmount(String id, double amount);
}
