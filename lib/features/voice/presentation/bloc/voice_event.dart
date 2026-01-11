import 'package:equatable/equatable.dart';
import '../../data/models/voice_response_model.dart';

abstract class VoiceEvent extends Equatable {
  const VoiceEvent();

  @override
  List<Object?> get props => [];
}

class StartRecordingRequested extends VoiceEvent {}

class StopRecordingRequested extends VoiceEvent {}

class SendVoiceRequested extends VoiceEvent {}

class VoiceResponseConfirmed extends VoiceEvent {
  final VoiceResponseModel response;
  const VoiceResponseConfirmed(this.response);

  @override
  List<Object?> get props => [response];
}

class VoiceResponseCancelled extends VoiceEvent {}
