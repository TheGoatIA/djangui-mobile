part of 'investments_bloc.dart';

enum InvestmentsStatus { initial, loading, loaded, error }

class InvestmentsState extends Equatable {
  final InvestmentsStatus status;
  final List<InvestmentModel> investments;
  final String? errorMessage;

  const InvestmentsState({
    required this.status,
    required this.investments,
    this.errorMessage,
  });

  factory InvestmentsState.initial() {
    return const InvestmentsState(
      status: InvestmentsStatus.initial,
      investments: [],
    );
  }

  InvestmentsState copyWith({
    InvestmentsStatus? status,
    List<InvestmentModel>? investments,
    String? errorMessage,
  }) {
    return InvestmentsState(
      status: status ?? this.status,
      investments: investments ?? this.investments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, investments, errorMessage];
}
