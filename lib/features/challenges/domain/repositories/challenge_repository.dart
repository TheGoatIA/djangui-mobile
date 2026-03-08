import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/challenge_model.dart';

abstract class ChallengeRepository {
  Future<Either<Failure, List<ChallengeModel>>> getChallenges({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<UserChallengeModel>>> getUserChallenges();

  Future<Either<Failure, void>> joinChallenge(String id);

  Future<Either<Failure, void>> validateWeek({
    required String userChallengeId,
    required int weekNumber,
    required double amount,
    String? note,
  });

  Future<Either<Failure, void>> unjoinChallenge(String id);

  Future<Either<Failure, void>> skipWeek(
    String userChallengeId,
    int weekNumber,
  );

  Future<Either<Failure, void>> postponeDeadline(
    String userChallengeId,
    int weekNumber,
  );

  Future<Either<Failure, ChallengeRedeemModel>> redeemChallenge(String id);
}
