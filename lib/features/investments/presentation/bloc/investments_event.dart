part of 'investments_bloc.dart';

abstract class InvestmentsEvent extends Equatable {
  const InvestmentsEvent();

  @override
  List<Object> get props => [];
}

class LoadInvestments extends InvestmentsEvent {
  const LoadInvestments();
}

class AddInvestment extends InvestmentsEvent {
  final InvestmentModel investment;

  const AddInvestment(this.investment);

  @override
  List<Object> get props => [investment];
}

class DeleteInvestment extends InvestmentsEvent {
  final String id;

  const DeleteInvestment(this.id);

  @override
  List<Object> get props => [id];
}
