import 'package:equatable/equatable.dart';

enum PremiumStatus { initial, loading, success, error }

class PremiumState extends Equatable {
  final PremiumStatus status;
  final Map<String, dynamic>? coachResponse;
  final Map<String, dynamic>? autoBudget;
  final Map<String, dynamic>? premiumReport;
  final String? errorMessage;

  const PremiumState({
    this.status = PremiumStatus.initial,
    this.coachResponse,
    this.autoBudget,
    this.premiumReport,
    this.errorMessage,
  });

  PremiumState copyWith({
    PremiumStatus? status,
    Map<String, dynamic>? coachResponse,
    Map<String, dynamic>? autoBudget,
    Map<String, dynamic>? premiumReport,
    String? errorMessage,
  }) {
    return PremiumState(
      status: status ?? this.status,
      coachResponse: coachResponse ?? this.coachResponse,
      autoBudget: autoBudget ?? this.autoBudget,
      premiumReport: premiumReport ?? this.premiumReport,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    coachResponse,
    autoBudget,
    premiumReport,
    errorMessage,
  ];
}
