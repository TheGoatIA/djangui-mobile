import 'package:equatable/equatable.dart';
import '../../data/models/insight_model.dart';

enum InsightsStatus { initial, loading, success, error }

class InsightsState extends Equatable {
  final InsightsStatus status;
  final List<CategoryDistributionModel> distribution;
  final List<SpendingTrendModel> trends;
  final String? errorMessage;
  final String period;

  const InsightsState({
    this.status = InsightsStatus.initial,
    this.distribution = const [],
    this.trends = const [],
    this.errorMessage,
    this.period = 'monthly',
  });

  factory InsightsState.initial() => const InsightsState();

  InsightsState copyWith({
    InsightsStatus? status,
    List<CategoryDistributionModel>? distribution,
    List<SpendingTrendModel>? trends,
    String? errorMessage,
    String? period,
  }) {
    return InsightsState(
      status: status ?? this.status,
      distribution: distribution ?? this.distribution,
      trends: trends ?? this.trends,
      errorMessage: errorMessage ?? this.errorMessage,
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [
    status,
    distribution,
    trends,
    errorMessage,
    period,
  ];
}
