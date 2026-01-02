import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/budget_model.dart';
import '../../domain/repositories/budget_repository.dart';
import 'budgets_event.dart';
import 'budgets_state.dart';

@injectable
class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final BudgetRepository _budgetRepository;

  BudgetsBloc(this._budgetRepository) : super(BudgetsState.initial()) {
    on<GetBudgetsRequested>(_onGetBudgetsRequested);
    on<AddBudgetRequested>(_onAddBudgetRequested);
    on<DeleteBudgetRequested>(_onDeleteBudgetRequested);
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
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.createBudget(event.budget);
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: BudgetsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budget) {
        final List<BudgetModel> updatedList = List.from(state.budgets)
          ..add(budget);
        emit(
          state.copyWith(status: BudgetsStatus.success, budgets: updatedList),
        );
      },
    );
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
}
