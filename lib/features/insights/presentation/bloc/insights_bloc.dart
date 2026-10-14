import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../reports/domain/repositories/reports_repository.dart';
import '../../../reports/data/models/reports_model.dart';
import '../../data/models/insight_model.dart';
import 'insights_event.dart';
import 'insights_state.dart';

@injectable
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final ReportsRepository _reportsRepository;

  InsightsBloc(this._reportsRepository) : super(InsightsState.initial()) {
    on<GetInsightsRequested>(_onGetInsightsRequested);
  }

  Future<void> _onGetInsightsRequested(
    GetInsightsRequested event,
    Emitter<InsightsState> emit,
  ) async {
    // Peint instantanément avec la dernière analyse connue pour cette période
    // (cache local) pendant que le réseau rafraîchit en arrière-plan — évite
    // l'écran vide/spinner à chaque changement de période si déjà visité.
    final cachedAnalysis = await _reportsRepository.getCachedSpendingAnalysis(
      event.period,
    );
    final cachedTrends = await _reportsRepository.getCachedSavingsTrend(
      event.period,
    );
    final cachedNarrative = await _reportsRepository.getCachedNarrativeReport();
    final cachedForecast = await _reportsRepository.getCachedBalanceForecast();
    final cachedHealthHistory = await _reportsRepository
        .getCachedHealthScoreHistory();

    var seeded = state.copyWith(
      status: InsightsStatus.loading,
      period: event.period,
      errorMessage: null,
    );
    cachedAnalysis.fold((_) {}, (cached) {
      if (cached != null) {
        seeded = seeded.copyWith(
          distribution: _toDistribution(cached),
        );
      }
    });
    cachedTrends.fold((_) {}, (cached) {
      if (cached != null) seeded = seeded.copyWith(trends: cached);
    });
    cachedNarrative.fold((_) {}, (cached) {
      if (cached != null) seeded = seeded.copyWith(narrative: cached);
    });
    cachedForecast.fold((_) {}, (cached) {
      if (cached != null) seeded = seeded.copyWith(forecast: cached);
    });
    cachedHealthHistory.fold((_) {}, (cached) {
      if (cached != null) seeded = seeded.copyWith(healthScoreHistory: cached);
    });
    emit(seeded);

    // Fetch spending analysis, trends, narrative, forecast, and health score
    // history in parallel. The AI narrative, forecast, and health history
    // all stay month-focused / Premium-only regardless of the selector —
    // only the chart data actually respects the weekly/monthly/yearly choice.
    final results = await Future.wait([
      _reportsRepository.getSpendingAnalysis(period: event.period),
      _reportsRepository.getSavingsTrend(period: event.period),
      _reportsRepository.getNarrativeReport(),
      _reportsRepository.getBalanceForecast(),
      _reportsRepository.getHealthScoreHistory(),
    ]);

    final analysisResult =
        results[0] as Either<Failure, List<SpendingAnalysisModel>>;
    final trendsResult = results[1] as Either<Failure, List<SavingsTrendModel>>;
    final narrativeResult = results[2] as Either<Failure, NarrativeReportModel>;
    final forecastResult = results[3] as Either<Failure, ForecastReportModel>;
    final healthHistoryResult =
        results[4] as Either<Failure, List<HealthScorePointModel>>;

    analysisResult.fold(
      (failure) {
        // Le réseau a échoué ET aucun cache n'a pu servir de secours (sinon
        // le repository l'aurait déjà renvoyé en `Right`) : on le signale
        // explicitement au lieu de laisser les graphiques vides sans
        // explication. Les données déjà à l'écran (issues du cache ci-dessus,
        // s'il y en avait) restent affichées.
        emit(
          state.copyWith(
            status: InsightsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (analysisData) {
        final distributionList = _toDistribution(analysisData);

        var finalState = state.copyWith(
          status: InsightsStatus.success,
          distribution: distributionList,
          errorMessage: null,
        );

        // Feed trends into state
        finalState = trendsResult.fold(
          (failure) => finalState.copyWith(errorMessage: failure.message),
          (trends) => finalState.copyWith(trends: trends),
        );

        // Feed the narrative into the state if successful
        finalState = narrativeResult.fold(
          (failure) => finalState.copyWith(errorMessage: failure.message),
          (narrative) => finalState.copyWith(narrative: narrative),
        );

        // Feed the forecast into the state if successful (Premium — a 403
        // for free users is expected and silently ignored here, same as the
        // narrative above: the UI only renders this section for Premium).
        finalState = forecastResult.fold(
          (failure) => finalState,
          (forecast) => finalState.copyWith(forecast: forecast),
        );

        // Feed the health score history into the state if successful.
        finalState = healthHistoryResult.fold(
          (failure) => finalState,
          (history) => finalState.copyWith(healthScoreHistory: history),
        );

        emit(finalState);
      },
    );
  }

  List<CategoryDistributionModel> _toDistribution(
    List<SpendingAnalysisModel> analysisData,
  ) {
    final totalAmount = analysisData.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    return analysisData.map((e) {
      final percentage = totalAmount > 0
          ? (e.amount / totalAmount) * 100
          : 0.0;
      return CategoryDistributionModel(
        category: e.category,
        amount: e.amount,
        percentage: percentage,
        color: _getCategoryColor(e.category),
      );
    }).toList();
  }

  String _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      // Use existing colors or hex strings
      case 'alimentation':
      case 'nourriture':
      case 'repas':
        return '#FF5722'; // Deep Orange
      case 'transport':
        return '#2196F3'; // Blue
      case 'logement':
      case 'loyer':
        return '#9C27B0'; // Purple
      case 'santé':
      case 'sante':
        return '#E91E63'; // Pink
      case 'loisirs':
      case 'divertissement':
        return '#FFC107'; // Amber
      case 'education':
      case 'éducation':
        return '#4CAF50'; // Green
      case 'shopping':
      case 'achats':
        return '#795548'; // Brown
      case 'services':
      case 'factures':
        return '#607D8B'; // Blue Grey
      // Catégories issues des flux d'argent transverses (tontines, objectifs,
      // défis, investissements) — voir ReportService.CATEGORY_LABELS côté
      // backend pour la correspondance avec les catégories internes brutes.
      case 'cotisations tontines':
        return '#3F51B5'; // Indigo
      case 'fonds social tontines':
        return '#009688'; // Teal
      case 'pénalités absence tontines':
        return '#D32F2F'; // Rouge
      case 'cagnottes tontines reçues':
        return '#8BC34A'; // Vert clair
      case 'retraits':
        return '#455A64'; // Blue Grey foncé
      case 'dépôts':
        return '#4CAF50'; // Vert
      case 'récompenses défis':
        return '#FFB300'; // Ambre foncé
      case "objectifs d'épargne":
        return '#00BCD4'; // Cyan
      case 'mises défis':
        return '#673AB7'; // Violet
      case 'investissements':
        return '#00796B'; // Teal foncé
      case "clôtures d'investissement":
        return '#26A69A'; // Teal clair
      case 'épargne':
        return '#78909C'; // Blue Grey clair
      default:
        return '#9E9E9E'; // Grey
    }
  }
}
