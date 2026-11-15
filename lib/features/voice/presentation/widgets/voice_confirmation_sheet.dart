import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/voice_response_model.dart';
import '../bloc/voice_bloc.dart';
import '../bloc/voice_event.dart';
import '../../../transactions/presentation/bloc/transactions_bloc.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/utils/currency_helper.dart';

class VoiceConfirmationSheet extends StatelessWidget {
  final VoiceResponseModel response;

  const VoiceConfirmationSheet({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isExpense = response.type.toLowerCase() == 'expense';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isExpense
                      ? AppColors.error.withValues(alpha: 0.1)
                      : AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isExpense ? Icons.arrow_outward : Icons.arrow_downward,
                  color: isExpense ? AppColors.error : AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.confirmTransaction, style: AppTextStyles.h3),
                    Text(
                      AppLocalizations.of(context)!.voiceExtractionConfidence(
                        ((response.confidence * 100).toStringAsFixed(
                          0,
                        )).toString(),
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildInfoRow(
            context,
            label: l10n.amountLabel,
            value: CurrencyHelper.formatAmount(
              response.amount ?? 0,
              currencyCode: context
                  .read<AuthBloc>()
                  .state
                  .authResponse
                  ?.user
                  .currency,
            ),
            isHighlight: true,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            label: l10n.descriptionLabel,
            value: response.description,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            label: l10n.categoryLabel,
            value: response.category ?? 'Autres',
          ),
          if (response.merchant != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              label: l10n.merchantLabel,
              value: response.merchant!,
            ),
          ],
          if (response.date != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              label: AppLocalizations.of(context)!.date,
              value: DateFormat('dd MMM yyyy, HH:mm').format(response.date!),
            ),
          ],
          if (response.targetGoal != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.track_changes,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.targetGoalValue(
                        (response.targetGoal ?? "").toString(),
                      ),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<VoiceBloc>().add(VoiceResponseCancelled());
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  text: l10n.confirm,
                  onPressed: () => _confirmTransaction(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: isHighlight
              ? AppTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )
              : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _confirmTransaction(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState.authResponse?.user.id;

    final transaction = TransactionModel(
      id: const Uuid().v4(),
      userId: userId,
      amount: response.amount ?? 0,
      type: response.type,
      category: response.category ?? 'Autres',
      description: response.description,
      merchant: response.merchant,
      date: response.date ?? DateTime.now(),
      currency: authState.authResponse?.user.currency ?? 'XAF',
      // targetGoal would require looking up the ID based on the name
      // For now, we'll just save the transaction.
    );

    context.read<TransactionsBloc>().add(AddTransactionRequested(transaction));
    context.read<VoiceBloc>().add(VoiceResponseConfirmed(response));

    Navigator.pop(context);
  }
}
