import 'package:flutter/material.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/l10n/app_localizations.dart';

/// Badge élégant indiquant le statut d'une transaction (succès, en attente, échec, annulé).
class TransactionStatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const TransactionStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final normalized = status.toLowerCase().trim();

    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    switch (normalized) {
      case 'completed':
      case 'success':
      case 'validated':
        bgColor = AppColors.success.withValues(alpha: 0.12);
        textColor = AppColors.success;
        icon = Icons.check_circle_rounded;
        label = l10n.txStatusCompleted;
        break;
      case 'pending':
      case 'processing':
      case 'initiated':
        bgColor = Colors.amber.shade600.withValues(alpha: 0.15);
        textColor = Colors.amber.shade800;
        icon = Icons.schedule_rounded;
        label = l10n.txStatusPending;
        break;
      case 'failed':
      case 'rejected':
      case 'error':
        bgColor = AppColors.error.withValues(alpha: 0.12);
        textColor = AppColors.error;
        icon = Icons.cancel_rounded;
        label = l10n.txStatusFailed;
        break;
      case 'cancelled':
      case 'canceled':
        bgColor = Colors.grey.shade500.withValues(alpha: 0.15);
        textColor = Colors.grey.shade700;
        icon = Icons.block_rounded;
        label = l10n.txStatusCancelled;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        icon = Icons.info_outline_rounded;
        label = status;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: textColor),
            const SizedBox(width: 3),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
