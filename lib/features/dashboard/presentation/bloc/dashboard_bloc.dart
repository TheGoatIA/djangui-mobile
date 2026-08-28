import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../reports/data/models/reports_model.dart';
import '../../../reports/domain/repositories/reports_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@lazySingleton
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ReportsRepository _reportsRepository;

  DashboardBloc(this._reportsRepository) : super(DashboardState.initial()) {
    on<GetDashboardDataRequested>(_onGetDashboardDataRequested);
    on<ResetDashboardRequested>(_onResetDashboardRequested);
  }

  void _onResetDashboardRequested(
    ResetDashboardRequested event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardState.initial());
  }

  Future<void> _onGetDashboardDataRequested(
    GetDashboardDataRequested event,
    Emitter<DashboardState> emit,
  ) async {
    // Paint the dashboard from the local cache immediately — getDashboardReport()
    // below always waits for the network when online, so without this every
    // open sat on stale "0" placeholder figures (report defaults to null)
    // until the network call resolved, even though a perfectly good cached
    // report was sitting on disk. The network call below still runs and
    // replaces this with the authoritative report once it resolves.
    final cachedResult = await _reportsRepository.getCachedDashboardReport();
    cachedResult.fold((_) {}, (cached) {
      if (cached != null) {
        emit(state.copyWith(status: DashboardStatus.loading, report: cached));
      } else {
        emit(state.copyWith(status: DashboardStatus.loading));
      }
    });
    final result = await _reportsRepository.getDashboardReport();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (report) =>
          emit(state.copyWith(status: DashboardStatus.success, report: report)),
    );
  }
}
