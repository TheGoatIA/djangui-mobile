import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:djangui/core/theme/app_colors.dart';
import 'package:djangui/core/theme/app_text_styles.dart';
import 'package:djangui/di/injection.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_bloc.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_event.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_state.dart';
import 'package:djangui/features/challenges/data/models/challenge_model.dart';
import 'package:djangui/features/challenges/presentation/widgets/challenge_detail_sheet.dart';
import 'package:djangui/l10n/app_localizations.dart';
import 'package:djangui/core/theme/app_shadows.dart';

import 'package:showcaseview/showcaseview.dart';
import 'package:djangui/core/services/tutorial_service.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChallengesBloc>()
        ..add(const GetChallengesRequested())
        ..add(GetUserChallengesRequested()),
      child: const ChallengesView(),
    );
  }
}

class ChallengesView extends StatefulWidget {
  const ChallengesView({super.key});

  @override
  State<ChallengesView> createState() => _ChallengesViewState();
}

class _ChallengesViewState extends State<ChallengesView> {
  final GlobalKey _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
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

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('challenges')) {
      try {
        final shell = StatefulNavigationShell.of(context);
        if (shell.currentIndex != 1) return;
      } catch (_) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_listKey]);
        tutorialService.markTutorialAsSeen('challenges');
      });
    }
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.challengesTitle),
      ),
      body: BlocListener<ChallengesBloc, ChallengesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ChallengesStatus.error &&
              state.errorMessage != null &&
              state.challenges.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<ChallengesBloc, ChallengesState>(
          builder: (context, state) {
            if (state.status == ChallengesStatus.loading &&
                state.challenges.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ChallengesStatus.error &&
                state.challenges.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        state.errorMessage ??
                            AppLocalizations.of(context)!.genericError,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChallengesBloc>().add(
                          const GetChallengesRequested(forceRefresh: true),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            }

            if (state.challenges.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noChallenges,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChallengesBloc>()
                  ..add(const GetChallengesRequested(forceRefresh: true))
                  ..add(GetUserChallengesRequested());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.challenges.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final challenge = state.challenges[index];
                  // Find if user is participating in this challenge
                  final userChallenge = state.userChallenges
                      .where((uc) => uc.challengeId?.id == challenge.id)
                      .firstOrNull;

                  final widget = _ChallengeCard(
                    challenge: challenge,
                    userChallenge: userChallenge,
                  );

                  if (index == 0) {
                    return Showcase(
                      key: _listKey,
                      title: AppLocalizations.of(
                        context,
                      )!.tutorialChallengesTitle,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialChallengesDesc,
                      child: widget,
                    );
                  }

                  return widget;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final UserChallengeModel? userChallenge;

  const _ChallengeCard({required this.challenge, this.userChallenge});

  void _showChallengeDetails(BuildContext context) {
    final challengesBloc = context.read<ChallengesBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: challengesBloc,
        child: ChallengeDetailSheet(
          challenge: challenge,
          userChallenge: userChallenge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isJoined = userChallenge != null;
    final double progress = userChallenge?.progress ?? 0.0;
    final daysLeft = challenge.durationDays;

    return InkWell(
      onTap: () => _showChallengeDetails(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    challenge.type == 'saving'
                        ? Icons.savings
                        : Icons.shopping_bag,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        challenge.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.points(challenge.rewardPoints),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isJoined
                      ? AppLocalizations.of(context)!.progress
                      : _getLocalizedDifficulty(
                          context,
                          challenge.difficulty,
                        ).toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isJoined
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : _getDifficultyColor(challenge.difficulty),
                    fontWeight: isJoined ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                if (isJoined)
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: isJoined ? progress : 0,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      daysLeft > 0
                          ? AppLocalizations.of(
                              context,
                            )!.daysRemaining(daysLeft)
                          : AppLocalizations.of(context)!.finished,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (isJoined)
                  Text(
                    userChallenge?.status.toUpperCase() ?? '',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: userChallenge?.status == 'active'
                          ? AppColors.info
                          : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    AppLocalizations.of(context)!.join,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedDifficulty(BuildContext context, String difficulty) {
    final l10n = AppLocalizations.of(context)!;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return l10n.easyDifficulty;
      case 'medium':
        return l10n.mediumDifficulty;
      case 'hard':
        return l10n.hardDifficulty;
      default:
        return difficulty;
    }
  }
}
