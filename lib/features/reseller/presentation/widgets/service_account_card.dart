import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../data/models/reseller_models.dart';

class ServiceAccountCard extends StatelessWidget {
  final ResellerAccountModel account;
  final VoidCallback onTap;
  final VoidCallback onUnlockVault;
  final VoidCallback? onDeleteAccount;
  final Function(ResellerSlotModel)? onSlotTap;

  const ServiceAccountCard({
    super.key,
    required this.account,
    required this.onTap,
    required this.onUnlockVault,
    this.onDeleteAccount,
    this.onSlotTap,
  });

  Color _parseBrandColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _parseBrandColor(account.brandColor);
    final isProfitable = account.netMargin >= 0;

    return GlassCard(
      color: brandColor.withValues(alpha: 0.08),
      border: Border.all(color: brandColor.withValues(alpha: 0.25)),
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: brandColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    account.serviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (isProfitable ? AppColors.primary : Colors.red)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isProfitable
                          ? '+${account.netMargin.toStringAsFixed(0)} ${account.billingCurrency}'
                          : '${account.netMargin.toStringAsFixed(0)} ${account.billingCurrency}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isProfitable ? AppColors.primary : Colors.red,
                      ),
                    ),
                  ),
                  if (onDeleteAccount != null) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      tooltip: 'Supprimer le compte maître',
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      onPressed: onDeleteAccount,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Slots Visual Grid
          Text(
            'SLOTS (${account.occupiedSlots}/${account.maxSlots} Occupés)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(account.maxSlots, (index) {
              if (index < account.slots.length) {
                final slot = account.slots[index];
                Color dotColor = AppColors.primary;
                if (slot.status == 'due_soon') dotColor = Colors.orange;
                if (slot.status == 'overdue' || slot.status == 'blocked') {
                  dotColor = Colors.red;
                }

                return GestureDetector(
                  onTap: () => onSlotTap?.call(slot),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: dotColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: dotColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          slot.profileName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: dotColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 12, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Attribuer',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 14),

          // Footer info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Coût : ${account.billingCost.toStringAsFixed(0)} ${account.billingCurrency}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              TextButton.icon(
                onPressed: onUnlockVault,
                icon: const Icon(Icons.lock_open_rounded, size: 14),
                label: const Text(
                  'Accès & PIN',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
