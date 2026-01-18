import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<TontineBloc>().add(
      TontineMessagesLoadRequested(widget.tontineId),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
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

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final currentUserId = authState.authResponse?.user.id;

              return BlocBuilder<TontineBloc, TontineState>(
                builder: (context, state) {
                  final messages = state.selectedTontineMessages;
                  final members = state.selectedTontineMembers;

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isMe) ...[
                                      Text(
                                        senderName,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    Text(
                                      message.content,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: isMe
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        DateFormat(
                                          'HH:mm',
                                        ).format(message.createdAt),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontSize: 10,
                                          color: isMe
                                              ? Colors.white.withValues(
                                                  alpha: 0.7,
                                                )
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.5),
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
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
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        );
      },
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
