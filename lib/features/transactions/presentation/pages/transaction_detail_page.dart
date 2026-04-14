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
import '../bloc/transactions_bloc.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

// Converti en StatefulWidget pour appliquer SecureScreenMixin
// (empêche les captures d'écran sur le détail d'une transaction).
// Aucun changement de comportement ou de logique métier.
class TransactionDetailPage extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage>
    with WidgetsBindingObserver, SecureScreenMixin<TransactionDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Alias local pour conserver la lisibilité du code existant sans modification
    final transaction = widget.transaction;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featManualTransactions,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.transactions);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.transactions,
            isUpdateRequired: true,
          );
        }
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                title: Text(l10n.transactions),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  if (transaction.source == 'manual' ||
                      transaction.source == 'cash')
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      onPressed: () => _showDeleteConfirmation(context),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              body: BlocListener<TransactionsBloc, TransactionsState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == TransactionsStatus.loading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state.status == TransactionsStatus.success) {
                    Navigator.of(context).pop(); // Pop loading
                    Navigator.of(context).pop(); // Pop detail page
                    ToastUtils.showSuccess(context, l10n.success);
                  } else if (state.status == TransactionsStatus.error) {
                    Navigator.of(context).pop(); // Pop loading
                    ToastUtils.showError(
                      context,
                      state.errorMessage ?? l10n.unknownError,
                    );
                    context.read<TransactionsBloc>().add(
                      ResetTransactionsStatus(),
                    );
                  }
                },
                child: SingleChildScrollView(
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
                                    (isExpense
                                            ? AppColors.error
                                            : AppColors.success)
                                        .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isExpense
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
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
                      if (transaction.source == 'manual') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.manualTransactionInfo,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTransaction),
        content: Text(l10n.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TransactionsBloc>().add(
                DeleteTransactionRequested(widget.transaction.id),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
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
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
