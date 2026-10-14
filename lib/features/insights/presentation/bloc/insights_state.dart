import 'package:equatable/equatable.dart';
import '../../data/models/insight_model.dart';
import '../../../reports/data/models/reports_model.dart';

enum InsightsStatus { initial, loading, success, error }

class InsightsState extends Equatable {
  final InsightsStatus status;
  final List<CategoryDistributionModel> distribution;
  final List<SavingsTrendModel> trends;
  final NarrativeReportModel? narrative;
  final ForecastReportModel? forecast;
  final List<HealthScorePointModel> healthScoreHistory;
  final String? errorMessage;
  final String period;

  const InsightsState({
    this.status = InsightsStatus.initial,
    this.distribution = const [],
    this.trends = const [],
    this.narrative,
    this.forecast,
    this.healthScoreHistory = const [],
    this.errorMessage,
    this.period = 'monthly',
  });

  factory InsightsState.initial() => const InsightsState();

  InsightsState copyWith({
    InsightsStatus? status,
    List<CategoryDistributionModel>? distribution,
    List<SavingsTrendModel>? trends,
    String? errorMessage,
    String? period,
    NarrativeReportModel? narrative,
    ForecastReportModel? forecast,
    List<HealthScorePointModel>? healthScoreHistory,
  }) {
    return InsightsState(
      status: status ?? this.status,
      distribution: distribution ?? this.distribution,
      trends: trends ?? this.trends,
      narrative: narrative ?? this.narrative,
      forecast: forecast ?? this.forecast,
      healthScoreHistory: healthScoreHistory ?? this.healthScoreHistory,
      // Volontairement PAS `errorMessage ?? this.errorMessage` : un échec est
      // un signal ponctuel pour le fetch qui vient de se terminer, pas un
      // état persistant — sinon une erreur passée reste accrochée à tout
      // rechargement réussi ultérieur (jamais remise à null explicitement).
      errorMessage: errorMessage,
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [
    status,
    distribution,
    trends,
    narrative,
    forecast,
    healthScoreHistory,
    errorMessage,
    period,
  ];
}
