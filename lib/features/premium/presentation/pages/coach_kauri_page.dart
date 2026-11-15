import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/premium_bloc.dart';
import '../bloc/premium_event.dart';
import '../bloc/premium_state.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CoachKauriPage extends StatefulWidget {
  const CoachKauriPage({super.key});

  @override
  State<CoachKauriPage> createState() => _CoachKauriPageState();
}

class _CoachKauriPageState extends State<CoachKauriPage> {
  final TextEditingController _controller = TextEditingController();
  late List<Map<String, String>> _messages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messages = [
      {
        'role': 'assistant',
        'content': AppLocalizations.of(context)!.coachWelcomeMessage,
      },
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.coachTitle),
        centerTitle: true,
      ),
      body: BlocListener<PremiumBloc, PremiumState>(
        listener: (context, state) {
          if (state.status == PremiumStatus.success &&
              state.coachResponse != null) {
            setState(() {
              _messages.add({
                'role': 'assistant',
                'content':
                    state.coachResponse!['answer'] ??
                    AppLocalizations.of(context)!.genericError,
              });
            });
          } else if (state.status == PremiumStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.genericError,
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 0),
                          bottomRight: Radius.circular(isUser ? 0 : 20),
                        ),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                  );
                },
              ),
            ),
            if (context.watch<PremiumBloc>().state.status ==
                PremiumStatus.loading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.typeQuestionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _sendMessage,
              mini: true,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final text = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
    });
    _controller.clear();
    context.read<PremiumBloc>().add(PremiumCoachAskRequested(text));
  }
}
