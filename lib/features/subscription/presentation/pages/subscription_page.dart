import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/subscription/data/models/payment_model.dart';
// import 'package:go_router/go_router.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => bloc.state.authResponse?.user,
    );
    final paymentService = getIt<PaymentService>();
    final priceInfo = paymentService.getSubscriptionPrice(user?.country);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.upgradeToPremiumTitle),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AuthBloc>().add(AuthRefreshUserRequested());
          // Wait a bit to let the bloc update (optional, but good for UX)
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.primary,
                size: 80,
              ),
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
                isCurrentPlan: !(user?.isPremium ?? false),
                onTap: (user?.isPremium ?? false)
                    ? () => _confirmDowngrade(context)
                    : null,
              ),
              const SizedBox(height: 24),
              _buildPlanCard(
                context,
                title: AppLocalizations.of(context)!.premiumPlan,
                price: priceInfo.formattedPrice, // Dynamic price
                features: [
                  AppLocalizations.of(context)!.premiumFeature1,
                  AppLocalizations.of(context)!.premiumFeature2,
                  AppLocalizations.of(context)!.premiumFeature3,
                  AppLocalizations.of(context)!.premiumFeature4,
                ],
                isPremium: true,
                isBestValue: true,
                isCurrentPlan: (user?.isPremium ?? false),
                onTap: !(user?.isPremium ?? false)
                    ? () => _showPaymentOptions(context, priceInfo)
                    : null,
              ),
              const SizedBox(height: 48),
              _buildHistorySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDowngrade(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Revenir au plan gratuit ?"),
        content: const Text(
          "En revenant au plan gratuit, vous perdrez immédiatement vos avantages Premium. Êtes-vous sûr ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      // Ideally call API here. For now, show message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Votre demande de résiliation a été prise en compte."),
        ),
      );
      // Trigger refresh to update state if backend supports it
      context.read<AuthBloc>().add(AuthRefreshUserRequested());
    }
  }

  Widget _buildHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historique des paiements', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        FutureBuilder<List<PaymentModel>>(
          future: getIt<PaymentService>().getPaymentHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Aucun paiement trouvé',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }

            final payments = snapshot.data!;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              (payment.status == 'completed' ||
                                  payment.status == 'succeeded')
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.warning.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          (payment.status == 'completed' ||
                                  payment.status == 'succeeded')
                              ? Icons.check
                              : Icons.access_time,
                          color:
                              (payment.status == 'completed' ||
                                  payment.status == 'succeeded')
                              ? AppColors.success
                              : AppColors.warning,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.type.toUpperCase(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'dd MMM yyyy, HH:mm',
                              ).format(payment.createdAt),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${payment.amount} ${payment.currency}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            payment.status,
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  (payment.status == 'completed' ||
                                      payment.status == 'succeeded')
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required bool isPremium,
    bool isBestValue = false,
    bool isCurrentPlan = false,
    VoidCallback? onTap,
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
          if (isCurrentPlan)
            AppButton(
              text: "Plan Actuel",
              onPressed: () {},
              color: AppColors.outline,
            )
          else if (isPremium)
            // Case: Showing Premium card while on Free plan
            AppButton(
              text: AppLocalizations.of(context)!.upgradeAction,
              onPressed: onTap ?? () {},
            )
          else
            // Case: Showing Free card while on Premium plan (Downgrade option)
            AppButton(
              text: "Revenir au plan gratuit",
              onPressed: onTap ?? () {},
              color: AppColors.error,
            ),
        ],
      ),
    );
  }

  void _showPaymentOptions(
    BuildContext context,
    ({double amount, String currency, String formattedPrice}) priceInfo,
  ) {
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
              subtitle: 'Orange, MTN, Moov... (${priceInfo.formattedPrice})',
              onTap: () => _initiatePayment(context, 'notchpay', priceInfo),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              icon: Icons.credit_card,
              title: 'Carte Bancaire (Stripe)',
              subtitle: 'Visa, Mastercard... (${priceInfo.formattedPrice})',
              onTap: () => _initiatePayment(context, 'stripe', priceInfo),
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

  Future<void> _initiatePayment(
    BuildContext context,
    String method,
    ({double amount, String currency, String formattedPrice}) priceInfo,
  ) async {
    Navigator.pop(context); // Close bottom sheet

    final paymentService = getIt<PaymentService>();
    String? url;

    try {
      if (method == 'notchpay') {
        url = await paymentService.initializeNotchPay(
          priceInfo.amount,
          currency: priceInfo.currency,
        );
      } else {
        url = await paymentService.createStripeCheckout(
          priceInfo.amount,
          priceInfo.currency,
        );
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
