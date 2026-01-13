import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/share_service.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';
import '../../data/models/goal_model.dart';
import '../../../budgets/presentation/bloc/budgets_bloc.dart';
import '../../../budgets/presentation/bloc/budgets_event.dart';
import '../../../transactions/presentation/bloc/transactions_bloc.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

class GoalDetailPage extends StatelessWidget {
  final String goalId;

  const GoalDetailPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
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
        final daysRemaining = goal.deadline.difference(DateTime.now()).inDays;
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
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
                _buildStrategySection(context, goal),
                const SizedBox(height: 32),
                _buildAutoSaveSection(context, goal),
                const SizedBox(height: 48),
                AppButton(
                  text: l10n.addSavingsAction,
                  onPressed: () async {
                    // Reset status to prevent immediate pop if coming from a previous success
                    context.read<TransactionsBloc>().add(
                      ResetTransactionsStatus(),
                    );

                    final refresh = await context.push<bool>(
                      '${RouteConstants.transactions}/add',
                      extra: goal.id,
                    );
                    getIt<AnalyticsManager>().trackEvent(
                      feature: 'Goals',
                      action: 'add_savings_click',
                      details: {'goal_id': goal.id},
                    );
                    if (refresh == true && context.mounted) {
                      // Refresh everything to ensure UI is in sync
                      context.read<TransactionsBloc>().add(
                        const GetTransactionsRequested(forceRefresh: true),
                      );
                      context.read<BudgetsBloc>().add(
                        const GetBudgetsRequested(forceRefresh: true),
                      );
                      context.read<GoalsBloc>().add(
                        const GetGoalsRequested(forceRefresh: true),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
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
              ).colorScheme.primary.withValues(alpha: 0.1),
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

  Widget _buildAmountSection(BuildContext context, GoalModel goal) {
    final l10n = AppLocalizations.of(context)!;
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
              goal.currency,
              Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            _buildAmountCard(
              context,
              l10n.targetAmountLabel,
              goal.targetAmount,
              goal.currency,
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
                '${amount.toStringAsFixed(0)} $currency',
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
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
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
              context.pop(); // Page
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
