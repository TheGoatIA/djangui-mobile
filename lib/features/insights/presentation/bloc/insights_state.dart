import 'package:equatable/equatable.dart';
import '../../data/models/insight_model.dart';
import '../../../reports/data/models/reports_model.dart';

enum InsightsStatus { initial, loading, success, error }

class InsightsState extends Equatable {
  final InsightsStatus status;
  final List<CategoryDistributionModel> distribution;
  final List<SavingsTrendModel> trends;
  final NarrativeReportModel? narrative;
  final String? errorMessage;
  final String period;

  const InsightsState({
    this.status = InsightsStatus.initial,
    this.distribution = const [],
    this.trends = const [],
    this.narrative,
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
  }) {
    return InsightsState(
      status: status ?? this.status,
      distribution: distribution ?? this.distribution,
      trends: trends ?? this.trends,
      narrative: narrative ?? this.narrative,
      errorMessage: errorMessage ?? this.errorMessage,
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [
    status,
    distribution,
    trends,
    narrative,
    errorMessage,
    period,
  ];
}
