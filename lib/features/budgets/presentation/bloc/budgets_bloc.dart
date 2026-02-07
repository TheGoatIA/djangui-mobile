import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/budget_model.dart';
import '../../domain/repositories/budget_repository.dart';
import 'budgets_event.dart';
import 'budgets_state.dart';

import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

@injectable
class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final BudgetRepository _budgetRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();

  BudgetsBloc(this._budgetRepository) : super(BudgetsState.initial()) {
    on<GetBudgetsRequested>(_onGetBudgetsRequested);
    on<AddBudgetRequested>(_onAddBudgetRequested);
    on<DeleteBudgetRequested>(_onDeleteBudgetRequested);
    on<UpdateBudgetRequested>(_onUpdateBudgetRequested);
    on<GenerateAutoBudgetRequested>(_onGenerateAutoBudgetRequested);
    on<ClearAutoBudgetResponse>(_onClearAutoBudgetResponse);
  }

  void _onClearAutoBudgetResponse(
    ClearAutoBudgetResponse event,
    Emitter<BudgetsState> emit,
  ) {
    emit(state.copyWith(autoBudgetResponse: () => null));
  }

  Future<void> _onGenerateAutoBudgetRequested(
    GenerateAutoBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BudgetsStatus.loading,
        autoBudgetResponse: () => null,
        errorMessage: null,
      ),
    );
    final result = await _budgetRepository.generateAutoBudget(
      month: event.month,
      year: event.year,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: BudgetsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: BudgetsStatus.success,
          autoBudgetResponse: () => response,
        ),
      ),
    );
  }

  Future<void> _onGetBudgetsRequested(
    GetBudgetsRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.getBudgets(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: BudgetsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budgets) =>
          emit(state.copyWith(status: BudgetsStatus.success, budgets: budgets)),
    );
  }

  Future<void> _onAddBudgetRequested(
    AddBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Budget: Create',
      kind: SpanKind.internal,
    );
    span.setAttribute(
      Attribute.fromString(
        'budget.total_allocated',
        event.budget.totalAllocated.toString(),
      ),
    );
    span.setAttribute(
      Attribute.fromString(
        'budget.amount',
        event.budget.totalAllocated.toString(),
      ),
    );

    try {
      emit(state.copyWith(status: BudgetsStatus.loading));
      final result = await _budgetRepository.createBudget(event.budget);
      result.fold<void>(
        (failure) {
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: BudgetsStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (budget) {
          span.setAttribute(Attribute.fromString('budget.id', budget.id));
          final List<BudgetModel> updatedList = List.from(state.budgets)
            ..add(budget);
          emit(
            state.copyWith(status: BudgetsStatus.success, budgets: updatedList),
          );
        },
      );
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onDeleteBudgetRequested(
    DeleteBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.deleteBudget(event.id);
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: BudgetsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final List<BudgetModel> updatedList = state.budgets
            .where((b) => b.id != event.id)
            .toList();
        emit(
          state.copyWith(status: BudgetsStatus.success, budgets: updatedList),
        );
      },
    );
  }

  Future<void> _onUpdateBudgetRequested(
    UpdateBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.updateBudget(event.budget);
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: BudgetsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (updatedBudget) {
        final List<BudgetModel> updatedList = state.budgets.map((b) {
          return b.id == event.budget.id ? updatedBudget : b;
        }).toList();
        emit(
          state.copyWith(status: BudgetsStatus.success, budgets: updatedList),
        );
      },
    );
  }
}
