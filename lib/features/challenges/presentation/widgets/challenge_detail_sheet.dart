import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djangui/core/theme/app_colors.dart';
import 'package:djangui/core/theme/app_text_styles.dart';
import 'package:djangui/l10n/app_localizations.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_bloc.dart';
import 'package:djangui/features/challenges/presentation/bloc/challenges_event.dart';
import 'package:djangui/features/challenges/data/models/challenge_model.dart';

class ChallengeDetailSheet extends StatelessWidget {
  final ChallengeModel challenge;
  final UserChallengeModel? userChallenge;

  const ChallengeDetailSheet({
    super.key,
    required this.challenge,
    this.userChallenge,
  });

  @override
  Widget build(BuildContext context) {
    final bool isJoined = userChallenge != null;
    final bool isCompleted = userChallenge?.status == 'completed';
    final double progress = userChallenge?.progress ?? 0.0;

    // Find if there's a pending week to validate
    final pendingWeek = userChallenge?.weeks
        ?.cast<ChallengeWeekModel?>()
        .firstWhere((w) => w?.status == 'pending', orElse: () => null);
    final bool hasPendingWeek = pendingWeek != null;

    // Calculate current week index based on time
    final int currentWeekFromTime = userChallenge?.createdAt != null
        ? (DateTime.now().difference(userChallenge!.createdAt!).inDays / 7)
                  .floor() +
              1
        : 1;

    // A week is ready only if it's pending AND it's the current time-frame or past (catch up)
    final bool isWeekReadyToValidate =
        hasPendingWeek && pendingWeek.weekNumber <= currentWeekFromTime;

    // Days until next week starts
    final int? daysUntilNextWeek =
        userChallenge?.createdAt != null &&
            !isWeekReadyToValidate &&
            hasPendingWeek
        ? 7 - (DateTime.now().difference(userChallenge!.createdAt!).inDays % 7)
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  challenge.type == 'saving'
                      ? Icons.savings
                      : Icons.shopping_bag,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getLocalizedType(context, challenge.type).toUpperCase(),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.description,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _InfoCard(
                icon: Icons.timer_outlined,
                label: AppLocalizations.of(context)!.duration,
                value: AppLocalizations.of(
                  context,
                )!.daysCount(challenge.durationDays),
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _InfoCard(
                icon: Icons.star_outline,
                label: AppLocalizations.of(context)!.reward,
                value: AppLocalizations.of(
                  context,
                )!.points(challenge.rewardPoints),
                color: Colors.amber,
              ),
              const SizedBox(width: 12),
              _InfoCard(
                icon: Icons.trending_up,
                label: AppLocalizations.of(context)!.difficulty,
                value: _getLocalizedDifficulty(
                  context,
                  challenge.difficulty,
                ).toUpperCase(),
                color: _getDifficultyColor(challenge.difficulty),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (isJoined) ...[
            Text(
              AppLocalizations.of(context)!.yourProgress,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.percentCompleted((progress * 100).toStringAsFixed(0)),
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!isCompleted) ...[
              _WeeklyTargetCard(
                weekNumber: pendingWeek?.weekNumber ?? 0,
                amount: pendingWeek?.targetAmount ?? 0,
                isReady: isWeekReadyToValidate,
                nextInDays: daysUntilNextWeek,
              ),
              const SizedBox(height: 24),
            ],
          ],
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (!isJoined) {
                  context.read<ChallengesBloc>().add(
                    JoinChallengeRequested(challenge.id),
                  );
                  Navigator.pop(context);
                } else if (challenge.type == 'saving' &&
                    !isCompleted &&
                    isWeekReadyToValidate) {
                  _showValidationDialog(context, userChallenge!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isJoined
                    ? (isCompleted
                          ? Colors.green
                          : (isWeekReadyToValidate
                                ? AppColors.secondary
                                : AppColors.outline))
                    : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isJoined
                    ? (isCompleted
                          ? AppLocalizations.of(
                              context,
                            )!.completed.toUpperCase()
                          : AppLocalizations.of(
                              context,
                            )!.validateWeek.toUpperCase())
                    : AppLocalizations.of(
                        context,
                      )!.startChallenge.toUpperCase(),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isJoined) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  _showUnjoinConfirmationDialog(context, userChallenge!.id);
                },
                child: Text(
                  AppLocalizations.of(context)!.unjoinChallenge,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showUnjoinConfirmationDialog(BuildContext context, String challengeId) {
    final challengesBloc = context.read<ChallengesBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.unjoinConfirmationTitle),
        content: Text(AppLocalizations.of(context)!.unjoinConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              challengesBloc.add(UnjoinChallengeRequested(challengeId));
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close sheet
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.unjoinAction),
          ),
        ],
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

  String _getLocalizedType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'saving':
        return l10n.savingType;
      case 'spending':
        return l10n.spendingType;
      default:
        return type;
    }
  }

  void _showValidationDialog(
    BuildContext context,
    UserChallengeModel userChallenge,
  ) {
    final challengesBloc = context.read<ChallengesBloc>();
    final TextEditingController controller = TextEditingController();

    // Find first pending week
    final pendingWeek = userChallenge.weeks?.firstWhere(
      (w) => w.status == 'pending',
      orElse: () => userChallenge.weeks!.first,
    );

    if (pendingWeek == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.validateWeekTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.amountToContribute,
                          style: AppTextStyles.labelSmall,
                        ),
                        Text(
                          '${pendingWeek.targetAmount.toStringAsFixed(0)} XAF',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${AppLocalizations.of(context)!.week} ${pendingWeek.weekNumber}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.enterAmountSaved),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                suffixText: 'XAF',
                hintText: pendingWeek.targetAmount.toStringAsFixed(0),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final double? amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                // Show final confirmation
                _showConfirmSubmitDialog(
                  context,
                  amount,
                  pendingWeek.weekNumber,
                  () {
                    challengesBloc.add(
                      ValidateWeekRequested(
                        userChallengeId: userChallenge.id,
                        weekNumber: pendingWeek.weekNumber,
                        amount: amount,
                      ),
                    );
                    Navigator.pop(dialogContext); // Close entry dialog
                    Navigator.pop(context); // Close sheet
                  },
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  void _showConfirmSubmitDialog(
    BuildContext context,
    double amount,
    int weekNumber,
    VoidCallback onConfirmed,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmValidationTitle),
        content: Text(
          AppLocalizations.of(
            context,
          )!.confirmValidationMessage(amount.toStringAsFixed(0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close confirmation
              onConfirmed();
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }
}

class _WeeklyTargetCard extends StatelessWidget {
  final int weekNumber;
  final double amount;
  final bool isReady;
  final int? nextInDays;

  const _WeeklyTargetCard({
    required this.weekNumber,
    required this.amount,
    required this.isReady,
    this.nextInDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isReady
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isReady ? AppColors.primary : Colors.grey).withValues(
            alpha: 0.1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.week} $weekNumber',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isReady ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isReady && nextInDays != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.daysRemaining(nextInDays!),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.amountToContribute,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${amount.toStringAsFixed(0)} XAF',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isReady
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                isReady ? Icons.pending_actions : Icons.lock_clock_outlined,
                color: isReady ? AppColors.primary : AppColors.outline,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
