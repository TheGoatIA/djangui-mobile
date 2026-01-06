import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/transaction_model.dart';
import '../../../goals/presentation/bloc/goals_bloc.dart';
import '../../../goals/presentation/bloc/goals_state.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final isExpense = transaction.type == 'expense';
        final dateStr = DateFormat.yMMMMd(
          Localizations.localeOf(context).languageCode,
        ).add_Hm().format(transaction.date);

        String? linkedGoalName;
        if (transaction.linkedGoalId != null) {
          final goal = state.goals.firstWhereOrNull(
            (g) => g.id == transaction.linkedGoalId,
          );
          if (goal != null) {
            linkedGoalName = "${goal.emoji ?? '🎯'} ${goal.name}";
          }
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(l10n.transactions),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                          color:
                              (isExpense ? AppColors.error : AppColors.success)
                                  .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isExpense
                              ? AppColors.error
                              : AppColors.success,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${isExpense ? '-' : '+'} ${transaction.amount.toStringAsFixed(0)} ${transaction.currency}',
                        style: AppTextStyles.h1.copyWith(
                          color: isExpense
                              ? AppColors.error
                              : AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transaction.description,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Text(l10n.categoryDetails, style: AppTextStyles.h3),
                const SizedBox(height: 16),

                _InfoTile(
                  label: l10n.categoryLabel,
                  value: transaction.category,
                  icon: Icons.category_outlined,
                ),
                if (transaction.subcategory != null)
                  _InfoTile(
                    label: l10n.subcategoryLabel,
                    value: transaction.subcategory!,
                    icon: Icons.layers_outlined,
                  ),
                if (transaction.merchant != null)
                  _InfoTile(
                    label: l10n.merchantLabel,
                    value: transaction.merchant!,
                    icon: Icons.storefront_outlined,
                  ),
                _InfoTile(
                  label: l10n.date,
                  value: dateStr,
                  icon: Icons.calendar_today_outlined,
                ),
                if (transaction.location != null)
                  _InfoTile(
                    label: l10n.locationLabel,
                    value: transaction.location!,
                    icon: Icons.location_on_outlined,
                  ),
                if (transaction.linkedGoalId != null)
                  _InfoTile(
                    label: l10n.linkToGoalLabel,
                    value: linkedGoalName ?? l10n.active,
                    icon: Icons.track_changes,
                  ),

                const SizedBox(height: 24),
                Text(
                  'ID: ${transaction.id}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(value, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
