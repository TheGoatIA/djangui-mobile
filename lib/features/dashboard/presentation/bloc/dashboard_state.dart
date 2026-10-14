part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardReportModel? report;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.report,
    this.errorMessage,
  });

  factory DashboardState.initial() => const DashboardState();

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardReportModel? report,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      report: report ?? this.report,
      // Deliberately not `errorMessage ?? this.errorMessage` — that made a
      // stale error re-surface on every later emit that didn't bother to
      // explicitly re-state it, including successful ones (same bug fixed in
      // TontineState.copyWith).
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, report, errorMessage];
}
