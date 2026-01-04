import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/payment_service.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.upgradeToPremiumTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.primary, size: 80),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.premiumWelcomeTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.premiumWelcomeSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            _buildPlanCard(
              context,
              title: AppLocalizations.of(context)!.freePlan,
              price: AppLocalizations.of(context)!.freePrice,
              features: [
                AppLocalizations.of(context)!.freeFeature1,
                AppLocalizations.of(context)!.freeFeature2,
                AppLocalizations.of(context)!.freeFeature3,
              ],
              isPremium: false,
            ),
            const SizedBox(height: 24),
            _buildPlanCard(
              context,
              title: AppLocalizations.of(context)!.premiumPlan,
              price: AppLocalizations.of(context)!.premiumPrice,
              features: [
                AppLocalizations.of(context)!.premiumFeature1,
                AppLocalizations.of(context)!.premiumFeature2,
                AppLocalizations.of(context)!.premiumFeature3,
                AppLocalizations.of(context)!.premiumFeature4,
              ],
              isPremium: true,
              isBestValue: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required bool isPremium,
    bool isBestValue = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isBestValue ? AppColors.primary : AppColors.outline,
          width: isBestValue ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBestValue) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppLocalizations.of(context)!.bestValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            price,
            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(f, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (isPremium)
            AppButton(
              text: AppLocalizations.of(context)!.upgradeAction,
              onPressed: () => _showPaymentOptions(context),
            )
          else
            AppButton(
              text: AppLocalizations.of(context)!.currentPlan,
              onPressed: () {},
              color: AppColors.outline,
            ),
        ],
      ),
    );
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.choosePaymentMethodTitle,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 24),
            _buildPaymentMethod(
              icon: Icons.phone_android,
              title: 'Mobile Money (NotchPay)',
              subtitle: 'Orange, MTN, Moov...',
              onTap: () => _initiatePayment(context, 'notchpay'),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              icon: Icons.credit_card,
              title: 'Carte Bancaire (Stripe)',
              subtitle: 'Visa, Mastercard...',
              onTap: () => _initiatePayment(context, 'stripe'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
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
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Future<void> _initiatePayment(BuildContext context, String method) async {
    Navigator.pop(context); // Close bottom sheet

    final paymentService = getIt<PaymentService>();
    String? url;

    try {
      if (method == 'notchpay') {
        url = await paymentService.initializeNotchPay(5000);
      } else {
        url = await paymentService.createStripeCheckout();
      }

      if (url != null) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.paymentInitError),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }
}
