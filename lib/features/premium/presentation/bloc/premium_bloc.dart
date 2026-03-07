import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/premium_repository.dart';
import 'premium_event.dart';
import 'premium_state.dart';

@injectable
class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final PremiumRepository _repository;

  PremiumBloc(this._repository) : super(const PremiumState()) {
    on<PremiumCoachAskRequested>(_onCoachAskRequested);
    on<PremiumAutoBudgetRequested>(_onAutoBudgetRequested);
    on<PremiumReportRequested>(_onReportRequested);
  }

  Future<void> _onCoachAskRequested(
    PremiumCoachAskRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(status: PremiumStatus.loading));
    final result = await _repository.askCoach(event.message);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PremiumStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(status: PremiumStatus.success, coachResponse: response),
      ),
    );
  }

  Future<void> _onAutoBudgetRequested(
    PremiumAutoBudgetRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(status: PremiumStatus.loading));
    final result = await _repository.getAutoBudget();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PremiumStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budget) => emit(
        state.copyWith(status: PremiumStatus.success, autoBudget: budget),
      ),
    );
  }

  Future<void> _onReportRequested(
    PremiumReportRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(status: PremiumStatus.loading));
    final result = await _repository.getPremiumReport();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PremiumStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (report) => emit(
        state.copyWith(status: PremiumStatus.success, premiumReport: report),
      ),
    );
  }
}
