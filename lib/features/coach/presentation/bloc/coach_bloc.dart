import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/entities/coach_send_update.dart';
import '../../domain/repositories/coach_repository.dart';
import 'coach_event.dart';
import 'coach_state.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/core/services/log_service.dart';

@injectable
class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository _coachRepository;
  TelemetryService get _telemetry => getIt<TelemetryService>();

  CoachBloc(this._coachRepository) : super(CoachState.initial()) {
    on<GetChatHistoryRequested>(_onGetChatHistoryRequested);
    // sequential() : jamais deux envois/réessais traités en parallèle, qui
    // pourraient sinon interlacer leurs emits (placeholders, textes en
    // streaming) de façon incohérente. Mis en file plutôt que jeté (à
    // l'inverse de droppable()) pour ne perdre aucun message.
    on<SendMessageRequested>(_onSendMessageRequested, transformer: sequential());
    on<RetryMessageRequested>(_onRetryMessageRequested, transformer: sequential());
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
          getIt<LogService>().error(
            'Echec chargement historique Coach',
            component: 'CoachBloc',
            error: failure.message,
          );
          emit(
            state.copyWith(
              status: CoachStatus.error,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (history) {
        emit(
          state.copyWith(
            status: CoachStatus.success,
            messages: history,
            errorMessage: null,
          ),
        );

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
    await _sendAndStream(const Uuid().v4(), event.text, emit);
  }

  Future<void> _onRetryMessageRequested(
    RetryMessageRequested event,
    Emitter<CoachState> emit,
  ) async {
    ChatMessageModel? failedMessage;
    for (final m in state.messages) {
      if (m.id == event.messageId) {
        failedMessage = m;
        break;
      }
    }
    if (failedMessage == null) return;
    await _sendAndStream(failedMessage.id, failedMessage.text, emit);
  }

  /// Cœur commun à l'envoi initial et au réessai : affiche/replace la bulle
  /// utilisateur (statut 'sending'), crée la bulle IA dès le premier
  /// fragment reçu, puis la met à jour au fil de l'eau jusqu'à la fin du
  /// flux ou une erreur.
  Future<void> _sendAndStream(
    String messageId,
    String text,
    Emitter<CoachState> emit,
  ) async {
    debugPrint('🤖 [CoachBloc] Sending message: $text');
    final userMessage = ChatMessageModel(
      id: messageId,
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
      status: 'sending',
    );

    final alreadyPresent = state.messages.any((m) => m.id == messageId);
    final seededMessages = alreadyPresent
        ? state.messages.map((m) => m.id == messageId ? userMessage : m).toList()
        : (List<ChatMessageModel>.from(state.messages)..add(userMessage));

    emit(
      state.copyWith(
        messages: seededMessages,
        isSending: true,
        errorMessage: null,
        clearStreamingMessageId: true,
      ),
    );

    final startTime = DateTime.now();
    String? aiMessageId;

    await for (final update in _coachRepository.sendMessageStream(
      messageId,
      text,
    )) {
      switch (update) {
        case CoachSendDelta(:final cumulativeText):
          if (aiMessageId == null) {
            aiMessageId = const Uuid().v4();
            final placeholder = ChatMessageModel(
              id: aiMessageId,
              text: cumulativeText,
              sender: 'ai',
              timestamp: DateTime.now(),
            );
            emit(
              state.copyWith(
                messages: [...state.messages, placeholder],
                streamingMessageId: aiMessageId,
              ),
            );
          } else {
            final updatedId = aiMessageId;
            final updated = state.messages
                .map(
                  (m) => m.id == updatedId
                      ? m.copyWith(text: cumulativeText)
                      : m,
                )
                .toList();
            emit(state.copyWith(messages: updated));
          }

        case CoachSendCompleted(:final text, :final actions):
          final duration = DateTime.now().difference(startTime).inMilliseconds;
          _telemetry.recordEvent('ux.ai_coach.response', {
            'latency_ms': duration,
            'message_length': text.length,
          });

          final confirmedUserMessages = state.messages
              .map((m) => m.id == messageId ? m.copyWith(status: 'sent') : m)
              .toList();

          final finalAiId = aiMessageId;
          List<ChatMessageModel> finalMessages;
          if (finalAiId != null) {
            finalMessages = confirmedUserMessages
                .map(
                  (m) => m.id == finalAiId
                      ? ChatMessageModel(
                          id: m.id,
                          text: text,
                          sender: 'ai',
                          timestamp: m.timestamp,
                          actions: actions,
                        )
                      : m,
                )
                .toList();
          } else {
            // Aucun fragment n'a jamais été reçu (réponse vide, cas limite) :
            // ajoute directement le message final.
            finalMessages = [
              ...confirmedUserMessages,
              ChatMessageModel(
                id: const Uuid().v4(),
                text: text,
                sender: 'ai',
                timestamp: DateTime.now(),
                actions: actions,
              ),
            ];
          }

          debugPrint(
            '🤖 [CoachBloc] Final update: ${finalMessages.length} messages',
          );
          emit(
            state.copyWith(
              isSending: false,
              messages: finalMessages,
              errorMessage: null,
              clearStreamingMessageId: true,
            ),
          );

        case CoachSendFailed(:final failure):
          final duration = DateTime.now().difference(startTime).inMilliseconds;
          debugPrint('🤖 [CoachBloc] Send message failed: ${failure.message}');

          _telemetry.recordEvent('ux.ai_coach.error', {
            'error': failure.message,
            'latency_ms': duration,
          });

          getIt<LogService>().error(
            'Echec envoi message Coach',
            component: 'CoachBloc',
            error: failure.message,
          );

          // Marque le message utilisateur en échec (garde-le visible avec un
          // bouton réessayer) et retire le placeholder IA vide s'il existe.
          final failedAiId = aiMessageId;
          final messagesAfterFailure = state.messages
              .where((m) => m.id != failedAiId)
              .map(
                (m) => m.id == messageId ? m.copyWith(status: 'failed') : m,
              )
              .toList();

          emit(
            state.copyWith(
              messages: messagesAfterFailure,
              isSending: false,
              status: CoachStatus.error,
              errorMessage: failure.message,
              clearStreamingMessageId: true,
            ),
          );
      }
    }
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
