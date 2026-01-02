import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/challenge_model.dart';

abstract class ChallengeRepository {
  Future<Either<Failure, List<ChallengeModel>>> getChallenges({
    bool forceRefresh = false,
  });
  Future<Either<Failure, ChallengeModel>> joinChallenge(String id);
  Future<Either<Failure, ChallengeModel>> updateProgress(
    String id,
    double value,
  );
}
