import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/reports_model.dart';

abstract class ReportsRepository {
  Future<Either<Failure, DashboardReportModel>> getDashboardReport();

  /// Local cache only, never touches the network — used to paint the
  /// dashboard instantly while [getDashboardReport] refreshes it in the
  /// background. Returns `Right(null)` when nothing has been cached yet.
  Future<Either<Failure, DashboardReportModel?>> getCachedDashboardReport();

  /// [period] filtre la fenêtre analysée : 'weekly' (7 derniers jours),
  /// 'monthly' (mois calendaire courant, défaut) ou 'yearly' (année
  /// calendaire courante).
  Future<Either<Failure, List<SpendingAnalysisModel>>> getSpendingAnalysis({
    String? period,
  });

  /// Cache local uniquement (pas d'appel réseau) — permet à Insights
  /// d'afficher instantanément la dernière analyse connue pour [period]
  /// pendant que [getSpendingAnalysis] la rafraîchit en arrière-plan.
  Future<Either<Failure, List<SpendingAnalysisModel>?>>
  getCachedSpendingAnalysis(String period);

  /// [period] contrôle le regroupement des points de la courbe : par jour
  /// (weekly), par mois (monthly, défaut) ou par année (yearly).
  Future<Either<Failure, List<SavingsTrendModel>>> getSavingsTrend({
    String? period,
  });
  Future<Either<Failure, List<SavingsTrendModel>?>> getCachedSavingsTrend(
    String period,
  );

  Future<Either<Failure, NarrativeReportModel>> getNarrativeReport();
  Future<Either<Failure, NarrativeReportModel?>> getCachedNarrativeReport();

  /// Prévision de solde à 30 jours (Premium) — voir ForecastService côté
  /// backend, monté sous une route Express distincte (`/forecast`).
  Future<Either<Failure, ForecastReportModel>> getBalanceForecast();
  Future<Either<Failure, ForecastReportModel?>> getCachedBalanceForecast();

  /// Historique du score de santé financière, du plus ancien au plus récent.
  Future<Either<Failure, List<HealthScorePointModel>>> getHealthScoreHistory({
    int months = 6,
  });
  Future<Either<Failure, List<HealthScorePointModel>?>>
  getCachedHealthScoreHistory();
}
