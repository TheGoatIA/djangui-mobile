import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/voice_bloc.dart';
import '../bloc/voice_event.dart';
import '../bloc/voice_state.dart';
import './voice_recording_overlay.dart';
import './voice_confirmation_sheet.dart';
import './voice_preview_sheet.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/di/injection.dart';

class VoiceFAB extends StatefulWidget {
  const VoiceFAB({super.key});

  @override
  State<VoiceFAB> createState() => _VoiceFABState();
}

class _VoiceFABState extends State<VoiceFAB> {
  bool _isPressed = false;

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() => _isPressed = true);
    getIt<AnalyticsManager>().trackEvent(feature: 'Voice', action: 'activated');
    context.read<VoiceBloc>().add(StartRecordingRequested());
    _showRecordingOverlay();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() => _isPressed = false);
    context.read<VoiceBloc>().add(StopRecordingRequested());
  }

  void _showRecordingOverlay() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (context) => const VoiceRecordingOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceBloc, VoiceState>(
      listener: (context, state) {
        if (state.status == VoiceStatus.success &&
            state.voiceResponse != null) {
          // If the overlay is still there, we might need to close it or handle it.
          // But our StopRecordingRequested will trigger the processing state.
          // Let's ensure the overlay closes when processing starts or ends.
        }

        if (state.status == VoiceStatus.processing ||
            state.status == VoiceStatus.recorded) {
          // Close the recording overlay if it's still open
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }

        if (state.status == VoiceStatus.recorded && state.audioPath != null) {
          _showPreviewSheet(state.audioPath!);
        }

        if (state.status == VoiceStatus.error && state.errorMessage != null) {
          // Close overlay on error too
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }

        if (state.status == VoiceStatus.success &&
            state.voiceResponse != null) {
          _showConfirmationSheet(state.voiceResponse!);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          child:
              Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isPressed
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      state.status == VoiceStatus.processing
                          ? Icons.hourglass_empty
                          : Icons.mic_none_rounded,
                      color: _isPressed
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                  .animate(target: _isPressed ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    duration: 200.ms,
                  ),
        );
      },
    );
  }

  void _showConfirmationSheet(dynamic response) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceConfirmationSheet(response: response),
    );
  }

  void _showPreviewSheet(String audioPath) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoicePreviewSheet(audioPath: audioPath),
    );
  }
}
