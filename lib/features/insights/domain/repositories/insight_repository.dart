import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/insight_model.dart';

abstract class InsightRepository {
  Future<Either<Failure, List<CategoryDistributionModel>>>
  getCategoryDistribution(String period);
  Future<Either<Failure, List<SpendingTrendModel>>> getSpendingTrends(
    String period,
  );
}
