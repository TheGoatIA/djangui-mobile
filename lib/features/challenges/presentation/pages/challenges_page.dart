import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djangui/core/theme/app_colors.dart';
import 'package:djangui/core/theme/app_text_styles.dart';
import 'package:djangui/di/injection.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_bloc.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_event.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_state.dart';
import 'package:djangui/features/challenges/data/models/challenge_model.dart';
import 'package:djangui/features/challenges/presentation/widgets/challenge_detail_sheet.dart';
import 'package:djangui/l10n/app_localizations.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChallengesBloc>()
        ..add(const GetChallengesRequested())
        ..add(GetUserChallengesRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                  backgroundColor: AppColors.error,
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
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          state.errorMessage ??
                              AppLocalizations.of(context)!.genericError,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
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
                        color: AppColors.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noChallenges,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
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

                    return _ChallengeCard(
                      challenge: challenge,
                      userChallenge: userChallenge,
                    );
                  },
                ),
              );
            },
          ),
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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    challenge.type == 'saving'
                        ? Icons.savings
                        : Icons.shopping_bag,
                    color: AppColors.primary,
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
                          color: AppColors.textSecondary,
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
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.points(challenge.rewardPoints),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.amber[800],
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
                        ? AppColors.textSecondary
                        : _getDifficultyColor(challenge.difficulty),
                    fontWeight: isJoined ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                if (isJoined)
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: isJoined ? progress : 0,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
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
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      daysLeft > 0
                          ? AppLocalizations.of(
                              context,
                            )!.daysRemaining(daysLeft)
                          : AppLocalizations.of(context)!.finished,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (isJoined)
                  Text(
                    userChallenge?.status.toUpperCase() ?? '',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: userChallenge?.status == 'active'
                          ? Colors.blue
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    AppLocalizations.of(context)!.join,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
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
