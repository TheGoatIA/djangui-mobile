import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/tontine_repository.dart';
import 'tontine_event.dart';
import 'tontine_state.dart';
import '../../domain/entities/tontine_entities.dart';

import 'package:injectable/injectable.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

@injectable
class TontineBloc extends Bloc<TontineEvent, TontineState> {
  final TontineRepository _repository;
  TelemetryService get _telemetry => getIt<TelemetryService>();
  LogService get _logger => getIt<LogService>();

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
    on<RotateTurnRequested>(_onRotateTurnRequested);
    on<ToggleAutoDebitRequested>(_onToggleAutoDebitRequested);
  }

  Future<void> _onTontinesLoadRequested(
    TontinesLoadRequested event,
    Emitter<TontineState> emit,
  ) async {
    _logger.info(
      'Récupération de la liste des tontines...',
      component: 'TontineBloc',
    );
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.getTontines();
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la récupération des tontines',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (tontines) {
        _logger.info(
          '${tontines.length} tontines récupérées.',
          component: 'TontineBloc',
        );
        emit(state.copyWith(status: TontineStatus.success, tontines: tontines));
      },
    );
  }

  Future<void> _onTontineDetailsLoadRequested(
    TontineDetailsLoadRequested event,
    Emitter<TontineState> emit,
  ) async {
    _logger.info(
      'Récupération des détails de la tontine: ${event.tontineId}',
      component: 'TontineBloc',
    );
    emit(state.copyWith(status: TontineStatus.loading));
    final detailsResult = await _repository.getTontineDetails(event.tontineId);
    final membersResult = await _repository.getTontineMembers(event.tontineId);

    detailsResult.fold(
      (failure) {
        _logger.error(
          'Échec de la récupération des détails de la tontine',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (tontine) {
        _logger.info(
          'Détails de la tontine récupérés.',
          component: 'TontineBloc',
        );
        membersResult.fold(
          (failure) {
            _logger.warning(
              'Échec de la récupération des membres de la tontine',
              component: 'TontineBloc',
              metadata: {'error': failure.message},
            );
            emit(
              state.copyWith(
                status: TontineStatus.success,
                selectedTontine: tontine,
                errorMessage: failure.message,
              ),
            );
          },
          (members) {
            _logger.info(
              '${members.length} membres récupérés.',
              component: 'TontineBloc',
            );
            emit(
              state.copyWith(
                status: TontineStatus.success,
                selectedTontine: tontine,
                selectedTontineMembers: members,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onCreateTontineRequested(
    CreateTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Tontine: Create',
      kind: SpanKind.internal,
    );
    span.setAttribute(
      Attribute.fromString(
        'tontine.name',
        event.params['name']?.toString() ?? 'unknown',
      ),
    );

    try {
      _logger.info(
        'Tentative de création d\'une tontine...',
        component: 'TontineBloc',
        metadata: event.params,
      );
      emit(state.copyWith(status: TontineStatus.loading));
      final result = await _repository.createTontine(event.params);
      result.fold(
        (failure) {
          _logger.warning(
            'Échec de la création de la tontine',
            component: 'TontineBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: TontineStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (tontine) {
          _logger.info(
            'Tontine créée avec succès.',
            component: 'TontineBloc',
            metadata: {'id': tontine.id},
          );
          span.setAttribute(Attribute.fromString('tontine.id', tontine.id));
          emit(
            state.copyWith(
              status: TontineStatus.success,
              tontines: [...state.tontines, tontine],
            ),
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

  Future<void> _onJoinTontineRequested(
    JoinTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Tontine: Join',
      kind: SpanKind.internal,
    );
    span.setAttribute(
      Attribute.fromString('tontine.invite_code', event.inviteCode),
    );

    try {
      _logger.info(
        'Tentative de rejoindre une tontine...',
        component: 'TontineBloc',
        metadata: {'invite_code': event.inviteCode},
      );
      emit(state.copyWith(status: TontineStatus.loading));
      final result = await _repository.joinTontine(
        event.inviteCode,
        displayName: event.displayName,
        parts: event.parts,
        payoutDetails: event.payoutDetails,
      );
      result.fold(
        (failure) {
          _logger.warning(
            'Échec pour rejoindre la tontine',
            component: 'TontineBloc',
            metadata: {'error': failure.message},
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: TontineStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (tontine) {
          _logger.info(
            'Tontine rejointe avec succès.',
            component: 'TontineBloc',
            metadata: {'id': tontine.id},
          );
          span.setAttribute(Attribute.fromString('tontine.id', tontine.id));
          emit(
            state.copyWith(
              status: TontineStatus.success,
              tontines: [...state.tontines, tontine],
            ),
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

  Future<void> _onStartTontineRequested(
    StartTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Tontine: Start',
      kind: SpanKind.internal,
    );
    span.setAttribute(Attribute.fromString('tontine.id', event.tontineId));

    try {
      _logger.info(
        'Demarrage de la tontine: ${event.tontineId}',
        component: 'TontineBloc',
      );
      emit(state.copyWith(status: TontineStatus.loading));
      final result = await _repository.startTontine(event.tontineId);
      result.fold(
        (failure) {
          _logger.error(
            'Échec du démarrage de la tontine',
            error: failure.message,
            component: 'TontineBloc',
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: TontineStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (tontine) {
          _logger.info(
            'Tontine démarrée avec succès.',
            component: 'TontineBloc',
          );
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
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
  }

  Future<void> _onContributeToTontineRequested(
    ContributeToTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'Tontine: Contribute',
      kind: SpanKind.internal,
    );
    span.setAttribute(Attribute.fromString('tontine.id', event.tontineId));

    try {
      _logger.info(
        'Envoi d\'une contribution pour la tontine: ${event.tontineId}',
        component: 'TontineBloc',
      );
      emit(state.copyWith(status: TontineStatus.loading));
      final result = await _repository.contribute(
        event.tontineId,
        event.proofImage,
      );
      result.fold(
        (failure) {
          _logger.error(
            'Échec de l\'envoi de la contribution',
            error: failure.message,
            component: 'TontineBloc',
          );
          span.setStatus(StatusCode.error, failure.message);
          emit(
            state.copyWith(
              status: TontineStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (_) {
          _logger.info(
            'Contribution envoyée avec succès.',
            component: 'TontineBloc',
          );
          add(TontineDetailsLoadRequested(event.tontineId));
        },
      );
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      rethrow;
    } finally {
      span.end();
    }
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
      (failure) {
        _logger.error(
          'Échec de la validation de la contribution',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (contribution) {
        _logger.info(
          'Contribution validée avec succès (Status: ${event.status}).',
          component: 'TontineBloc',
        );
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
    _logger.info(
      'Tentative de suppression du membre: ${event.memberId} de la tontine ${event.tontineId}',
      component: 'TontineBloc',
    );
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.removeMember(
      event.tontineId,
      event.memberId,
    );
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la suppression du membre',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info('Membre supprimé avec succès.', component: 'TontineBloc');
        // Just reload members if successful
        add(TontineDetailsLoadRequested(event.tontineId));
      },
    );
  }

  Future<void> _onDeleteTontineRequested(
    DeleteTontineRequested event,
    Emitter<TontineState> emit,
  ) async {
    _logger.info(
      'Suppression de la tontine: ${event.tontineId}',
      component: 'TontineBloc',
    );
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.deleteTontine(event.tontineId);
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la suppression de la tontine',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        _logger.info(
          'Tontine supprimée avec succès.',
          component: 'TontineBloc',
        );
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
    _logger.info(
      'Mise à jour de la tontine: ${event.tontineId}',
      component: 'TontineBloc',
      metadata: event.params,
    );
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.updateTontine(
      event.tontineId,
      event.params,
    );
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la mise à jour de la tontine',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedTontine) {
        _logger.info(
          'Tontine mise à jour avec succès.',
          component: 'TontineBloc',
        );
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

  Future<void> _onRotateTurnRequested(
    RotateTurnRequested event,
    Emitter<TontineState> emit,
  ) async {
    _logger.info(
      'Rotation du tour pour la tontine: ${event.tontineId}',
      component: 'TontineBloc',
    );
    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.rotateTurn(event.tontineId);
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la rotation du tour',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedTontine) {
        _logger.info('Rotation du tour réussie.', component: 'TontineBloc');
        emit(
          state.copyWith(
            status: TontineStatus.success,
            selectedTontine: updatedTontine,
          ),
        );
        add(TontineDetailsLoadRequested(updatedTontine.id));
      },
    );
  }

  Future<void> _onToggleAutoDebitRequested(
    ToggleAutoDebitRequested event,
    Emitter<TontineState> emit,
  ) async {
    if (state.selectedTontine == null) return;

    _logger.info(
      'Bascule auto-débit (${event.enabled}) pour la tontine: ${event.tontineId}',
      component: 'TontineBloc',
    );

    // We need the member ID of the current user in this tontine
    final currentUser = getIt<AuthBloc>().state.authResponse?.user;
    if (currentUser == null) return;

    final member = state.selectedTontineMembers
        .whereType<TontineMember>()
        .firstWhere(
          (m) => m.userId == currentUser.id,
          orElse: () => const TontineMember(
            id: '',
            tontineId: '',
            userId: '',
            displayName: '',
            parts: 0,
            trustScore: 0,
            hasPaidSocialFund: false,
          ),
        );

    if (member.id.isEmpty) {
      emit(
        state.copyWith(
          status: TontineStatus.error,
          errorMessage: 'Membre non trouvé dans cette tontine',
        ),
      );
      return;
    }

    emit(state.copyWith(status: TontineStatus.loading));
    final result = await _repository.toggleAutoDebit(
      tontineId: event.tontineId,
      memberId: member.id,
      enabled: event.enabled,
    );

    result.fold(
      (failure) {
        _logger.error(
          'Échec de la bascule auto-débit',
          error: failure.message,
          component: 'TontineBloc',
        );
        emit(
          state.copyWith(
            status: TontineStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedMember) {
        _logger.info('Bascule auto-débit réussie.', component: 'TontineBloc');
        final updatedMembers = state.selectedTontineMembers.map((m) {
          return m.id == updatedMember.id ? updatedMember : m;
        }).toList();
        emit(
          state.copyWith(
            status: TontineStatus.success,
            selectedTontineMembers: updatedMembers,
          ),
        );
      },
    );
  }
}
