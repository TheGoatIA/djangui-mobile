import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/budget_model.dart';
import '../../domain/repositories/budget_repository.dart';
import 'budgets_event.dart';
import 'budgets_state.dart';

import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

@injectable
class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final BudgetRepository _budgetRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();

  BudgetsBloc(this._budgetRepository) : super(BudgetsState.initial()) {
    on<GetBudgetsRequested>(_onGetBudgetsRequested);
    on<AddBudgetRequested>(_onAddBudgetRequested);
    on<DeleteBudgetRequested>(_onDeleteBudgetRequested);
    on<UpdateBudgetRequested>(_onUpdateBudgetRequested);
    on<GenerateAutoBudgetRequested>(_onGenerateAutoBudgetRequested);
    on<ClearAutoBudgetResponse>(_onClearAutoBudgetResponse);
    on<ResetBudgetsStatus>(_onResetBudgetsStatus);
  }

  void _onResetBudgetsStatus(
    ResetBudgetsStatus event,
    Emitter<BudgetsState> emit,
  ) {
    emit(state.copyWith(status: BudgetsStatus.initial));
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
    _logger.info(
      'Demande de génération automatique de budget...',
      component: 'BudgetsBloc',
      metadata: {'month': event.month, 'year': event.year},
    );
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
      (failure) {
        _logger.error(
          'Échec de la génération automatique de budget',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            status: BudgetsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        _logger.info(
          'Génération automatique réussie.',
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            status: BudgetsStatus.success,
            autoBudgetResponse: () => response,
          ),
        );
      },
    );
  }

  Future<void> _onGetBudgetsRequested(
    GetBudgetsRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    _logger.info(
      'Récupération de la liste des budgets...',
      component: 'BudgetsBloc',
    );
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.getBudgets(
      forceRefresh: event.forceRefresh,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération des budgets',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            status: BudgetsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (budgets) {
        _logger.info(
          '${budgets.length} budgets récupérés.',
          component: 'BudgetsBloc',
        );
        emit(state.copyWith(status: BudgetsStatus.success, budgets: budgets));
      },
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
      _logger.info(
        'Tentative de création d\'un budget...',
        component: 'BudgetsBloc',
        metadata: {
          'month': event.budget.period.month,
          'year': event.budget.period.year,
          'amount': event.budget.totalAllocated,
        },
      );
      emit(state.copyWith(status: BudgetsStatus.loading));
      final result = await _budgetRepository.createBudget(event.budget);
      result.fold<void>(
        (failure) {
          _logger.warning(
            'Échec de la création du budget',
            component: 'BudgetsBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: BudgetsStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (budget) {
          _logger.info(
            'Budget créé avec succès.',
            component: 'BudgetsBloc',
            metadata: {'id': budget.id},
          );
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
    _logger.info(
      'Suppression du budget: ${event.id}',
      component: 'BudgetsBloc',
    );
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.deleteBudget(event.id);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la suppression du budget',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            status: BudgetsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info('Budget supprimé avec succès.', component: 'BudgetsBloc');
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
    _logger.info(
      'Mise à jour du budget: ${event.budget.id}',
      component: 'BudgetsBloc',
    );
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.updateBudget(event.budget);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la mise à jour du budget',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            status: BudgetsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedBudget) {
        _logger.info(
          'Budget mis à jour avec succès.',
          component: 'BudgetsBloc',
        );
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
