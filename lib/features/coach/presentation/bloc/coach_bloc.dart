import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/repositories/coach_repository.dart';
import 'coach_event.dart';
import 'coach_state.dart';

@injectable
class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository _coachRepository;

  CoachBloc(this._coachRepository) : super(CoachState.initial()) {
    on<GetChatHistoryRequested>(_onGetChatHistoryRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<ClearHistoryRequested>(_onClearHistoryRequested);
  }

  Future<void> _onGetChatHistoryRequested(
    GetChatHistoryRequested event,
    Emitter<CoachState> emit,
  ) async {
    emit(state.copyWith(status: CoachStatus.loading));
    final result = await _coachRepository.getChatHistory();
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: CoachStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (history) =>
          emit(state.copyWith(status: CoachStatus.success, messages: history)),
    );
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<CoachState> emit,
  ) async {
    debugPrint('🤖 [CoachBloc] Sending message: ${event.text}');
    // Add optimistic user message
    final userMessage = ChatMessageModel(
      id: const Uuid().v4(),
      text: event.text,
      sender: 'user',
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessageModel>.from(state.messages)
      ..add(userMessage);
    debugPrint(
      '🤖 [CoachBloc] Optimistic update: ${updatedMessages.length} messages',
    );
    emit(state.copyWith(messages: updatedMessages, isSending: true));

    final result = await _coachRepository.sendMessage(event.text);
    result.fold<void>(
      (failure) {
        debugPrint('🤖 [CoachBloc] Send message failed: ${failure.message}');
        emit(
          state.copyWith(
            isSending: false,
            status: CoachStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (ChatMessageModel aiMessage) {
        debugPrint('🤖 [CoachBloc] AI response received: ${aiMessage.text}');
        final finalMessages = List<ChatMessageModel>.from(state.messages)
          ..add(aiMessage);
        debugPrint(
          '🤖 [CoachBloc] Final update: ${finalMessages.length} messages',
        );
        emit(state.copyWith(isSending: false, messages: finalMessages));
      },
    );
  }

  Future<void> _onClearHistoryRequested(
    ClearHistoryRequested event,
    Emitter<CoachState> emit,
  ) async {
    final result = await _coachRepository.clearHistory();
    result.fold<void>(
      (failure) => emit(
        state.copyWith(
          status: CoachStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(status: CoachStatus.success, messages: const [])),
    );
  }
}
