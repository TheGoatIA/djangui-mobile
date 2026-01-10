import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/reports_model.dart';

abstract class ReportsRepository {
  Future<Either<Failure, DashboardReportModel>> getDashboardReport();
  Future<Either<Failure, List<SpendingAnalysisModel>>> getSpendingAnalysis();
  Future<Either<Failure, List<SavingsTrendModel>>> getSavingsTrend();
  Future<Either<Failure, NarrativeReportModel>> getNarrativeReport();
}
