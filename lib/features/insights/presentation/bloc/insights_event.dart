import 'package:equatable/equatable.dart';

abstract class InsightsEvent extends Equatable {
  const InsightsEvent();

  @override
  List<Object?> get props => [];
}

class GetInsightsRequested extends InsightsEvent {
  final String period;

  const GetInsightsRequested({this.period = 'monthly'});

  @override
  List<Object?> get props => [period];
}
