import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/di/injection.dart';
import '../../domain/repositories/support_repository.dart';
import 'support_event.dart';
import 'support_state.dart';

@lazySingleton
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository _repository;
  LogService get _logger => getIt<LogService>();

  SupportBloc(this._repository) : super(const SupportState()) {
    on<GetTicketsRequested>(_onGetTicketsRequested);
    on<CreateTicketRequested>(_onCreateTicketRequested);
    on<ReplyToTicketRequested>(_onReplyToTicketRequested);
  }

  Future<void> _onGetTicketsRequested(
    GetTicketsRequested event,
    Emitter<SupportState> emit,
  ) async {
    _logger.info(
      'Récupération de la liste des tickets de support...',
      component: 'SupportBloc',
    );
    emit(state.copyWith(status: SupportStatus.loading));
    final result = await _repository.getTickets();
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la récupération des tickets',
          error: failure.message,
          component: 'SupportBloc',
        );
        emit(
          state.copyWith(
            status: SupportStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (tickets) {
        _logger.info(
          '${tickets.length} tickets récupérés.',
          component: 'SupportBloc',
        );
        emit(state.copyWith(status: SupportStatus.success, tickets: tickets));
      },
    );
  }

  Future<void> _onCreateTicketRequested(
    CreateTicketRequested event,
    Emitter<SupportState> emit,
  ) async {
    _logger.info(
      'Tentative de création d\'un ticket de support...',
      component: 'SupportBloc',
      metadata: {'subject': event.subject, 'category': event.category},
    );
    emit(state.copyWith(isCreating: true));
    final result = await _repository.createTicket(
      subject: event.subject,
      message: event.message,
      category: event.category,
    );
    result.fold(
      (failure) {
        _logger.error(
          'Échec de la création du ticket',
          error: failure.message,
          component: 'SupportBloc',
        );
        emit(state.copyWith(isCreating: false, errorMessage: failure.message));
      },
      (_) {
        _logger.info(
          'Ticket de support créé avec succès.',
          component: 'SupportBloc',
        );
        emit(state.copyWith(isCreating: false, errorMessage: null));
        add(GetTicketsRequested());
      },
    );
  }

  Future<void> _onReplyToTicketRequested(
    ReplyToTicketRequested event,
    Emitter<SupportState> emit,
  ) async {
    _logger.info(
      'Réponse au ticket de support: ${event.ticketId}',
      component: 'SupportBloc',
    );
    emit(state.copyWith(isReplied: false));
    final result = await _repository.replyToTicket(
      ticketId: event.ticketId,
      message: event.message,
    );
    result.fold(
      (failure) {
        _logger.error(
          'Échec de l\'envoi de la réponse',
          error: failure.message,
          component: 'SupportBloc',
        );
        emit(state.copyWith(errorMessage: failure.message));
      },
      (_) {
        _logger.info('Réponse envoyée avec succès.', component: 'SupportBloc');
        emit(state.copyWith(isReplied: true, errorMessage: null));
        add(GetTicketsRequested());
      },
    );
  }
}
