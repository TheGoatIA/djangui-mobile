import 'package:equatable/equatable.dart';
import '../../data/models/voice_response_model.dart';

enum VoiceStatus { idle, recording, recorded, processing, success, error }

class VoiceState extends Equatable {
  final VoiceStatus status;
  final VoiceResponseModel? voiceResponse;
  final String? errorMessage;
  final double recordingDuration; // In seconds
  final String? audioPath;

  const VoiceState({
    this.status = VoiceStatus.idle,
    this.voiceResponse,
    this.errorMessage,
    this.recordingDuration = 0,
    this.audioPath,
  });

  VoiceState copyWith({
    VoiceStatus? status,
    VoiceResponseModel? voiceResponse,
    String? errorMessage,
    double? recordingDuration,
    String? audioPath,
  }) {
    return VoiceState(
      status: status ?? this.status,
      voiceResponse: voiceResponse ?? this.voiceResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  List<Object?> get props => [
    status,
    voiceResponse,
    errorMessage,
    recordingDuration,
    audioPath,
  ];
}
