import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/goal_share_sheet.dart';
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
import '../../../../core/mixins/secure_screen_mixin.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';

class GoalDetailPage extends StatefulWidget {
  final String goalId;

  const GoalDetailPage({super.key, required this.goalId});

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage>
    with WidgetsBindingObserver, SecureScreenMixin<GoalDetailPage> {
  String get goalId => widget.goalId;

  final GlobalKey _contributeKey = GlobalKey();
  bool _participantsFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTutorial());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTutorial());
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('goal_detail')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'goal_detail', [
        TutorialStep(
          targetKey: _contributeKey,
          title: l10n.tutorialGoalContributeTitle,
          description: l10n.tutorialGoalContributeDesc,
        ),
      ]);
    });
  }

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

            if (goal.isShared && !_participantsFetched) {
              _participantsFetched = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.read<GoalsBloc>().add(
                    GetGoalParticipantsRequested(goalId),
                  );
                }
              });
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
                BlocListener<GoalsBloc, GoalsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == GoalsStatus.deleteSuccess &&
                      !current.goals.any((g) => g.id == goalId),
                  listener: (context, state) {
                    Navigator.pop(context);
                  },
                ),
                BlocListener<GoalsBloc, GoalsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == GoalsStatus.leaveSuccess &&
                      !current.goals.any((g) => g.id == goalId),
                  listener: (context, state) {
                    Navigator.pop(context);
                  },
                ),
                BlocListener<GoalsBloc, GoalsState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status &&
                      current.status == GoalsStatus.error,
                  listener: (context, state) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? l10n.errorGoal),
                      ),
                    );
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
                        if (goal.isOwner) ...[
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              getIt<AnalyticsManager>().trackEvent(
                                feature: 'Goals',
                                action: 'share',
                                details: {'id': goal.id},
                              );
                              showGoalShareSheet(context, goal);
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
                          _buildHistorySection(
                            context,
                            goal,
                            state.participants,
                          ),
                          const SizedBox(height: 32),
                          _buildStrategySection(context, goal),
                          const SizedBox(height: 32),
                          _buildAutoSaveSection(context, goal),
                          if (goal.isShared) ...[
                            const SizedBox(height: 32),
                            GoalParticipantsSection(goal: goal),
                          ],
                          const SizedBox(height: 48),
                          KeyedSubtree(
                            key: _contributeKey,
                            child: AppButton(
                              text: goal.type == 'debt'
                                  ? l10n.repaymentAction
                                  : l10n.addSavingsAction,
                              onPressed: () =>
                                  _showContributionDialog(context, goal),
                            ),
                          ),
                          if (goal.currentAmount > 0 && goal.isOwner) ...[
                            const SizedBox(height: 12),
                            AppButton(
                              text: l10n.redeemAction,
                              color: AppColors.secondary,
                              onPressed: () => _showRedeemDialog(context, goal),
                            ),
                          ],
                          if (goal.isShared && !goal.isOwner) ...[
                            const SizedBox(height: 24),
                            Center(
                              child: TextButton(
                                onPressed: () =>
                                    showLeaveGoalConfirmation(context, goal),
                                child: Text(
                                  l10n.leaveGoal,
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
                    goal.emoji?.isNotEmpty == true ? goal.emoji! : '🎯',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            goal.name,
                            style: AppTextStyles.h3.copyWith(fontSize: 22),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (goal.isShared) ...[
                          const SizedBox(width: 8),
                          const GoalSharedBadge(),
                        ],
                      ],
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
          trailing: rules.enableSurplus
              ? l10n.surplusDayOfMonthValue(rules.dayOfMonth)
              : null,
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

  Widget _buildHistorySection(
    BuildContext context,
    GoalModel goal,
    List<GoalParticipantModel> participants,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (goal.contributions.isEmpty) return const SizedBox.shrink();
    final currentUserId = context.read<AuthBloc>().state.authResponse?.user.id;

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
            final isRedemption = contribution.type == 'redemption';
            final userCurrency =
                context.read<AuthBloc>().state.authResponse?.user.currency ??
                goal.currency;

            // Attribution : seulement pertinent pour un objectif partagé, où
            // plusieurs personnes peuvent contribuer (les retraits restent
            // réservés au propriétaire, mais on garde le même affichage).
            String? attribution;
            if (goal.isShared && contribution.userId != null) {
              if (contribution.userId == currentUserId) {
                attribution = l10n.contributionByYou;
              } else {
                final participant = participants.firstWhereOrNull(
                  (p) => p.userId == contribution.userId,
                );
                if (participant != null) {
                  attribution = l10n.contributionByLabel(
                    participant.displayName,
                  );
                }
              }
            }

            final accentColor = isRedemption
                ? AppColors.error
                : Theme.of(context).colorScheme.primary;

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
                      color: accentColor.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRedemption ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 20,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contribution.note ??
                              (isRedemption
                                  ? l10n.withdrawalLabel
                                  : l10n.contributionLabel),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          attribution != null
                              ? '${contribution.date.toIso8601String().split('T')[0]} · $attribution'
                              : contribution.date.toIso8601String().split(
                                  'T',
                                )[0],
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
                    '${isRedemption ? '-' : '+'} ${CurrencyHelper.formatAmount(contribution.amount, currencyCode: userCurrency)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isRedemption ? AppColors.error : AppColors.success,
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
    showDialog(
      context: context,
      builder: (dialogContext) => _RedeemDialog(goal: goal),
    );
  }

  void _showContributionDialog(BuildContext context, GoalModel goal) {
    showDialog(
      context: context,
      builder: (dialogContext) => _ContributionDialog(goal: goal),
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
              Navigator.pop(dialogContext); // Dialog only — la page se
              // ferme via le BlocListener une fois la suppression confirmée
              // par le serveur, pour ne pas donner l'illusion d'un succès
              // en cas d'échec réseau.
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

/// Boîte de dialogue de contribution — StatefulWidget dédié (plutôt que des
/// `TextEditingController` locaux à une fonction, disposés via `.then()` sur
/// le Future de `showDialog`) : `.then()` se déclenche dès que la route est
/// retirée de la pile, mais l'AlertDialog continue encore d'animer sa sortie
/// pendant quelques frames — disposer le contrôleur à ce moment-là fait
/// planter le champ encore affiché ("TextEditingController was used after
/// being disposed"). En le rattachant au cycle de vie réel du State, il
/// n'est disposé qu'une fois le widget effectivement retiré de l'arbre.
class _ContributionDialog extends StatefulWidget {
  final GoalModel goal;

  const _ContributionDialog({required this.goal});

  @override
  State<_ContributionDialog> createState() => _ContributionDialogState();
}

class _ContributionDialogState extends State<_ContributionDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goal = widget.goal;

    return AlertDialog(
      title: Text(
        goal.type == 'debt' ? l10n.repaymentDialogTitle : l10n.addGoalTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _amountController,
            label: l10n.amountLabel,
            hint: goal.type == 'debt'
                ? l10n.repaymentAmountHint
                : l10n.amountHint,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _noteController,
            label: l10n.noteLabel,
            hint: l10n.noteHint,
          ),
          const SizedBox(height: 12),
          Text(
            goal.type == 'debt'
                ? l10n.debtRepaymentWarningHint
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
            final amount = double.tryParse(_amountController.text);
            if (amount != null && amount > 0) {
              context.read<GoalsBloc>().add(
                UpdateGoalAmountRequested(
                  id: goal.id,
                  amount: amount,
                  note: _noteController.text.isNotEmpty
                      ? _noteController.text
                      : null,
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

/// Même raisonnement que `_ContributionDialog` ci-dessus pour le rachat.
class _RedeemDialog extends StatefulWidget {
  final GoalModel goal;

  const _RedeemDialog({required this.goal});

  @override
  State<_RedeemDialog> createState() => _RedeemDialogState();
}

class _RedeemDialogState extends State<_RedeemDialog> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.goal.currentAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goal = widget.goal;

    return AlertDialog(
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
            controller: _amountController,
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
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        AppButton(
          text: l10n.redeemConfirmAction,
          onPressed: () {
            final amount = double.tryParse(_amountController.text);
            if (amount != null && amount > 0 && amount <= goal.currentAmount) {
              context.read<GoalsBloc>().add(
                RedeemGoalRequested(id: goal.id, amount: amount),
              );
              Navigator.pop(context);
            } else if (amount != null && amount > goal.currentAmount) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.redeemAmountExceedsError)),
              );
            }
          },
        ),
      ],
    );
  }
}
