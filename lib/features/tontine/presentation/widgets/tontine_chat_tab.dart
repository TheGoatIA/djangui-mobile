import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import '../../domain/entities/tontine_entities.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/tontine_bloc.dart';
import '../bloc/tontine_event.dart';
import '../bloc/tontine_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:intl/intl.dart';

class TontineChatTab extends StatefulWidget {
  final String tontineId;
  const TontineChatTab({super.key, required this.tontineId});

  @override
  State<TontineChatTab> createState() => _TontineChatTabState();
}

class _TontineChatTabState extends State<TontineChatTab> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const _minRecordingDuration = Duration(seconds: 1);
  static const _maxRecordingDuration = Duration(seconds: 120);
  static const _previewKey = '__preview__';
  static const _pollInterval = Duration(seconds: 5);

  bool _isRecording = false;
  DateTime? _recordingStartedAt;
  Timer? _recordingTimer;
  Duration _recordingElapsed = Duration.zero;
  String? _recordingPath;

  // Gates the error listener below to sends this tab actually triggered —
  // see the comment on that BlocListener for why.
  bool _isSendingMessage = false;

  // After a recording finishes, it sits here for the user to listen back to
  // and either discard or send — nothing is uploaded until they confirm.
  bool _isReviewing = false;
  String? _reviewPath;
  Duration _reviewDuration = Duration.zero;

  // Playback state shared between "reviewing my own not-yet-sent clip" and
  // "playing a bubble in the message list" — only one plays at a time on the
  // single shared player, distinguished by this key (a message id, or
  // _previewKey for the in-review clip).
  String? _activePlaybackKey;
  String? _loadingAudioKey;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;

  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    context.read<TontineBloc>().add(
      TontineMessagesLoadRequested(widget.tontineId),
    );
    _audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _playbackPosition = pos);
    });
    _audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _playbackDuration = dur);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _activePlaybackKey = null;
          _playbackPosition = Duration.zero;
        });
      }
    });

    // No websocket/live-push for chat messages yet — poll while this tab is
    // open so a message from another member shows up without having to leave
    // and re-enter the tab.
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!mounted) return;
      context.read<TontineBloc>().add(
        TontineMessagesLoadRequested(widget.tontineId),
      );
    });
  }

  @override
  void didUpdateWidget(covariant TontineChatTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tontineId != widget.tontineId) {
      _audioPlayer.stop();
      _activePlaybackKey = null;
      _loadingAudioKey = null;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
    }
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _pollTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.micPermissionDenied)));
      return;
    }

    final tempDir = await getTemporaryDirectory();
    _recordingPath = p.join(
      tempDir.path,
      'tontine_voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _recordingPath!,
    );
    _recordingStartedAt = DateTime.now();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _recordingStartedAt == null) return;
      final elapsed = DateTime.now().difference(_recordingStartedAt!);
      setState(() => _recordingElapsed = elapsed);
      if (elapsed >= _maxRecordingDuration) {
        _finishRecording();
      }
    });
    setState(() {
      _isRecording = true;
      _recordingElapsed = Duration.zero;
    });
  }

  Future<void> _cancelRecording() async {
    if (!_isRecording) return;
    _recordingTimer?.cancel();
    try {
      await _audioRecorder.stop();
    } catch (_) {}
    if (_recordingPath != null) _deleteFile(_recordingPath!);
    setState(() {
      _isRecording = false;
      _recordingElapsed = Duration.zero;
    });
  }

  /// Stops the recording and moves to the review step — nothing is sent yet.
  Future<void> _finishRecording() async {
    if (!_isRecording) return;
    _recordingTimer?.cancel();
    final elapsed = _recordingElapsed;
    String? path;
    try {
      path = await _audioRecorder.stop();
    } catch (_) {}
    setState(() {
      _isRecording = false;
      _recordingElapsed = Duration.zero;
    });
    if (path == null) return;

    if (elapsed < _minRecordingDuration) {
      _deleteFile(path);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.recordingTooShort)));
      return;
    }

    setState(() {
      _isReviewing = true;
      _reviewPath = path;
      _reviewDuration = elapsed;
    });
  }

  Future<void> _discardReview() async {
    if (_activePlaybackKey == _previewKey) {
      await _audioPlayer.stop();
    }
    if (_reviewPath != null) _deleteFile(_reviewPath!);
    setState(() {
      _isReviewing = false;
      _reviewPath = null;
      _reviewDuration = Duration.zero;
      if (_activePlaybackKey == _previewKey) _activePlaybackKey = null;
    });
  }

  void _sendReview() {
    if (_reviewPath == null) return;
    if (_activePlaybackKey == _previewKey) {
      _audioPlayer.stop();
      _activePlaybackKey = null;
    }
    _isSendingMessage = true;
    context.read<TontineBloc>().add(
      SendTontineVoiceMessageRequested(
        tontineId: widget.tontineId,
        audioFile: File(_reviewPath!),
        durationSeconds: _reviewDuration.inSeconds,
      ),
    );
    setState(() {
      _isReviewing = false;
      _reviewPath = null;
      _reviewDuration = Duration.zero;
    });
  }

  Future<void> _togglePreviewPlayback() async {
    if (_reviewPath == null) return;
    if (_activePlaybackKey == _previewKey) {
      await _audioPlayer.pause();
      setState(() => _activePlaybackKey = null);
      return;
    }
    await _audioPlayer.stop();
    setState(() {
      _activePlaybackKey = _previewKey;
      _playbackPosition = Duration.zero;
      _playbackDuration = _reviewDuration;
    });
    try {
      await _audioPlayer.play(DeviceFileSource(_reviewPath!));
    } catch (_) {
      if (mounted) setState(() => _activePlaybackKey = null);
    }
  }

  void _deleteFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }

  Future<void> _togglePlayback(TontineMessage message) async {
    if (message.audioUrl == null) return;
    if (_activePlaybackKey == message.id) {
      await _audioPlayer.pause();
      setState(() => _activePlaybackKey = null);
      return;
    }
    await _audioPlayer.stop();
    setState(() {
      _activePlaybackKey = message.id;
      _loadingAudioKey = message.id;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration(seconds: message.audioDuration ?? 0);
    });
    try {
      final localPath = await _resolveLocalAudioPath(
        message,
      ).timeout(const Duration(seconds: 15));
      if (!mounted || _activePlaybackKey != message.id) return;
      setState(() => _loadingAudioKey = null);
      await _audioPlayer.play(DeviceFileSource(localPath));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _activePlaybackKey = null;
        _loadingAudioKey = null;
      });
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.voiceNotePlaybackError)));
    }
  }

  /// Downloads a voice note to a local cache file on first playback, so later
  /// replays (and any offline access afterward) don't hit the network again.
  Future<String> _resolveLocalAudioPath(TontineMessage message) async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(p.join(dir.path, 'voice_cache'));
    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }
    final cachedFile = File(p.join(cacheDir.path, '${message.id}.m4a'));
    if (cachedFile.existsSync() && cachedFile.lengthSync() > 0) {
      return cachedFile.path;
    }
    final response = await http.get(Uri.parse(message.audioUrl!));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    await cachedFile.writeAsBytes(response.bodyBytes);
    return cachedFile.path;
  }

  String _formatDuration(Duration d) {
    final duration = d.isNegative ? Duration.zero : d;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _sendMessage() {
    if (_isRecording || _messageController.text.trim().isEmpty) return;
    _isSendingMessage = true;
    context.read<TontineBloc>().add(
      SendTontineMessageRequested(
        tontineId: widget.tontineId,
        content: _messageController.text.trim(),
      ),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<TontineBloc, TontineState>(
      // Scoped to "a send is actually in flight" — TontineBloc is a shared,
      // app-wide singleton whose `errorMessage` is also touched by passive,
      // silent background loads (this tab's own 5s poll included), which
      // otherwise popped up an unrelated error snackbar every time one of
      // those hiccuped, regardless of whether the user did anything at all.
      listenWhen: (previous, current) =>
          _isSendingMessage &&
          (current.errorMessage != null ||
              current.selectedTontineMessages.length !=
                  previous.selectedTontineMessages.length),
      listener: (context, state) {
        _isSendingMessage = false;
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final currentUserId = authState.authResponse?.user.id;

                return BlocBuilder<TontineBloc, TontineState>(
                  builder: (context, state) {
                    final List<TontineMessage> messages =
                        state.selectedTontineMessages;
                    final List<TontineMember> members =
                        state.selectedTontineMembers;

                    if (messages.isEmpty && state.isLoadingMessages) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noMessagesYet,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final sortedMessages = List.of(messages)
                      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      itemCount: sortedMessages.length,
                      itemBuilder: (context, index) {
                        final message = sortedMessages[index];
                        final isMe = message.senderId == currentUserId;

                        bool showDateHeader = false;
                        if (index == sortedMessages.length - 1) {
                          showDateHeader = true;
                        } else {
                          final nextMessage = sortedMessages[index + 1];
                          final currentDate = DateTime(
                            message.createdAt.year,
                            message.createdAt.month,
                            message.createdAt.day,
                          );
                          final nextDate = DateTime(
                            nextMessage.createdAt.year,
                            nextMessage.createdAt.month,
                            nextMessage.createdAt.day,
                          );
                          if (currentDate != nextDate) {
                            showDateHeader = true;
                          }
                        }

                        final sender = members.cast<dynamic>().firstWhere(
                          (m) => m.userId == message.senderId,
                          orElse: () => null,
                        );
                        final senderName = sender?.displayName ?? 'Inconnu';

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showDateHeader)
                              _buildDateHeader(context, message.createdAt),
                            Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                                    bottomRight: Radius.circular(isMe ? 4 : 16),
                                  ),
                                ),
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe) ...[
                                        Text(
                                          senderName,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      message.type == 'audio'
                                          ? _buildAudioBubble(
                                              context,
                                              message,
                                              isMe,
                                            )
                                          : Text(
                                              message.content,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color: isMe
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                  ),
                                            ),
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          DateFormat(
                                            'HH:mm',
                                          ).format(message.createdAt),
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                fontSize: 10,
                                                color: isMe
                                                    ? Colors.white.withValues(
                                                        alpha: 0.7,
                                                      )
                                                    : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          _buildInputArea(l10n),
        ],
      ),
    );
  }

  Widget _buildAudioBubble(
    BuildContext context,
    TontineMessage message,
    bool isMe,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isThisPlaying = _activePlaybackKey == message.id;
    final isLoading = _loadingAudioKey == message.id;
    final isUploading =
        message.id.startsWith('temp_') && message.audioUrl == null;
    final color = isMe ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final totalDuration = isThisPlaying && _playbackDuration.inMilliseconds > 0
        ? _playbackDuration
        : Duration(seconds: message.audioDuration ?? 0);
    final remaining = isThisPlaying
        ? totalDuration - _playbackPosition
        : totalDuration;

    return Semantics(
      label: l10n.voiceNoteFallbackLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: isUploading || isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isThisPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: color,
                      size: 32,
                    ),
                    onPressed: message.audioUrl == null
                        ? null
                        : () => _togglePlayback(message),
                  ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: isThisPlaying && totalDuration.inMilliseconds > 0
                        ? (_playbackPosition.inMilliseconds /
                                  totalDuration.inMilliseconds)
                              .clamp(0.0, 1.0)
                        : 0,
                    minHeight: 3,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDuration(remaining),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations l10n) {
    return BlocBuilder<TontineBloc, TontineState>(
      builder: (context, state) {
        final tontine = state.selectedTontine;
        final status = tontine?.status.toLowerCase() ?? '';
        final isInactive =
            status == 'completed' || status.contains('suspended');

        if (isInactive) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Center(
              child: Text(
                status == 'completed'
                    ? "Tontine terminée - Chat en lecture seule"
                    : "Tontine suspendue - Chat désactivé",
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: _isReviewing ? _buildReviewRow(l10n) : _buildComposeRow(l10n),
        );
      },
    );
  }

  Widget _buildReviewRow(AppLocalizations l10n) {
    final isPreviewPlaying = _activePlaybackKey == _previewKey;
    final remaining = isPreviewPlaying
        ? _reviewDuration - _playbackPosition
        : _reviewDuration;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: _discardReview,
        ),
        Expanded(
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isPreviewPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _togglePreviewPlayback,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value:
                        isPreviewPlaying && _reviewDuration.inMilliseconds > 0
                        ? (_playbackPosition.inMilliseconds /
                                  _reviewDuration.inMilliseconds)
                              .clamp(0.0, 1.0)
                        : 0,
                    minHeight: 3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(_formatDuration(remaining), style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
            onPressed: _sendReview,
          ),
        ),
      ],
    );
  }

  Widget _buildComposeRow(AppLocalizations l10n) {
    return Row(
      children: [
        if (_isRecording)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: _cancelRecording,
          )
        else
          const SizedBox(width: 4),
        Expanded(
          child: _isRecording
              ? Row(
                  children: [
                    Icon(Icons.fiber_manual_record, color: Colors.red, size: 14)
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeOut(duration: 600.ms),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(_recordingElapsed),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.recordingHint,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: l10n.typeAMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _finishRecording(),
          onLongPressCancel: _cancelRecording,
          child: CircleAvatar(
            backgroundColor: _isRecording
                ? Colors.red
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              color: _isRecording
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
            onPressed: _isRecording ? null : _sendMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String text;
    if (messageDate == today) {
      text = "Aujourd'hui";
    } else if (messageDate == yesterday) {
      text = "Hier";
    } else {
      text = DateFormat.yMMMMd('fr').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
