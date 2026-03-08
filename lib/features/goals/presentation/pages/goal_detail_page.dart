import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/share_service.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';
import '../../data/models/goal_model.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/core/services/success_animation_service.dart';
import 'package:kauri/core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../payments/presentation/bloc/fintech_bloc.dart';
import '../../../payments/presentation/bloc/fintech_event.dart';

class GoalDetailPage extends StatelessWidget {
  final String goalId;

  const GoalDetailPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featGoals,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.goals);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.goals,
            isUpdateRequired: true,
          );
        }
        return BlocBuilder<GoalsBloc, GoalsState>(
          builder: (context, state) {
            final goal = state.goals.firstWhere(
              (g) => g.id == goalId,
              orElse: () => GoalModel(
                id: '',
                name: 'Not Found',
                targetAmount: 0,
                currentAmount: 0,
                deadline: DateTime.now(),
                createdAt: DateTime.now(),
              ),
            );

            if (goal.id.isEmpty) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(child: Text('Goal not found')),
              );
            }

            final progress = (goal.currentAmount / goal.targetAmount).clamp(
              0.0,
              1.0,
            );
            final daysRemaining = goal.deadline
                .difference(DateTime.now())
                .inDays;
            final l10n = AppLocalizations.of(context)!;

            return MultiBlocListener(
              listeners: [
                BlocListener<GoalsBloc, GoalsState>(
                  listenWhen: (previous, current) {
                    final prevGoal = previous.goals.firstWhere(
                      (g) => g.id == goalId,
                      orElse: () => goal,
                    );
                    final currGoal = current.goals.firstWhere(
                      (g) => g.id == goalId,
                      orElse: () => goal,
                    );
                    return (currGoal.currentAmount / currGoal.targetAmount) >=
                            1.0 &&
                        (prevGoal.currentAmount / prevGoal.targetAmount) < 1.0;
                  },
                  listener: (context, state) {
                    final isPremium =
                        context
                            .read<AuthBloc>()
                            .state
                            .authResponse
                            ?.user
                            .isPremium ??
                        false;
                    if (isPremium) {
                      getIt<SuccessAnimationService>().showSuccess();
                    }
                  },
                ),
                BlocListener<GoalsBloc, GoalsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == GoalsStatus.redeemSuccess,
                  listener: (context, state) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.redeemSuccess),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    // Refresh auth (balance) and wallet as money was recovered
                    context.read<AuthBloc>().add(AuthRefreshUserRequested());
                    context.read<FintechBloc>().add(FetchWalletBalance());
                  },
                ),
                BlocListener<GoalsBloc, GoalsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == GoalsStatus.contributionSuccess,
                  listener: (context, state) {
                    // Refresh balance on contribution success
                    context.read<AuthBloc>().add(AuthRefreshUserRequested());
                    context.read<FintechBloc>().add(FetchWalletBalance());
                  },
                ),
              ],
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    appBar: AppBar(
                      title: Text(goal.name),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            getIt<AnalyticsManager>().trackEvent(
                              feature: 'Goals',
                              action: 'share',
                              details: {'id': goal.id},
                            );
                            getIt<ShareService>().shareGoal(goal);
                          },
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteDialog(context, goal);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                l10n.delete,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, goal, progress, daysRemaining),
                          const SizedBox(height: 32),
                          _buildAmountSection(context, goal),
                          const SizedBox(height: 32),
                          _buildHistorySection(context, goal),
                          const SizedBox(height: 32),
                          _buildStrategySection(context, goal),
                          const SizedBox(height: 32),
                          _buildAutoSaveSection(context, goal),
                          const SizedBox(height: 48),
                          AppButton(
                            text: goal.type == 'debt'
                                ? l10n.repaymentAction
                                : l10n.addSavingsAction,
                            onPressed: () =>
                                _showContributionDialog(context, goal),
                          ),
                          if (goal.currentAmount > 0) ...[
                            const SizedBox(height: 12),
                            AppButton(
                              text: l10n.redeemAction,
                              color: AppColors.secondary,
                              onPressed: () => _showRedeemDialog(context, goal),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  getIt<SuccessAnimationService>().buildConfettiWidget(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    GoalModel goal,
    double progress,
    int daysRemaining,
  ) {
    if (goal.type == 'debt') {
      return _buildDebtBurner(context, goal, progress);
    }

    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    goal.emoji ?? '🎯',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: AppTextStyles.h3.copyWith(fontSize: 22),
                    ),
                    Text(
                      goal.type == 'regular'
                          ? l10n.savingsType
                          : goal.type == 'project'
                          ? l10n.investmentType
                          : goal.type == 'emergency'
                          ? l10n.emergencyType
                          : goal.type,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                ),
              ),
              Text(
                daysRemaining > 0
                    ? l10n.daysRemaining(daysRemaining)
                    : l10n.deadlinePassed,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(25),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtBurner(
    BuildContext context,
    GoalModel goal,
    double progress,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              goal.emoji?.isNotEmpty == true ? goal.emoji! : '🛡️',
              style: const TextStyle(fontSize: 48),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              // Total Debt Base (Grey)
              SizedBox(
                height: 220,
                width: 220,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 14,
                  backgroundColor: Theme.of(context).colorScheme.outline,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              // Remaining Debt (Red/Orange)
              SizedBox(
                height: 220,
                width: 220,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 14,
                  color: AppColors.error,
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Repaid Part (Blue/Gold - This "eats" the red)
              SizedBox(
                height: 220,
                width: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 16,
                  color: AppColors.secondary,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.completed.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.debtType.toUpperCase(),
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context, GoalModel goal) {
    final l10n = AppLocalizations.of(context)!;
    final userCurrency =
        context.read<AuthBloc>().state.authResponse?.user.currency ??
        goal.currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.amountLabel, style: AppTextStyles.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildAmountCard(
              context,
              l10n.currentAmountLabel,
              goal.currentAmount,
              userCurrency,
              Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            _buildAmountCard(
              context,
              l10n.targetAmountLabel,
              goal.targetAmount,
              userCurrency,
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountCard(
    BuildContext context,
    String label,
    double amount,
    String currency,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                CurrencyHelper.formatAmount(amount, currencyCode: currency),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategySection(BuildContext context, GoalModel goal) {
    final l10n = AppLocalizations.of(context)!;
    String strategyName = '';
    String strategyDesc = '';

    switch (goal.strategy.type) {
      case '50-30-20':
        strategyName = l10n.strategy_50_30_20;
        strategyDesc = l10n.strategy_50_30_20_desc;
        break;
      case 'progressive':
        strategyName = l10n.strategy_progressive;
        strategyDesc = l10n.strategy_progressive_desc;
        break;
      case 'roundup':
        strategyName = l10n.strategy_roundup;
        strategyDesc = l10n.strategy_roundup_desc;
        break;
      case 'pay-yourself-first':
        strategyName = l10n.strategy_pay_yourself_first;
        strategyDesc = l10n.strategy_pay_yourself_first_desc;
        break;
      case 'envelope':
        strategyName = l10n.strategy_envelope;
        strategyDesc = l10n.strategy_envelope_desc;
        break;
      default:
        strategyName = l10n.strategy_custom;
        strategyDesc = l10n.strategy_custom_desc;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.strategyLabel,
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.psychology,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategyName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strategyDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoSaveSection(BuildContext context, GoalModel goal) {
    final l10n = AppLocalizations.of(context)!;
    if (goal.autoSaveRules == null) return const SizedBox.shrink();

    final rules = goal.autoSaveRules!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.autoSaveRulesTitle,
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildRuleItem(
          context,
          Icons.arrow_upward,
          l10n.enableSurplusLabel,
          rules.enableSurplus,
        ),
        const SizedBox(height: 12),
        _buildRuleItem(
          context,
          Icons.exposure_plus_1,
          l10n.enableRoundupLabel,
          rules.enableRoundup,
        ),
        const SizedBox(height: 12),
        _buildRuleItem(
          context,
          Icons.percent,
          l10n.percentageIncomeLabel,
          rules.percentageIncome > 0,
          trailing: rules.percentageIncome > 0
              ? '${rules.percentageIncome.toStringAsFixed(0)}%'
              : null,
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, GoalModel goal) {
    final l10n = AppLocalizations.of(context)!;
    if (goal.contributions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.historyLabel, style: AppTextStyles.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goal.contributions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final contribution = goal.contributions[index];
            final userCurrency =
                context.read<AuthBloc>().state.authResponse?.user.currency ??
                goal.currency;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.history,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contribution.note ?? l10n.contributionLabel,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          contribution.date.toIso8601String().split('T')[0],
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+ ${CurrencyHelper.formatAmount(contribution.amount, currencyCode: userCurrency)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRuleItem(
    BuildContext context,
    IconData icon,
    String label,
    bool enabled, {
    String? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: enabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          else
            Icon(
              enabled ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
        ],
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, GoalModel goal) {
    final amountController = TextEditingController(
      text: goal.currentAmount.toStringAsFixed(0),
    );
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.redeemDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.redeemAmountHint, style: AppTextStyles.bodySmall),
            const SizedBox(height: 16),
            if (DateTime.now().isBefore(goal.deadline)) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.earlyRedemptionWarning(
                          goal.deadline.toLocal().toString().split(' ')[0],
                        ),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            AppTextField(
              controller: amountController,
              label: l10n.amountLabel,
              hint: l10n.redeemAmountLabel,
              keyboardType: TextInputType.number,
              suffix: Text(goal.currency),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.redeemAvailableAmount(
                CurrencyHelper.formatAmount(
                  goal.currentAmount,
                  currencyCode: goal.currency,
                ),
              ),
              style: AppTextStyles.labelSmall.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          AppButton(
            text: l10n.redeemConfirmAction,
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null &&
                  amount > 0 &&
                  amount <= goal.currentAmount) {
                context.read<GoalsBloc>().add(
                  RedeemGoalRequested(id: goal.id, amount: amount),
                );
                Navigator.pop(dialogContext);
              } else if (amount != null && amount > goal.currentAmount) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.redeemAmountExceedsError)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showContributionDialog(BuildContext context, GoalModel goal) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          goal.type == 'debt' ? l10n.repaymentDialogTitle : l10n.addGoalTitle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: amountController,
              label: l10n.amountLabel,
              hint: goal.type == 'debt'
                  ? l10n.repaymentAmountHint
                  : l10n.amountHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: noteController,
              label: l10n.noteLabel,
              hint: l10n.noteHint,
            ),
            const SizedBox(height: 12),
            Text(
              goal.type == 'debt'
                  ? "Note : Cette action débitera votre solde Kauri immédiatement."
                  : l10n.goalForcedExpenseHint,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          AppButton(
            text: l10n.confirm,
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                context.read<GoalsBloc>().add(
                  UpdateGoalAmountRequested(
                    id: goal.id,
                    amount: amount,
                    note: noteController.text.isNotEmpty
                        ? noteController.text
                        : null,
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, GoalModel goal) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteGoalConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Goals',
                action: 'delete_success',
                details: {'id': goal.id},
              );
              context.read<GoalsBloc>().add(DeleteGoalRequested(goal.id));
              Navigator.pop(dialogContext); // Dialog
              Navigator.pop(context); // Page
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
