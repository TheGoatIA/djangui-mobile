import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:kauri/features/budgets/data/models/budget_model.dart';
import 'package:kauri/core/utils/currency_helper.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kauri/features/budgets/presentation/pages/add_budget_page.dart';
import 'package:kauri/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:kauri/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:kauri/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:kauri/features/goals/presentation/bloc/goals_bloc.dart';

class BudgetDetailSheet extends StatefulWidget {
  final BudgetModel budget;

  const BudgetDetailSheet({super.key, required this.budget});

  @override
  State<BudgetDetailSheet> createState() => _BudgetDetailSheetState();
}

class _BudgetDetailSheetState extends State<BudgetDetailSheet> {
  String? _selectedHistoryCategory;

  @override
  void initState() {
    super.initState();
    if (widget.budget.isShared) {
      context.read<BudgetsBloc>().add(
        GetBudgetParticipantsRequested(widget.budget.id),
      );
    }
    if (widget.budget.categories.isNotEmpty) {
      _selectedHistoryCategory = widget.budget.categories.first.name;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadHistory(_selectedHistoryCategory!);
      });
    }
  }

  void _loadHistory(String category) {
    context.read<BudgetsBloc>().add(
      GetCategoryHistoryRequested(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final budget = widget.budget;
    final double totalProgress = budget.totalAllocated > 0
        ? (budget.totalSpent / budget.totalAllocated).clamp(0.0, 1.0)
        : 0.0;
    final bool isOverBudget = budget.totalSpent > budget.totalAllocated;
    final Color mainColor = isOverBudget
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    final linkedGoal = budget.linkedGoalId == null
        ? null
        : context.watch<GoalsBloc>().state.goals.firstWhereOrNull(
            (g) => g.id == budget.linkedGoalId,
          );

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                l10n.budgetDetails,
                                style: AppTextStyles.h3.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (budget.isShared) ...[
                              const SizedBox(width: 8),
                              _SharedBadge(),
                            ],
                          ],
                        ),
                        Text(
                          DateFormat.yMMMM(
                            Localizations.localeOf(context).languageCode,
                          ).format(
                            DateTime(budget.period.year, budget.period.month),
                          ),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (budget.isOwner) ...[
                    IconButton(
                      onPressed: () => _showShareSheet(context, budget),
                      icon: const Icon(Icons.person_add_alt_outlined),
                      tooltip: l10n.shareBudget,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBudgetPage(budget: budget),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: l10n.edit,
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: mainColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(totalProgress * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Overall Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SummaryItem(
                          label: l10n.allocated,
                          amount: budget.totalAllocated,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        _SummaryItem(
                          label: l10n.spent,
                          amount: budget.totalSpent,
                          color: mainColor,
                        ),
                        _SummaryItem(
                          label: l10n.remaining,
                          amount: budget.totalAllocated - budget.totalSpent,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: totalProgress,
                        minHeight: 12,
                        backgroundColor: mainColor.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(mainColor),
                      ),
                    ),
                  ],
                ),
              ),
              if (budget.linkedGoalId != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.linkedGoalLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              linkedGoal?.name ?? l10n.linkedGoalLabel,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Text(
                l10n.categories,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: budget.categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final category = budget.categories[index];
                  return _CategoryItem(category: category);
                },
              ),
              if (budget.categories.isNotEmpty) ...[
                const SizedBox(height: 32),
                _CategoryHistorySection(
                  categories: budget.categories.map((c) => c.name).toList(),
                  selected: _selectedHistoryCategory,
                  onSelected: (cat) {
                    setState(() => _selectedHistoryCategory = cat);
                    _loadHistory(cat);
                  },
                ),
              ],
              if (budget.isShared) ...[
                const SizedBox(height: 32),
                _ParticipantsSection(budget: budget),
              ],
              if (budget.isShared && !budget.isOwner) ...[
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => _confirmLeave(context, budget),
                    child: Text(
                      l10n.leaveBudget,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLeave(BuildContext context, BudgetModel budget) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.leaveBudget),
        content: Text(l10n.leaveBudgetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<BudgetsBloc>().add(LeaveBudgetRequested(budget.id));
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.leaveBudget),
          ),
        ],
      ),
    );
  }

  void _showShareSheet(BuildContext context, BudgetModel budget) {
    final bloc = context.read<BudgetsBloc>();
    if (budget.inviteCode != null) {
      _showInviteCodeSheet(context, budget.inviteCode!);
    } else {
      bloc.add(ShareBudgetRequested(budget.id));
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => BlocProvider.value(
          value: bloc,
          child: BlocConsumer<BudgetsBloc, BudgetsState>(
            listenWhen: (p, c) => p.shareStatus != c.shareStatus,
            listener: (context, state) {
              if (state.shareStatus == BudgetSideStatus.success &&
                  state.shareInviteCode != null) {
                Navigator.pop(sheetContext);
                _showInviteCodeSheet(context, state.shareInviteCode!);
              }
            },
            builder: (context, state) => Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
    }
  }

  void _showInviteCodeSheet(BuildContext context, String inviteCode) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.shareBudget, style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              l10n.shareBudgetDescription,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  inviteCode,
                  style: AppTextStyles.h2.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inviteCode));
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                    SnackBar(content: Text(l10n.copiedToClipboard)),
                  );
                },
                icon: const Icon(Icons.copy_outlined),
                label: Text(l10n.copyToClipboard),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_outlined, size: 12, color: AppColors.info),
          const SizedBox(width: 4),
          Text(
            l10n.sharedBadge,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHistorySection extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _CategoryHistorySection({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.spendingHistory,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: selected,
              underline: const SizedBox.shrink(),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) onSelected(value);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<BudgetsBloc, BudgetsState>(
          buildWhen: (p, c) =>
              p.categoryHistory != c.categoryHistory ||
              p.categoryHistoryStatus != c.categoryHistoryStatus,
          builder: (context, state) {
            if (state.categoryHistoryStatus == BudgetSideStatus.loading) {
              return const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final history = state.categoryHistory;
            if (history.length < 2) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noDataAvailable,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: history.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.allocated);
                        }).toList(),
                        isCurved: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.5),
                        barWidth: 2,
                        dashArray: [6, 4],
                        dotData: const FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: history.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.spent);
                        }).toList(),
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ParticipantsSection extends StatelessWidget {
  final BudgetModel budget;

  const _ParticipantsSection({required this.budget});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.budgetParticipants,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocBuilder<BudgetsBloc, BudgetsState>(
          buildWhen: (p, c) => p.participants != c.participants,
          builder: (context, state) {
            if (state.participants.isEmpty) {
              return Text(
                AppLocalizations.of(context)!.noDataAvailable,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Column(
              children: state.participants.map((p) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      p.displayName.isNotEmpty
                          ? p.displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  title: Text(p.displayName),
                  trailing: budget.isOwner
                      ? IconButton(
                          icon: const Icon(Icons.person_remove_outlined),
                          tooltip: l10n.removeParticipant,
                          onPressed: () {
                            context.read<BudgetsBloc>().add(
                              RemoveBudgetParticipantRequested(budget.id, p.id),
                            );
                          },
                        )
                      : null,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
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
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final BudgetCategoryModel category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final double progress = category.allocated > 0
        ? (category.spent / category.allocated).clamp(0.0, 1.0)
        : 0.0;
    final isOver = category.spent > category.allocated;
    final color = isOver
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${CurrencyHelper.formatAmount(category.spent, currencyCode: context.read<AuthBloc>().state.authResponse?.user.currency)} / ${CurrencyHelper.formatAmount(category.allocated, currencyCode: context.read<AuthBloc>().state.authResponse?.user.currency)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: isOver
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
