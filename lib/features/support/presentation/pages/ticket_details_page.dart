import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/support_bloc.dart';
import '../bloc/support_event.dart';
import '../bloc/support_state.dart';
import '../../data/models/support_ticket_model.dart';
import 'package:intl/intl.dart';

class TicketDetailsPage extends StatefulWidget {
  final String ticketId;

  const TicketDetailsPage({super.key, required this.ticketId});

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Refresh tickets to ensure we have the latest details for this one
    context.read<SupportBloc>().add(GetTicketsRequested());
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportBloc, SupportState>(
      listener: (context, state) {
        if (state.status == SupportStatus.success) {
          _replyController.clear();
        } else if (state.status == SupportStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    AppLocalizations.of(context)!.genericError,
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final ticket = state.tickets.firstWhere(
          (t) => t.id == widget.ticketId,
          orElse: () => SupportTicketModel(
            id: widget.ticketId,
            subject: '...',
            message: '...',
            status: '...',
            category: '...',
            createdAt: DateTime.now(),
            replies: [],
          ),
        );

        if (ticket.subject == '...') {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(title: Text(ticket.subject), centerTitle: false),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _MessageBubble(
                      message: ticket.message,
                      date: ticket.createdAt,
                      isUser: true,
                    ),
                    ...?ticket.replies?.map(
                      (reply) => _MessageBubble(
                        message: reply.message,
                        date: reply.createdAt,
                        isUser: reply.isAdmin ? false : true,
                      ),
                    ),
                  ],
                ),
              ),
              _ReplyInput(
                controller: _replyController,
                isLoading: state.status == SupportStatus.loading,
                onSend: () {
                  if (_replyController.text.isNotEmpty) {
                    context.read<SupportBloc>().add(
                      ReplyToTicketRequested(
                        ticketId: widget.ticketId,
                        message: _replyController.text,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final DateTime date;
  final bool isUser;

  const _MessageBubble({
    required this.message,
    required this.date,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMEd(
      Localizations.localeOf(context).languageCode,
    ).add_Hm();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight: isUser
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
                bottomLeft: isUser
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
              ),
            ),
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isUser
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateFormat.format(date),
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const _ReplyInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.reply,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: isLoading ? null : onSend,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
