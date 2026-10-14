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
import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';

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
    getIt<LogService>().info(
      'Affichage de la page Coach AI.',
      component: 'CoachChatPage',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  /// Démarre le tutoriel si l'utilisateur découvre le Coach.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('coach')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'coach', [
        TutorialStep(
          targetKey: _inputKey,
          title: l10n.tutorialCoachInputTitle,
          description: l10n.tutorialCoachInputDesc,
        ),
      ]);
    });
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
    getIt<TutorialService>().cancelActiveTutorial(context);
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
                onPressed: () {
                  getIt<LogService>().info(
                    'Action: Effacer historique Coach',
                    component: 'CoachChatPage',
                  );
                  context.read<CoachBloc>().add(ClearHistoryRequested());
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: MultiBlocListener(
                  listeners: [
                    // Défile vers le bas à CHAQUE changement d'état — y
                    // compris chaque fragment reçu en streaming — pas
                    // seulement sur une nouvelle erreur (voir le second
                    // listener ci-dessous, restreint lui à bon escient).
                    BlocListener<CoachBloc, CoachState>(
                      listener: (context, state) => _scrollToBottom(),
                    ),
                    BlocListener<CoachBloc, CoachState>(
                      listenWhen: (previous, current) =>
                          current.errorMessage != null &&
                          current.errorMessage != previous.errorMessage,
                      listener: (context, state) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                        );
                      },
                    ),
                  ],
                  child: BlocBuilder<CoachBloc, CoachState>(
                  builder: (context, state) {
                    // Chargement initial
                    if (state.status == CoachStatus.loading &&
                        state.messages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Échec du tout premier chargement (rien en cache, pas de
                    // réseau) : à distinguer du "pas encore de messages" —
                    // sinon un vrai échec ressemble à un simple écran de
                    // bienvenue, sans aucune indication qu'il faut réessayer.
                    if (state.status == CoachStatus.error &&
                        state.messages.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.errorMessage ?? l10n.genericError,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () => context
                                    .read<CoachBloc>()
                                    .add(GetChatHistoryRequested()),
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        ),
                      );
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

                    // Le placeholder de la bulle IA n'existe dans
                    // `state.messages` qu'à partir du premier fragment reçu
                    // (voir CoachBloc._sendAndStream) — tant qu'aucun texte
                    // n'est encore arrivé, on affiche l'indicateur "Anne
                    // réfléchit" à la place d'une bulle vide.
                    final showThinkingIndicator =
                        state.isSending && state.streamingMessageId == null;

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount:
                          state.messages.length +
                          (showThinkingIndicator ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return const _TypingIndicator();
                        }
                        final message = state.messages[index];
                        return _MessageBubble(
                          message: message,
                          isStreaming: message.id == state.streamingMessageId,
                        );
                      },
                    );
                  },
                  ),
                ),
              ),
              // Zone de saisie mise en avant par le tutoriel le cas échéant
              KeyedSubtree(
                key: _inputKey,
                child: _buildInputArea(context),
              ),
            ],
          ),
        );
      },
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
            BlocBuilder<CoachBloc, CoachState>(
              buildWhen: (previous, current) =>
                  previous.isSending != current.isSending,
              builder: (context, state) {
                return CircleAvatar(
                  backgroundColor: state.isSending
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.5)
                      : Theme.of(context).colorScheme.primary,
                  child: state.isSending
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : IconButton(
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
                              getIt<LogService>().info(
                                'Action: Envoi message Coach',
                                component: 'CoachChatPage',
                              );
                              _messageController.clear();
                            }
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicateur "Anne réfléchit..." affiché avant l'arrivée du tout premier
/// fragment de la réponse — trois points qui rebondissent en cascade, seul
/// signal visuel disponible tant que rien n'a encore été reçu du flux.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                // Décalage de phase par point pour l'effet de vague.
                final t = (_controller.value - (i * 0.2)) % 1.0;
                final bounce = (t < 0.5)
                    ? Curves.easeOut.transform(t * 2)
                    : Curves.easeIn.transform((1 - t) * 2);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Transform.translate(
                    offset: Offset(0, -4 * bounce),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

/// Curseur clignotant apposé après le texte d'un message en cours de
/// réception — seul indicateur, une fois le premier fragment arrivé, que la
/// réponse continue d'être générée.
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 3,
        height: 14,
        margin: const EdgeInsets.only(left: 2),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Widget représentant une bulle de message (Utilisateur ou Coach).
class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isStreaming;

  const _MessageBubble({required this.message, this.isStreaming = false});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';
    final isFailed = isUser && message.status == 'failed';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isFailed
              ? AppColors.error.withValues(alpha: 0.1)
              : (isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          border: isFailed
              ? Border.all(color: AppColors.error.withValues(alpha: 0.4))
              : null,
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
            // Affichage du texte en Markdown (supporte gras, listes, liens),
            // avec un curseur clignotant tant que la réponse arrive encore.
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: MarkdownBody(
                    data: message.text,
                    onTapLink: (text, href, title) {
                      if (href != null) {
                        _launchUrl(href);
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: AppTextStyles.bodyMedium.copyWith(
                        color: isFailed
                            ? Theme.of(context).colorScheme.onSurface
                            : (isUser
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface),
                      ),
                      strong: AppTextStyles.bodyMedium.copyWith(
                        color: isFailed
                            ? Theme.of(context).colorScheme.onSurface
                            : (isUser
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isStreaming) const _BlinkingCursor(),
              ],
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isFailed) ...[
                  Icon(Icons.error_outline, size: 12, color: AppColors.error),
                  const SizedBox(width: 4),
                ],
                // Horodatage du message
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    color: isFailed
                        ? AppColors.error
                        : (isUser
                              ? Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.7)
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            if (isFailed) ...[
              const SizedBox(height: 6),
              InkWell(
                onTap: () => context.read<CoachBloc>().add(
                  RetryMessageRequested(message.id),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 14, color: AppColors.error),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.retry,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
