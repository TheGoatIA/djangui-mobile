import 'package:equatable/equatable.dart';
import '../../data/models/chat_message_model.dart';

enum CoachStatus { initial, loading, success, error }

class CoachState extends Equatable {
  final CoachStatus status;
  final List<ChatMessageModel> messages;
  final String? errorMessage;
  final bool isSending;
  // Id du message IA en cours de réception (streaming) — tant qu'il n'y a
  // pas encore eu le moindre fragment de texte, vaut null même si
  // [isSending] est déjà true (l'UI affiche alors l'indicateur "Anne
  // réfléchit" plutôt qu'une bulle vide).
  final String? streamingMessageId;

  const CoachState({
    this.status = CoachStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.isSending = false,
    this.streamingMessageId,
  });

  factory CoachState.initial() => const CoachState();

  CoachState copyWith({
    CoachStatus? status,
    List<ChatMessageModel>? messages,
    String? errorMessage,
    bool? isSending,
    String? streamingMessageId,
    bool clearStreamingMessageId = false,
  }) {
    return CoachState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      // Volontairement PAS `errorMessage ?? this.errorMessage` : un échec est
      // un signal ponctuel pour l'action qui vient d'échouer, pas un état
      // persistant — sinon une erreur passée resterait accrochée à tout
      // échange réussi ultérieur et ré-déclencherait la snackbar à chaque
      // nouvelle émission d'état (nouveau message, etc.).
      errorMessage: errorMessage,
      isSending: isSending ?? this.isSending,
      streamingMessageId: clearStreamingMessageId
          ? null
          : (streamingMessageId ?? this.streamingMessageId),
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    errorMessage,
    isSending,
    streamingMessageId,
  ];
}
