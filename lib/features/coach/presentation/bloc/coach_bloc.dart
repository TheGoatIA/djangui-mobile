import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/repositories/coach_repository.dart';
import 'coach_event.dart';
import 'coach_state.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';

@injectable
class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository _coachRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();

  CoachBloc(this._coachRepository) : super(CoachState.initial()) {
    on<GetChatHistoryRequested>(_onGetChatHistoryRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<ClearHistoryRequested>(_onClearHistoryRequested);
  }

  Future<void> _onGetChatHistoryRequested(
    GetChatHistoryRequested event,
    Emitter<CoachState> emit,
  ) async {
    // If we already have messages in state, don't show loading spinner, but we can still refresh
    if (state.messages.isEmpty) {
      emit(state.copyWith(status: CoachStatus.loading));
    }

    final result = await _coachRepository.getChatHistory();
    result.fold<void>(
      (failure) {
        if (state.messages.isEmpty) {
          emit(
            state.copyWith(
              status: CoachStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (history) {
        emit(state.copyWith(status: CoachStatus.success, messages: history));

        // Telemetry: AI Engagement
        _telemetry.recordEvent('ux.ai_coach.session_load', {
          'message_count': history.length,
        });
      },
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

    final startTime = DateTime.now();
    final result = await _coachRepository.sendMessage(event.text);
    final duration = DateTime.now().difference(startTime).inMilliseconds;

    result.fold<void>(
      (failure) {
        debugPrint('🤖 [CoachBloc] Send message failed: ${failure.message}');

        // Telemetry: AI Failure
        _telemetry.recordEvent('ux.ai_coach.error', {
          'error': failure.message,
          'latency_ms': duration,
        });

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

        // Telemetry: AI Latency & Success
        _telemetry.recordEvent('ux.ai_coach.response', {
          'latency_ms': duration,
          'message_length': aiMessage.text.length,
        });

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
