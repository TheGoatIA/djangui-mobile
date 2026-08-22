import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/reports_model.dart';

abstract class ReportsRepository {
  Future<Either<Failure, DashboardReportModel>> getDashboardReport();

  /// [period] filtre la fenêtre analysée : 'weekly' (7 derniers jours),
  /// 'monthly' (mois calendaire courant, défaut) ou 'yearly' (année
  /// calendaire courante).
  Future<Either<Failure, List<SpendingAnalysisModel>>> getSpendingAnalysis({
    String? period,
  });

  /// [period] contrôle le regroupement des points de la courbe : par jour
  /// (weekly), par mois (monthly, défaut) ou par année (yearly).
  Future<Either<Failure, List<SavingsTrendModel>>> getSavingsTrend({
    String? period,
  });
  Future<Either<Failure, NarrativeReportModel>> getNarrativeReport();
}
