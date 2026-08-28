import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/goal_model.dart';

abstract class GoalRepository {
  Future<Either<Failure, List<GoalModel>>> getGoals({
    bool forceRefresh = false,
  });
  Future<Either<Failure, GoalModel>> createGoal(GoalModel goal);
  Future<Either<Failure, void>> deleteGoal(String id);
  Future<Either<Failure, GoalModel>> updateGoalAmount(
    String id,
    double amount, {
    String? note,
  });
  Future<Either<Failure, GoalModel>> redeemGoal(String id, double? amount);
  Future<Either<Failure, String>> shareGoal(String id);
  Future<Either<Failure, GoalModel>> joinGoal(String inviteCode);
  Future<Either<Failure, List<GoalParticipantModel>>> getParticipants(String id);
  Future<Either<Failure, void>> removeParticipant(String id, String participantId);
  Future<Either<Failure, void>> leaveGoal(String id);
}
