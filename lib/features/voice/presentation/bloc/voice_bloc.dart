import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../domain/repositories/voice_repository.dart';
import 'voice_event.dart';
import 'voice_state.dart';

@injectable
class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final VoiceRepository _voiceRepository;
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentPath;

  VoiceBloc(this._voiceRepository) : super(const VoiceState()) {
    on<StartRecordingRequested>(_onStartRecording);
    on<StopRecordingRequested>(_onStopRecording);
    on<SendVoiceRequested>(_onSendVoiceRequested);
    on<VoiceResponseConfirmed>(_onResponseConfirmed);
    on<VoiceResponseCancelled>(_onResponseCancelled);
  }

  Future<void> _onStartRecording(
    StartRecordingRequested event,
    Emitter<VoiceState> emit,
  ) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        _currentPath = p.join(tempDir.path, 'voice_input.m4a');

        // Delete old file if exists
        final file = File(_currentPath!);
        if (await file.exists()) {
          await file.delete();
        }

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: _currentPath!,
        );
        emit(state.copyWith(status: VoiceStatus.recording));
      } else {
        emit(
          state.copyWith(
            status: VoiceStatus.error,
            errorMessage: 'Permission d\'enregistrement refusée',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: VoiceStatus.error,
          errorMessage: 'Erreur lors du démarrage de l\'enregistrement : $e',
        ),
      );
    }
  }

  Future<void> _onStopRecording(
    StopRecordingRequested event,
    Emitter<VoiceState> emit,
  ) async {
    try {
      final path = await _audioRecorder.stop();
      if (path == null) {
        emit(state.copyWith(status: VoiceStatus.idle));
        return;
      }

      emit(state.copyWith(status: VoiceStatus.recorded, audioPath: path));
    } catch (e) {
      emit(
        state.copyWith(
          status: VoiceStatus.error,
          errorMessage: 'Erreur lors du traitement de l\'audio : $e',
        ),
      );
    }
  }

  Future<void> _onSendVoiceRequested(
    SendVoiceRequested event,
    Emitter<VoiceState> emit,
  ) async {
    final path = state.audioPath ?? _currentPath;
    if (path == null) {
      emit(
        state.copyWith(
          status: VoiceStatus.error,
          errorMessage: 'Aucun enregistrement trouvé',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: VoiceStatus.processing));

      final result = await _voiceRepository.processVoice(File(path));

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: VoiceStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (response) {
          if (!response.isValid) {
            emit(
              state.copyWith(
                status: VoiceStatus.error,
                errorMessage: response.description,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: VoiceStatus.success,
                voiceResponse: response,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VoiceStatus.error,
          errorMessage: 'Erreur lors du traitement de l\'audio : $e',
        ),
      );
    }
  }

  void _onResponseConfirmed(
    VoiceResponseConfirmed event,
    Emitter<VoiceState> emit,
  ) {
    emit(const VoiceState(status: VoiceStatus.idle));
  }

  void _onResponseCancelled(
    VoiceResponseCancelled event,
    Emitter<VoiceState> emit,
  ) {
    emit(const VoiceState(status: VoiceStatus.idle));
  }

  @override
  Future<void> close() {
    _audioRecorder.dispose();
    return super.close();
  }
}
