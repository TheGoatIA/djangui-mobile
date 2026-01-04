import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';

abstract class InsightRepository {
  Future<Either<Failure, dynamic>> getDashboardSummary();

  Future<Either<Failure, dynamic>> getSpendingAnalysis({int? month, int? year});

  Future<Either<Failure, dynamic>> getNarrative({int? month, int? year});
}
