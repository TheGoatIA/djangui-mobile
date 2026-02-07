import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../bloc/coach_bloc.dart';
import '../bloc/coach_event.dart';
import '../bloc/coach_state.dart';
import '../../data/models/chat_message_model.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';

/// Page de discussion avec le Coach Kauri (IA).
///
/// Permet à l'utilisateur de poser des questions financières, de recevoir des
/// conseils personnalisés et d'interagir avec des suggestions d'actions.
class CoachChatPage extends StatelessWidget {
  const CoachChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CoachBloc>()..add(GetChatHistoryRequested()),
      child: const CoachChatView(),
    );
  }
}

/// Vue principale du chat gérant l'affichage des messages et la saisie.
class CoachChatView extends StatefulWidget {
  const CoachChatView({super.key});

  @override
  State<CoachChatView> createState() => _CoachChatViewState();
}

class _CoachChatViewState extends State<CoachChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  // Clé pour le tutoriel guidant l'utilisateur sur la saisie
  final GlobalKey _inputKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Suivi analytique de l'ouverture de la page
    getIt<AnalyticsManager>().trackEvent(feature: 'AI Coach', action: 'view');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  /// Démarre le tutoriel si l'utilisateur découvre le Coach.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('coach')) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_inputKey]);
        tutorialService.markTutorialAsSeen('coach');
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    super.dispose();
  }

  /// Fait défiler la liste vers le bas pour afficher le dernier message.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.aiCoachChat,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.coachTitle);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.coachTitle,
            isUpdateRequired: true,
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.coachTitle),
                Text(
                  l10n.online,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () =>
                    context.read<CoachBloc>().add(ClearHistoryRequested()),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocConsumer<CoachBloc, CoachState>(
                  listener: (context, state) {
                    _scrollToBottom();
                  },
                  builder: (context, state) {
                    // Chargement initial
                    if (state.status == CoachStatus.loading &&
                        state.messages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // État vide (bienvenue)
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.coachWelcomeMessage,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount:
                          state.messages.length + (state.isSending ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Indicateur "Le coach réfléchit..."
                        if (index == state.messages.length) {
                          return _buildTypingIndicator();
                        }
                        final message = state.messages[index];
                        return _MessageBubble(message: message);
                      },
                    );
                  },
                ),
              ),
              // Zone de saisie mise en avant par le tutoriel le cas échéant
              Showcase(
                key: _inputKey,
                title: l10n.coachTitle,
                description: l10n.typeQuestionHint,
                child: _buildInputArea(context),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construit l'indicateur visuel lorsque le Coach génère une réponse.
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          AppLocalizations.of(context)!.coachThinking,
          style: AppTextStyles.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// Construit la barre de texte et le bouton d'envoi.
  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.typeQuestionHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  maxLines: 4,
                  minLines: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    getIt<AnalyticsManager>().trackEvent(
                      feature: 'AI Coach',
                      action: 'send_message',
                    );
                    context.read<CoachBloc>().add(
                      SendMessageRequested(_messageController.text),
                    );
                    _messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget représentant une bulle de message (Utilisateur ou Coach).
class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [
            if (!isUser)
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage du texte en Markdown (supporte gras, listes, liens)
            MarkdownBody(
              data: message.text,
              onTapLink: (text, href, title) {
                if (href != null) {
                  _launchUrl(href);
                }
              },
              styleSheet: MarkdownStyleSheet(
                p: AppTextStyles.bodyMedium.copyWith(
                  color: isUser
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                strong: AppTextStyles.bodyMedium.copyWith(
                  color: isUser
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Affichage des tuiles d'actions suggérées par l'IA
            if (!isUser &&
                message.actions != null &&
                message.actions!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.actions!.map((action) {
                  final label = action['label'] ?? 'Action';
                  return ElevatedButton(
                    onPressed: () => _handleAction(context, action),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(label, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 4),
            // Horodatage du message
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 10,
                color: isUser
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gère les interactions avec les boutons suggérés dans le message.
  void _handleAction(BuildContext context, Map<String, dynamic> action) {
    final type = action['type'];
    final payload = action['payload'];

    if (type == 'navigate' && payload != null) {
      var route = payload['route'] as String?;
      if (route != null) {
        if (!route.startsWith('/')) {
          route = '/$route';
        }
        context.go(route, extra: payload['params']);
      }
    } else if (type == 'url' && payload != null) {
      final url = payload['url'] ?? payload['route'];
      if (url != null) {
        _launchUrl(url);
      }
    }
  }

  /// Ouvre un lien externe vers le navigateur système.
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }
}
