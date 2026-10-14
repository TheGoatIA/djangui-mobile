import 'package:bloc_concurrency/bloc_concurrency.dart';
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

@lazySingleton
class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final BudgetRepository _budgetRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();

  BudgetsBloc(this._budgetRepository) : super(BudgetsState.initial()) {
    on<GetBudgetsRequested>(_onGetBudgetsRequested);
    on<AddBudgetRequested>(_onAddBudgetRequested, transformer: droppable());
    on<DeleteBudgetRequested>(_onDeleteBudgetRequested, transformer: droppable());
    on<UpdateBudgetRequested>(_onUpdateBudgetRequested, transformer: droppable());
    on<GenerateAutoBudgetRequested>(
      _onGenerateAutoBudgetRequested,
      transformer: droppable(),
    );
    on<ClearAutoBudgetResponse>(_onClearAutoBudgetResponse);
    on<ResetBudgetsStatus>(_onResetBudgetsStatus);
    on<GetCategoryHistoryRequested>(_onGetCategoryHistoryRequested);
    on<ShareBudgetRequested>(_onShareBudgetRequested, transformer: droppable());
    on<JoinBudgetRequested>(_onJoinBudgetRequested, transformer: droppable());
    on<GetBudgetParticipantsRequested>(_onGetBudgetParticipantsRequested);
    on<RemoveBudgetParticipantRequested>(_onRemoveBudgetParticipantRequested);
    on<LeaveBudgetRequested>(_onLeaveBudgetRequested, transformer: droppable());
  }

  void _onResetBudgetsStatus(
    ResetBudgetsStatus event,
    Emitter<BudgetsState> emit,
  ) {
    emit(BudgetsState.initial());
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
          // Resynchronise avec le serveur en arrière-plan : la page qui a
          // déclenché cette création peut avoir été atteinte par un `pop()`
          // jamais attendu ailleurs (ex. depuis la fiche détail d'un
          // budget), donc rien ne garantissait qu'un rechargement de la
          // liste soit déclenché au retour. Sans danger d'affichage : la
          // liste contient déjà des données (celles ci-dessus), donc pas de
          // spinner plein écran pendant ce rafraîchissement silencieux.
          add(const GetBudgetsRequested(forceRefresh: true));
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
        add(const GetBudgetsRequested(forceRefresh: true));
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
        // Toujours resynchroniser avec le serveur après une modification :
        // 1) certains chemins de navigation (ex. "Modifier" depuis la fiche
        //    détail d'un budget) poussent la page d'édition sans jamais
        //    attendre son résultat, donc rien ne déclenchait de rechargement
        //    de la liste au retour ; 2) si `state.budgets` était déjà vide
        //    (quelle qu'en soit la raison) au moment de cette mise à jour, le
        //    `.map()` ci-dessus ne peut rien "mettre à jour" et produit une
        //    liste toujours vide — seul un vrai rechargement peut corriger
        //    cet état.
        add(const GetBudgetsRequested(forceRefresh: true));
      },
    );
  }

  Future<void> _onGetCategoryHistoryRequested(
    GetCategoryHistoryRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(categoryHistoryStatus: BudgetSideStatus.loading));
    final result = await _budgetRepository.getCategoryHistory(
      event.category,
      months: event.monthsBack,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          "Échec de la récupération de l'historique",
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            categoryHistoryStatus: BudgetSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (history) => emit(
        state.copyWith(
          categoryHistoryStatus: BudgetSideStatus.success,
          categoryHistory: history,
        ),
      ),
    );
  }

  Future<void> _onShareBudgetRequested(
    ShareBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(
      state.copyWith(
        shareStatus: BudgetSideStatus.loading,
        shareInviteCode: () => null,
      ),
    );
    final result = await _budgetRepository.shareBudget(event.budgetId);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec du partage du budget',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            shareStatus: BudgetSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (inviteCode) => emit(
        state.copyWith(
          shareStatus: BudgetSideStatus.success,
          shareInviteCode: () => inviteCode,
          budgets: state.budgets
              .map(
                (b) => b.id == event.budgetId
                    ? b.copyWith(isShared: true, inviteCode: inviteCode)
                    : b,
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _onJoinBudgetRequested(
    JoinBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.joinBudget(event.inviteCode);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec pour rejoindre le budget',
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
      (budget) {
        final updatedList = List<BudgetModel>.from(state.budgets)..add(budget);
        emit(
          state.copyWith(status: BudgetsStatus.success, budgets: updatedList),
        );
      },
    );
  }

  Future<void> _onGetBudgetParticipantsRequested(
    GetBudgetParticipantsRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(participantsStatus: BudgetSideStatus.loading));
    final result = await _budgetRepository.getParticipants(event.budgetId);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec de la récupération des participants',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            participantsStatus: BudgetSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (participants) => emit(
        state.copyWith(
          participantsStatus: BudgetSideStatus.success,
          participants: participants,
        ),
      ),
    );
  }

  Future<void> _onRemoveBudgetParticipantRequested(
    RemoveBudgetParticipantRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    final result = await _budgetRepository.removeParticipant(
      event.budgetId,
      event.participantId,
    );
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec du retrait du participant',
          error: failure.message,
          component: 'BudgetsBloc',
        );
        emit(
          state.copyWith(
            participantsStatus: BudgetSideStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) => emit(
        state.copyWith(
          participants: state.participants
              .where((p) => p.id != event.participantId)
              .toList(),
        ),
      ),
    );
  }

  Future<void> _onLeaveBudgetRequested(
    LeaveBudgetRequested event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetsStatus.loading));
    final result = await _budgetRepository.leaveBudget(event.budgetId);
    result.fold<void>(
      (failure) {
        _logger.error(
          'Échec pour quitter le budget',
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
        final updatedList = state.budgets
            .where((b) => b.id != event.budgetId)
            .toList();
        emit(
          state.copyWith(status: BudgetsStatus.success, budgets: updatedList),
        );
      },
    );
  }
}
