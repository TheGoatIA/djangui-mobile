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
