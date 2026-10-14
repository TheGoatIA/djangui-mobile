part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetDashboardDataRequested extends DashboardEvent {}

class ResetDashboardRequested extends DashboardEvent {
  const ResetDashboardRequested();
}
