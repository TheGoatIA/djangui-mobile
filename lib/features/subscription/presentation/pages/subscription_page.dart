import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
      appBar: AppBar(title: const Text('Passer au Premium'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.primary, size: 80),
            const SizedBox(height: 16),
            Text(
              'Débloquez votre potentiel financier',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 12),
            Text(
              'Accédez à des outils avancés pour booster votre gestion de patrimoine.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            _buildPlanCard(
              context,
              title: 'Gratuit',
              price: '0 FCFA',
              features: [
                'Gestion de budget de base',
                'Suivi de transactions manuel',
                '1 Objectif financier',
              ],
              isPremium: false,
            ),
            const SizedBox(height: 24),
            _buildPlanCard(
              context,
              title: 'Premium',
              price: '5,000 FCFA / mois',
              features: [
                'Intelligence Artificielle (OCR & SMS)',
                'Analyses et Rapports détaillés',
                'Gestion d\'investissements illimitée',
                'Multi-devises & Export CSV',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isBestValue ? AppColors.primary : Colors.grey[200]!,
          width: isBestValue ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              child: const Text(
                'MEILLEURE OFFRE',
                style: TextStyle(
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
              text: 'Devenir Premium',
              onPressed: () => _showPaymentOptions(context),
            )
          else
            AppButton(
              text: 'Plan actuel',
              onPressed: () {},
              color: Colors.grey[300]!,
              // textColor: Colors.black54,
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choisir un moyen de paiement', style: AppTextStyles.h3),
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
          border: Border.all(color: Colors.grey[200]!),
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
            const Icon(Icons.chevron_right, color: Colors.grey),
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
          const SnackBar(
            content: Text('Erreur lors de l\'initialisation du paiement'),
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
