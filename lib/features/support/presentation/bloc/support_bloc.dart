import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/support_repository.dart';
import 'support_event.dart';
import 'support_state.dart';

@injectable
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository _repository;

  SupportBloc(this._repository) : super(const SupportState()) {
    on<GetTicketsRequested>(_onGetTicketsRequested);
    on<CreateTicketRequested>(_onCreateTicketRequested);
    on<ReplyToTicketRequested>(_onReplyToTicketRequested);
  }

  Future<void> _onGetTicketsRequested(
    GetTicketsRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(status: SupportStatus.loading));
    final result = await _repository.getTickets();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupportStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (tickets) =>
          emit(state.copyWith(status: SupportStatus.success, tickets: tickets)),
    );
  }

  Future<void> _onCreateTicketRequested(
    CreateTicketRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isCreating: true));
    final result = await _repository.createTicket(
      subject: event.subject,
      message: event.message,
      category: event.category,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isCreating: false, errorMessage: failure.message),
      ),
      (_) {
        emit(state.copyWith(isCreating: false, errorMessage: null));
        add(GetTicketsRequested());
      },
    );
  }

  Future<void> _onReplyToTicketRequested(
    ReplyToTicketRequested event,
    Emitter<SupportState> emit,
  ) async {
    emit(state.copyWith(isReplied: false));
    final result = await _repository.replyToTicket(
      ticketId: event.ticketId,
      message: event.message,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isReplied: true, errorMessage: null));
        add(GetTicketsRequested());
      },
    );
  }
}
