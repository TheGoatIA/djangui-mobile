import 'package:fpdart/fpdart.dart';
import 'package:kauri/core/errors/failures.dart';

abstract class PremiumRepository {
  Future<Either<Failure, Map<String, dynamic>>> askCoach(String message);
  Future<Either<Failure, Map<String, dynamic>>> getAutoBudget();
  Future<Either<Failure, Map<String, dynamic>>> getPremiumReport();
}
