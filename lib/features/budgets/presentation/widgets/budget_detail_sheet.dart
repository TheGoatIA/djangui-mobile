import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:djangui/core/theme/app_colors.dart';
import 'package:djangui/core/theme/app_text_styles.dart';
import 'package:djangui/l10n/app_localizations.dart';
import 'package:djangui/features/budgets/data/models/budget_model.dart';

class BudgetDetailSheet extends StatelessWidget {
  final BudgetModel budget;

  const BudgetDetailSheet({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double totalProgress = budget.totalAllocated > 0
        ? (budget.totalSpent / budget.totalAllocated).clamp(0.0, 1.0)
        : 0.0;
    final bool isOverBudget = budget.totalSpent > budget.totalAllocated;
    final Color mainColor = isOverBudget ? AppColors.error : AppColors.primary;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.budgetDetails,
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMM(
                      Localizations.localeOf(context).languageCode,
                    ).format(DateTime(budget.period.year, budget.period.month)),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
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
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.1),
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
                      color: AppColors.textPrimary,
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
          const SizedBox(height: 32),
          Text(
            l10n.categories,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: budget.categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final category = budget.categories[index];
                return _CategoryItem(category: category);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
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
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(0)}',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'XAF',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
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
    final color = isOver ? AppColors.error : AppColors.primary;

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
              '${category.spent.toStringAsFixed(0)} / ${category.allocated.toStringAsFixed(0)} XAF',
              style: AppTextStyles.bodySmall.copyWith(
                color: isOver ? AppColors.error : AppColors.textSecondary,
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
