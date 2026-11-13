import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:kauri/features/challenges/presentation/bloc/challenges_bloc.dart';
import 'package:kauri/features/challenges/presentation/bloc/challenges_event.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/challenges/presentation/bloc/challenges_state.dart';
import 'package:kauri/core/utils/currency_helper.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_event.dart';

class ChallengeDetailSheet extends StatefulWidget {
  final ChallengeModel challenge;
  final UserChallengeModel? userChallenge;

  const ChallengeDetailSheet({
    super.key,
    required this.challenge,
    this.userChallenge,
  });

  @override
  State<ChallengeDetailSheet> createState() => _ChallengeDetailSheetState();
}

class _ChallengeDetailSheetState extends State<ChallengeDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final bool isJoined = widget.userChallenge != null;
    final bool isCompleted = widget.userChallenge?.status == 'completed';
    final double rawProgress = widget.userChallenge?.progress ?? 0.0;
    // Normalize progress to 0.0-1.0 range (some backends send 0-100)
    final double progress = rawProgress > 1.0
        ? rawProgress / 100.0
        : rawProgress;

    // Find if there's a pending week to validate
    final pendingWeek = widget.userChallenge?.weeks
        ?.cast<ChallengeWeekModel?>()
        .firstWhere((w) => w?.status == 'pending', orElse: () => null);
    final bool hasPendingWeek = pendingWeek != null;

    // Calculate current week index based on time
    final int currentWeekFromTime = widget.userChallenge?.createdAt != null
        ? (DateTime.now().difference(widget.userChallenge!.createdAt!).inDays /
                      7)
                  .floor() +
              1
        : 1;

    // A week is ready only if it's pending AND it's the current time-frame or past (catch up)
    final bool isWeekReadyToValidate =
        hasPendingWeek && pendingWeek.weekNumber <= currentWeekFromTime;

    // Days until next week starts
    final int? daysUntilNextWeek =
        widget.userChallenge?.createdAt != null &&
            !isWeekReadyToValidate &&
            hasPendingWeek
        ? 7 -
              (DateTime.now()
                      .difference(widget.userChallenge!.createdAt!)
                      .inDays %
                  7)
        : null;

    return BlocListener<ChallengesBloc, ChallengesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ChallengesStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state.status == ChallengesStatus.success) {
          // Refresh both balance and transactions after success
          final fintechBloc = context.read<FintechBloc>();
          fintechBloc.add(FetchWalletBalance());
          fintechBloc.add(FetchWalletTransactions());
          Navigator.of(context).pop(); // Close sheet on success
        }
      },
      child: BlocBuilder<ChallengesBloc, ChallengesState>(
        builder: (context, state) {
          final isLoading = state.status == ChallengesStatus.loading;

          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            tooltip: AppLocalizations.of(context)!.close,
                          ),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 48), // Balancing the IconButton
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              widget.challenge.type == 'saving'
                                  ? Icons.savings
                                  : Icons.shopping_bag,
                              color: Theme.of(context).colorScheme.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.challenge.title,
                                  style: AppTextStyles.h3.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _getLocalizedType(
                                    context,
                                    widget.challenge.type,
                                  ).toUpperCase(),
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                        widget.challenge.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                            )!.daysCount(widget.challenge.durationDays),
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 12),
                          _InfoCard(
                            icon: Icons.star_outline,
                            label: AppLocalizations.of(context)!.reward,
                            value: AppLocalizations.of(
                              context,
                            )!.points(widget.challenge.rewardPoints),
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          _InfoCard(
                            icon: Icons.trending_up,
                            label: AppLocalizations.of(context)!.difficulty,
                            value: _getLocalizedDifficulty(
                              context,
                              widget.challenge.difficulty,
                            ).toUpperCase(),
                            color: _getDifficultyColor(
                              widget.challenge.difficulty,
                            ),
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
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.percentCompleted(
                              (progress * 100).toStringAsFixed(0),
                            ),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _WeeklyTargetCard(
                          weekNumber: pendingWeek?.weekNumber ?? 0,
                          amount: pendingWeek?.targetAmount ?? 0,
                          isReady: isWeekReadyToValidate,
                          nextInDays: daysUntilNextWeek,
                        ),
                        const SizedBox(height: 16),
                        if (widget.userChallenge?.flexibility != null &&
                            !isCompleted)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed:
                                      (widget
                                              .userChallenge!
                                              .flexibility!
                                              .skipsUsed <
                                          widget
                                              .userChallenge!
                                              .flexibility!
                                              .maxSkips)
                                      ? () => _showSkipConfirmation(context)
                                      : null,
                                  icon: const Icon(Icons.fast_forward),
                                  label: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.challengeSkipAction,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _showPostponeConfirmation(context),
                                  icon: const Icon(Icons.hourglass_empty),
                                  label: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.challengePostponeAction,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.historyLabel,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (widget.userChallenge?.weeks != null)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: widget.userChallenge!.weeks!
                                      .where(
                                        (w) =>
                                            w.status == 'completed' ||
                                            w.status == 'skipped' ||
                                            w.status == 'validated',
                                      )
                                      .map(
                                        (w) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                w.status == 'completed' ||
                                                        w.status == 'validated'
                                                    ? Icons.check_circle
                                                    : Icons.fast_forward,
                                                color:
                                                    w.status == 'completed' ||
                                                        w.status == 'validated'
                                                    ? AppColors.success
                                                    : AppColors.info,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.weekNumberLabel(
                                                  w.weekNumber,
                                                ),
                                                style: AppTextStyles.bodyMedium,
                                              ),
                                              const Spacer(),
                                              Text(
                                                CurrencyHelper.formatAmount(
                                                  w.savedAmount,
                                                  currencyCode: context
                                                      .read<AuthBloc>()
                                                      .state
                                                      .authResponse
                                                      ?.user
                                                      .currency,
                                                ),
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (!isJoined) {
                                    getIt<AnalyticsManager>().trackEvent(
                                      feature: 'Challenges',
                                      action: 'join',
                                      details: {
                                        'challenge_title':
                                            widget.challenge.title,
                                      },
                                    );
                                    context.read<ChallengesBloc>().add(
                                      JoinChallengeRequested(
                                        widget.challenge.id,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (isCompleted &&
                                      widget.userChallenge?.status !=
                                          'redeemed') {
                                    context.read<ChallengesBloc>().add(
                                      RedeemChallengeRequested(
                                        widget.userChallenge!.id,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (!isCompleted &&
                                      isWeekReadyToValidate) {
                                    _showValidationDialog(
                                      context,
                                      widget.userChallenge!,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isJoined
                                ? (isCompleted
                                      ? (widget.userChallenge?.status ==
                                                'redeemed'
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.outline
                                            : AppColors.success)
                                      : (isWeekReadyToValidate
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.secondary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.outline))
                                : Theme.of(context).colorScheme.primary,
                            foregroundColor: isJoined && isCompleted
                                ? Theme.of(context).colorScheme.onPrimary
                                : (isJoined && !isWeekReadyToValidate
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onPrimary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            isJoined
                                ? (isCompleted
                                      ? (widget.userChallenge?.status ==
                                                'redeemed'
                                            ? "DÉJÀ RÉCUPÉRÉ"
                                            : "RETIRER LES FONDS")
                                      : AppLocalizations.of(
                                          context,
                                        )!.validateWeek.toUpperCase())
                                : AppLocalizations.of(
                                    context,
                                  )!.startChallenge.toUpperCase(),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (isJoined) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _showUnjoinConfirmationDialog(
                                context,
                                widget.userChallenge!.id,
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.unjoinChallenge,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
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
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Challenges',
                action: 'unjoin',
              );
              challengesBloc.add(UnjoinChallengeRequested(challengeId));
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close sheet
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
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
        return l10n.challengeTypeSaving;
      case 'spending_cut':
      case 'spending':
        return l10n.challengeTypeSpending;
      case 'habit':
        return l10n.challengeTypeHabit;
      default:
        return type;
    }
  }

  void _showSkipConfirmation(BuildContext context) {
    final bloc = context.read<ChallengesBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.challengeSkipAction),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.challengeSkipConfirm),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.challengeSkipsRemaining(
                widget.userChallenge!.flexibility!.maxSkips -
                    widget.userChallenge!.flexibility!.skipsUsed,
              ),
              style: AppTextStyles.labelSmall.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final pendingWeek = widget.userChallenge?.weeks?.firstWhere(
                (w) => w.status == 'pending',
                orElse: () => widget.userChallenge!.weeks!.first,
              );
              if (pendingWeek != null) {
                bloc.add(
                  SkipWeekRequested(
                    widget.userChallenge!.id,
                    pendingWeek.weekNumber,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  void _showPostponeConfirmation(BuildContext context) {
    final bloc = context.read<ChallengesBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.challengePostponeAction),
        content: Text(AppLocalizations.of(context)!.challengePostponeConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final pendingWeek = widget.userChallenge?.weeks?.firstWhere(
                (w) => w.status == 'pending',
                orElse: () => widget.userChallenge!.weeks!.first,
              );
              if (pendingWeek != null) {
                bloc.add(
                  PostponeDeadlineRequested(
                    widget.userChallenge!.id,
                    pendingWeek.weekNumber,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
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
        scrollable: true,
        title: Text(AppLocalizations.of(context)!.validateWeekTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                          CurrencyHelper.formatAmount(
                            pendingWeek.targetAmount,
                            currencyCode: context
                                .read<AuthBloc>()
                                .state
                                .authResponse
                                ?.user
                                .currency,
                          ),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                suffixText:
                    context
                        .read<AuthBloc>()
                        .state
                        .authResponse
                        ?.user
                        .currency ??
                    'XAF',
                hintText: pendingWeek.targetAmount.toStringAsFixed(0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.challengeAutoDebitNotice,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
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
                        userChallengeId: widget.userChallenge!.id,
                        weekNumber: pendingWeek.weekNumber,
                        amount: amount,
                        note:
                            "", // We could add a note field in the UI if needed
                      ),
                    );
                    getIt<AnalyticsManager>().trackEvent(
                      feature: 'Challenges',
                      action: 'validate_week',
                      details: {
                        'week': pendingWeek.weekNumber,
                        'amount': amount,
                      },
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
        scrollable: true,
        title: Text(AppLocalizations.of(context)!.confirmValidationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(
                context,
              )!.confirmValidationMessage(amount.toStringAsFixed(0)),
            ),
          ],
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
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              (isReady
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline)
                  .withValues(alpha: 0.1),
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
                  color: isReady
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
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
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.daysRemaining(nextInDays!),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.warning,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    CurrencyHelper.formatAmount(
                      amount,
                      currencyCode: context
                          .read<AuthBloc>()
                          .state
                          .authResponse
                          ?.user
                          .currency,
                    ),
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isReady
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                isReady ? Icons.pending_actions : Icons.lock_clock_outlined,
                color: isReady
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
