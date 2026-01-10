import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../reports/data/models/reports_model.dart';
import '../../../reports/domain/repositories/reports_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ReportsRepository _reportsRepository;

  DashboardBloc(this._reportsRepository) : super(DashboardState.initial()) {
    on<GetDashboardDataRequested>(_onGetDashboardDataRequested);
  }

  Future<void> _onGetDashboardDataRequested(
    GetDashboardDataRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
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
