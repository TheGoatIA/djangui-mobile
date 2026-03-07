import 'package:equatable/equatable.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

class PremiumCoachAskRequested extends PremiumEvent {
  final String message;
  const PremiumCoachAskRequested(this.message);

  @override
  List<Object?> get props => [message];
}

class PremiumAutoBudgetRequested extends PremiumEvent {}

class PremiumReportRequested extends PremiumEvent {}
