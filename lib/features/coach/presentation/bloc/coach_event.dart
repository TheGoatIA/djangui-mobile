import 'package:equatable/equatable.dart';

abstract class CoachEvent extends Equatable {
  const CoachEvent();

  @override
  List<Object?> get props => [];
}

class GetChatHistoryRequested extends CoachEvent {}

class SendMessageRequested extends CoachEvent {
  final String text;

  const SendMessageRequested(this.text);

  @override
  List<Object?> get props => [text];
}

class ClearHistoryRequested extends CoachEvent {}

/// Réessaie l'envoi d'un message précédemment en échec (même id, même
/// texte) — remplace la bulle existante au lieu d'en créer une nouvelle.
class RetryMessageRequested extends CoachEvent {
  final String messageId;

  const RetryMessageRequested(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
