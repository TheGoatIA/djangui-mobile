import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';

class TontineGuidePage extends StatelessWidget {
  const TontineGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tontineGuideTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            context,
            Icons.help_outline,
            l10n.whatIsTontineTitle,
            l10n.whatIsTontineDesc,
            theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(l10n.tontineLifecycleTitle, style: AppTextStyles.h3),
          const SizedBox(height: 12),
          _buildStepItem(
            context,
            Icons.hourglass_empty,
            l10n.guidePendingTitle,
            l10n.guidePendingDesc,
            Colors.orange,
          ),
          _buildStepItem(
            context,
            Icons.play_circle_outline,
            l10n.guideActiveTitle,
            l10n.guideActiveDesc,
            Colors.green,
          ),
          _buildStepItem(
            context,
            Icons.check_circle_outline,
            l10n.guideCompletedTitle,
            l10n.guideCompletedDesc,
            Colors.blue,
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            Icons.sync,
            l10n.guideRotationTitle,
            l10n.guideRotationDesc,
            Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            Icons.verified_user_outlined,
            l10n.guideValidationTitle,
            l10n.guideValidationDesc,
            Colors.teal,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            Icons.gavel_outlined,
            l10n.guideSanctionsTitle,
            l10n.guideSanctionsDesc,
            Colors.redAccent,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            Icons.volunteer_activism_outlined,
            l10n.guideSocialFundTitle,
            l10n.guideSocialFundDesc,
            theme.colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            Icons.speed,
            l10n.guideTrustScoreTitle,
            l10n.guideTrustScoreDesc,
            theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            Icons.shield_outlined,
            l10n.guideFinancialSafetyTitle,
            l10n.guideFinancialSafetyDesc,
            AppColors.success,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(color: color, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
