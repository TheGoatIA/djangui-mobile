import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/tontine_repository.dart';
import 'tontine_event.dart';
import 'tontine_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class TontineBloc extends Bloc<TontineEvent, TontineState> {
  final TontineRepository _repository;

  TontineBloc(this._repository) : super(const TontineState()) {
    on<TontinesLoadRequested>(_onTontinesLoadRequested);
    on<TontineDetailsLoadRequested>(_onTontineDetailsLoadRequested);
    on<CreateTontineRequested>(_onCreateTontineRequested);
    on<JoinTontineRequested>(_onJoinTontineRequested);
    on<ContributeToTontineRequested>(_onContributeToTontineRequested);
    on<TontineMessagesLoadRequested>(_onTontineMessagesLoadRequested);
    on<SendTontineMessageRequested>(_onSendTontineMessageRequested);
    on<TontineContributionsLoadRequested>(_onTontineContributionsLoadRequested);
    on<ValidateTontineContributionRequested>(
      _onValidateTontineContributionRequested,
    );
    on<StartTontineRequested>(_onStartTontineRequested);
    on<TontineRemoveMemberRequested>(_onTontineRemoveMemberRequested);
    on<DeleteTontineRequested>(_onDeleteTontineRequested);
    on<UpdateTontineRequested>(_onUpdateTontineRequested);
  }

  Future<void> _onTontinesLoadRequested(
    TontinesLoadRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.getTontines();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (tontines) => emit(
        state.copyWith(status: TontineStatus.success, tontines: tontines),
      ),
    );
  }

  Future<void> _onTontineDetailsLoadRequested(
    TontineDetailsLoadRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final detailsResult = await _repository.getTontineDetails(event.tontineId);
    final membersResult = await _repository.getTontineMembers(event.tontineId);

    detailsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (tontine) {
        membersResult.fold(
          (failure) => emit(
            state.copyWith(
              status: TontineStatus.success,
              selectedTontine: tontine,
              errorMessage: failure.message,
            ),
          ),
          (members) => emit(
            state.copyWith(
              status: TontineStatus.success,
              selectedTontine: tontine,
              selectedTontineMembers: members,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onCreateTontineRequested(
    CreateTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.createTontine(event.params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (tontine) => emit(
        state.copyWith(
          status: TontineStatus.success,
          tontines: [...state.tontines, tontine],
        ),
      ),
    );
  }

  Future<void> _onJoinTontineRequested(
    JoinTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.joinTontine(
      event.inviteCode,
      displayName: event.displayName,
      parts: event.parts,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (tontine) => emit(
        state.copyWith(
          status: TontineStatus.success,
          tontines: [...state.tontines, tontine],
        ),
      ),
    );
  }

  Future<void> _onStartTontineRequested(
    StartTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.startTontine(event.tontineId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (tontine) {
        emit(
          state.copyWith(
            status: TontineStatus.success,
            selectedTontine: tontine,
            tontines: state.tontines
                .map((t) => t.id == tontine.id ? tontine : t)
                .toList(),
          ),
        );
      },
    );
  }

  Future<void> _onContributeToTontineRequested(
    ContributeToTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.contribute(
      event.tontineId,
      event.proofImage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(TontineDetailsLoadRequested(event.tontineId)),
    );
  }

  Future<void> _onTontineMessagesLoadRequested(
    TontineMessagesLoadRequested event,
    Emitter<TontineState> emit,
  ) async {
    final result = await _repository.getTontineMessages(event.tontineId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (messages) => emit(state.copyWith(selectedTontineMessages: messages)),
    );
  }

  Future<void> _onSendTontineMessageRequested(
    SendTontineMessageRequested event,
    Emitter<TontineState> emit,
  ) async {
    final result = await _repository.sendMessage(
      event.tontineId,
      event.content,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (message) => emit(
        state.copyWith(
          selectedTontineMessages: [...state.selectedTontineMessages, message],
        ),
      ),
    );
  }

  Future<void> _onTontineContributionsLoadRequested(
    TontineContributionsLoadRequested event,
    Emitter<TontineState> emit,
  ) async {
    final result = await _repository.getContributions(event.tontineId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (contributions) =>
          emit(state.copyWith(selectedTontineContributions: contributions)),
    );
  }

  Future<void> _onValidateTontineContributionRequested(
    ValidateTontineContributionRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.validateContribution(
      event.contributionId,
      event.status,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (contribution) {
        final updatedContributions = state.selectedTontineContributions.map((
          c,
        ) {
          return c.id == contribution.id ? contribution : c;
        }).toList();
        emit(
          state.copyWith(
            status: TontineStatus.success,
            selectedTontineContributions: updatedContributions,
          ),
        );
        if (state.selectedTontine != null) {
          add(TontineDetailsLoadRequested(state.selectedTontine!.id));
        }
      },
    );
  }

  Future<void> _onTontineRemoveMemberRequested(
    TontineRemoveMemberRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.removeMember(
      event.tontineId,
      event.memberId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Just reload members if successful
        add(TontineDetailsLoadRequested(event.tontineId));
      },
    );
  }

  Future<void> _onDeleteTontineRequested(
    DeleteTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.deleteTontine(event.tontineId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            status: TontineStatus.success,
            tontines: state.tontines
                .where((t) => t.id != event.tontineId)
                .toList(),
            selectedTontine: null,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTontineRequested(
    UpdateTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.updateTontine(
      event.tontineId,
      event.params,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (updatedTontine) {
        final updatedTontines = state.tontines.map((t) {
          return t.id == updatedTontine.id ? updatedTontine : t;
        }).toList();
        emit(
          state.copyWith(
            status: TontineStatus.success,
            tontines: updatedTontines,
            selectedTontine: updatedTontine,
          ),
        );
      },
    );
  }
}
