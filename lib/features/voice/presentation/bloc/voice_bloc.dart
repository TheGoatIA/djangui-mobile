import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kauri/core/error/error_mapper.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../domain/repositories/voice_repository.dart';
import 'voice_event.dart';
import 'voice_state.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/core/services/log_service.dart';
import '../../../../di/injection.dart';

@lazySingleton
class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final VoiceRepository _voiceRepository;
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentPath;

  TelemetryService get _telemetry => getIt<TelemetryService>();

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
        getIt<LogService>().warning(
          'Permission micro refusée',
          component: 'VoiceBloc',
        );
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
          errorMessage: ErrorMapper.safeMessage(e),
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
      getIt<LogService>().error(
        'Erreur arrêt enregistrement',
        component: 'VoiceBloc',
        error: e,
      );
      emit(
        state.copyWith(
          status: VoiceStatus.error,
          errorMessage: ErrorMapper.safeMessage(e),
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

      getIt<AnalyticsManager>().trackEvent(
        feature: 'Voice',
        action: 'processing_start',
      );

      final startTime = DateTime.now();
      final result = await _voiceRepository.processVoice(File(path));

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      result.fold(
        (failure) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Voice',
            action: 'processing_error',
            details: {'error': failure.message},
          );

          _telemetry.recordEvent('reliability.voice.error', {
            'error': failure.message,
            'latency_ms': duration,
          });

          getIt<LogService>().error(
            'Erreur traitement voix',
            component: 'VoiceBloc',
            error: failure.message,
          );
          emit(
            state.copyWith(
              status: VoiceStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          if (!response.isValid) {
            getIt<AnalyticsManager>().trackEvent(
              feature: 'Voice',
              action: 'processing_invalid',
              details: {'reason': response.description},
            );

            _telemetry.recordEvent('reliability.voice.invalid', {
              'reason': response.description,
              'latency_ms': duration,
            });

            emit(
              state.copyWith(
                status: VoiceStatus.error,
                errorMessage: response.description,
              ),
            );
          } else {
            getIt<AnalyticsManager>().trackEvent(
              feature: 'Voice',
              action: 'processing_success',
              details: {'intent': response.type},
            );

            _telemetry.recordEvent('reliability.voice.success', {
              'intent': response.type,
              'latency_ms': duration,
            });

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
          errorMessage: ErrorMapper.safeMessage(e),
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
