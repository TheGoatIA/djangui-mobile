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
import '../../../../core/services/log_service.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/subscription/data/models/payment_model.dart';
import '../../../../features/payments/presentation/bloc/fintech_bloc.dart';
import '../../../../features/payments/presentation/bloc/fintech_event.dart';
import '../../../../features/payments/presentation/bloc/fintech_state.dart';
import '../../../../core/utils/toast_utils.dart';
// import 'package:go_router/go_router.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubscriptionView();
  }
}

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  final GlobalKey _premiumPlanKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page d\'abonnement.',
      component: 'SubscriptionPage',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('subscription')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      tutorialService.startTutorial(context, 'subscription', [_premiumPlanKey]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => bloc.state.authResponse?.user,
    );
    final paymentService = getIt<PaymentService>();
    final priceInfo = paymentService.getSubscriptionPrice(user?.country);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.upgradeToPremiumTitle),
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FintechBloc, FintechState>(
            listenWhen: (previous, current) {
              return previous.status != current.status &&
                  (current.status == FintechStatus.receiptReady ||
                      current.status == FintechStatus.receiptError);
            },
            listener: (context, fintechState) {
              if (fintechState.status == FintechStatus.receiptReady &&
                  fintechState.message != null) {
                _handlePaymentRedirection(fintechState.message!);
              } else if (fintechState.status == FintechStatus.receiptError) {
                if (mounted) {
                  ToastUtils.showError(
                    context,
                    fintechState.message ??
                        AppLocalizations.of(context)!.genericError,
                  );
                }
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            getIt<LogService>().info(
              'Rafraîchissement manuel de l\'état d\'abonnement',
              component: 'SubscriptionPage',
            );
            context.read<AuthBloc>().add(AuthRefreshUserRequested());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Theme.of(context).colorScheme.primary,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                _buildPlanCard(
                  context,
                  title: AppLocalizations.of(context)!.freePlan,
                  price: AppLocalizations.of(context)!.freePrice,
                  features: [
                    AppLocalizations.of(context)!.freeFeatureLimits,
                    AppLocalizations.of(context)!.freeFeatureTracker,
                    AppLocalizations.of(context)!.freeFeatureInput,
                    AppLocalizations.of(context)!.freeFeatureTontine,
                    AppLocalizations.of(context)!.freeFeatureAI,
                    AppLocalizations.of(context)!.freeFeatureFees,
                  ],
                  isPremium: false,
                  isCurrentPlan: !(user?.isPremium ?? false),
                  onTap: (user?.isPremium ?? false)
                      ? () => _confirmDowngrade(context)
                      : null,
                ),
                const SizedBox(height: 24),
                Showcase(
                  key: _premiumPlanKey,
                  title: AppLocalizations.of(
                    context,
                  )!.tutorialSubscriptionTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.tutorialSubscriptionDesc,
                  child: _buildPlanCard(
                    context,
                    title: AppLocalizations.of(context)!.premiumPlan,
                    price: priceInfo.formattedPrice,
                    features: [
                      AppLocalizations.of(context)!.premiumFeatureLimits,
                      AppLocalizations.of(context)!.premiumFeatureInvest,
                      AppLocalizations.of(context)!.premiumFeatureInput,
                      AppLocalizations.of(context)!.premiumFeatureTontine,
                      AppLocalizations.of(context)!.premiumFeatureAI,
                      AppLocalizations.of(context)!.premiumFeatureFees,
                      AppLocalizations.of(context)!.premiumFeaturePrevention,
                    ],
                    isPremium: true,
                    isBestValue: true,
                    isCurrentPlan: (user?.isPremium ?? false),
                    onTap: !(user?.isPremium ?? false)
                        ? () => _showPaymentOptions(context, priceInfo)
                        : null,
                  ),
                ),
                const SizedBox(height: 48),
                _buildHistorySection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDowngrade(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDowngradeTitle),
        content: Text(AppLocalizations.of(context)!.confirmDowngradeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      getIt<LogService>().info(
        'Action: Demande de downgrade (annulation abonnement)',
        component: 'SubscriptionPage',
      );

      final paymentService = getIt<PaymentService>();
      final success = await paymentService.cancelSubscription();

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.downgradeRequestSuccess,
            ),
          ),
        );
        // Refresh user status
        context.read<AuthBloc>().add(AuthRefreshUserRequested());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorOccurred),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.paymentHistory,
          style: AppTextStyles.h3,
        ),
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
                    AppLocalizations.of(context)!.noPaymentFound,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.5),
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                      if (payment.status == 'completed' ||
                          payment.status == 'succeeded') ...[
                        const SizedBox(width: 8),
                        BlocBuilder<FintechBloc, FintechState>(
                          builder: (context, fintechState) {
                            if (fintechState.downloadingReceiptId ==
                                payment.id) {
                              return const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            return IconButton(
                              onPressed: () {
                                context.read<FintechBloc>().add(
                                  DownloadPaymentReceipt(paymentId: payment.id),
                                );
                              },
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 20,
                              ),
                              color: Theme.of(context).colorScheme.primary,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            );
                          },
                        ),
                      ],
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
          color: isBestValue
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppLocalizations.of(context)!.bestValue,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
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
            style: AppTextStyles.h2.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
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
              text: AppLocalizations.of(context)!.currentPlan,
              onPressed: () {},
              color: Theme.of(context).colorScheme.outline,
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
              text: AppLocalizations.of(context)!.revertToFree,
              onPressed: onTap ?? () {},
              color: Theme.of(context).colorScheme.error,
            ),
        ],
      ),
    );
  }

  void _showPaymentOptions(
    BuildContext context,
    ({double amount, String currency, String formattedPrice}) priceInfo,
  ) {
    getIt<LogService>().info(
      'Action: Affichage des options de paiement',
      component: 'SubscriptionPage',
      metadata: {'price': priceInfo.formattedPrice},
    );
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
              context,
              icon: Icons.phone_android,
              title: 'NotchPay (${AppLocalizations.of(context)!.mobileMoney})',
              subtitle: AppLocalizations.of(
                context,
              )!.mobileMoneyPlatforms(priceInfo.formattedPrice),
              onTap: () => _initiatePayment(context, 'notchpay', priceInfo),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              context,
              icon: Icons.credit_card,
              title: 'Stripe (${AppLocalizations.of(context)!.bankCard})',
              subtitle: AppLocalizations.of(
                context,
              )!.bankCardPlatforms(priceInfo.formattedPrice),
              onTap: () => _initiatePayment(context, 'stripe', priceInfo),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context, {
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
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
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
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
        getIt<LogService>().info(
          'Action: Initialisation paiement via NotchPay',
          component: 'SubscriptionPage',
        );
        url = await paymentService.initializeNotchPay(
          priceInfo.amount,
          currency: priceInfo.currency,
        );
      } else {
        getIt<LogService>().info(
          'Action: Initialisation paiement via Stripe',
          component: 'SubscriptionPage',
        );
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
        getIt<LogService>().error(
          'Erreur: Initialisation paiement échouée (URL null)',
          component: 'SubscriptionPage',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.paymentInitError),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      getIt<LogService>().error(
        'Erreur: Exception lors du paiement',
        component: 'SubscriptionPage',
        error: e,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  void _handlePaymentRedirection(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ToastUtils.showError(
          context,
          AppLocalizations.of(context)!.genericError,
        );
      }
    }
  }
}
