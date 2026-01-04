import 'package:equatable/equatable.dart';
import '../../data/models/chat_message_model.dart';

enum CoachStatus { initial, loading, success, error }

class CoachState extends Equatable {
  final CoachStatus status;
  final List<ChatMessageModel> messages;
  final String? errorMessage;
  final bool isSending;

  const CoachState({
    this.status = CoachStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.isSending = false,
  });

  factory CoachState.initial() => const CoachState();

  CoachState copyWith({
    CoachStatus? status,
    List<ChatMessageModel>? messages,
    String? errorMessage,
    bool? isSending,
  }) {
    return CoachState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage, isSending];
}
