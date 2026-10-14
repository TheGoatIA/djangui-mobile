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
import '../../../../features/subscription/data/models/plan_config_model.dart';
import '../../../../features/payments/presentation/bloc/fintech_bloc.dart';
import '../../../../features/payments/presentation/bloc/fintech_event.dart';
import '../../../../features/payments/presentation/bloc/fintech_state.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/tutorial/tutorial_step.dart';
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

class _SubscriptionViewState extends State<SubscriptionView>
    with WidgetsBindingObserver {
  final GlobalKey _premiumPlanKey = GlobalKey();

  /// Référence du paiement externe (NotchPay/Stripe) en cours. L'utilisateur
  /// quitte l'app pour payer : si le deep link kauri://payment/success ne se
  /// déclenche pas (navigateur fermé à la main, app tuée par l'OS...), on
  /// revérifie ce paiement au retour au premier plan.
  String? _pendingPaymentReference;
  bool _isVerifyingPending = false;

  Future<List<PlanConfigModel>>? _plansFuture;
  String? _lastLanguage;

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page d\'abonnement.',
      component: 'SubscriptionPage',
    );
    WidgetsBinding.instance.addObserver(this);
    context.read<FintechBloc>().add(FetchWalletBalance());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _verifyPendingPayment();
    }
  }

  Future<void> _verifyPendingPayment() async {
    final reference = _pendingPaymentReference;
    if (reference == null || reference.isEmpty || _isVerifyingPending) return;
    _isVerifyingPending = true;
    try {
      final paymentService = getIt<PaymentService>();
      // Le webhook peut arriver quelques secondes après le retour de l'utilisateur.
      for (var attempt = 0; attempt < 4; attempt++) {
        final completed = await paymentService.verifyTransaction(reference);
        if (!mounted) return;
        if (completed) {
          _pendingPaymentReference = null;
          context.read<AuthBloc>().add(AuthRefreshUserRequested());
          context.read<FintechBloc>().add(FetchWalletBalance());
          context.read<FintechBloc>().add(FetchWalletTransactions());
          ToastUtils.showSuccess(
            context,
            AppLocalizations.of(context)!.walletSubscriptionSuccess,
          );
          setState(() {});
          return;
        }
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return;
      }
    } finally {
      _isVerifyingPending = false;
    }
  }

  void _loadPlans([String? forcedLanguage]) {
    final language =
        forcedLanguage ?? Localizations.localeOf(context).languageCode;
    _lastLanguage = language;
    _plansFuture = getIt<PaymentService>().getPlansConfig(language: language);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    final currentLanguage = Localizations.localeOf(context).languageCode;
    if (_plansFuture == null || _lastLanguage != currentLanguage) {
      _loadPlans(currentLanguage);
    }
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('subscription')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'subscription', [
        TutorialStep(
          targetKey: _premiumPlanKey,
          title: l10n.tutorialSubscriptionTitle,
          description: l10n.tutorialSubscriptionDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => bloc.state.authResponse?.user,
    );
    final paymentService = getIt<PaymentService>();
    final fallbackPriceInfo = paymentService.getSubscriptionPrice(
      user?.country,
    );
    final fallbackBusinessPriceInfo = paymentService
        .getBusinessSubscriptionPrice(user?.country);
    final userPlan = user?.subscription?.plan ?? 'free';
    final isBusiness = user?.isBusiness ?? false;
    final isPremiumOnly = (user?.isPremium ?? false) && !isBusiness;
    final isFree = !(user?.isPremium ?? false);

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
            setState(() {
              _loadPlans();
            });
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
                FutureBuilder<List<PlanConfigModel>>(
                  future: _plansFuture,
                  builder: (context, snapshot) {
                    final dynamicPlans = snapshot.data;
                    if (dynamicPlans != null && dynamicPlans.isNotEmpty) {
                      return Column(
                        children: dynamicPlans.map((plan) {
                          final priceInfo = plan.getPriceForCountry(
                            user?.country,
                          );
                          final isCurrent =
                              userPlan == plan.slug ||
                              (plan.slug == 'free' && isFree) ||
                              (plan.slug == 'premium' && isPremiumOnly) ||
                              (plan.slug == 'business' && isBusiness);
                          final isPlanPremium = plan.slug != 'free';

                          Widget card = _buildPlanCard(
                            context,
                            title: plan.name,
                            price: priceInfo.formattedPrice,
                            features: plan.featureSummary,
                            isPremium: isPlanPremium,
                            isBestValue: plan.highlight,
                            isCurrentPlan: isCurrent,
                            categories: plan.categories,
                            planDescription: plan.description,
                            onTap: isCurrent
                                ? null
                                : (plan.slug == 'free'
                                      ? () => _confirmDowngrade(context)
                                      : () => _showPaymentOptions(
                                          context,
                                          priceInfo,
                                          plan: plan.slug,
                                        )),
                          );

                          if (plan.slug == 'premium') {
                            card = KeyedSubtree(
                              key: _premiumPlanKey,
                              child: card,
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: card,
                          );
                        }).toList(),
                      );
                    }

                    // Fallback statique si l'API est en cours de chargement ou hors ligne
                    return Column(
                      children: [
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
                          isCurrentPlan: isFree,
                          onTap: !isFree
                              ? () => _confirmDowngrade(context)
                              : null,
                        ),
                        const SizedBox(height: 24),
                        KeyedSubtree(
                          key: _premiumPlanKey,
                          child: _buildPlanCard(
                            context,
                            title: AppLocalizations.of(context)!.premiumPlan,
                            price: fallbackPriceInfo.formattedPrice,
                            features: [
                              '5 Budgets & 5 Objectifs simultanés',
                              '15 Scans OCR de reçus / mois',
                              'Jusqu\'à 2 tontines créées (Participation libre)',
                              'Coach IA Anne (50 requêtes / mois & 30j historique)',
                              AppLocalizations.of(context)!.premiumFeatureFees,
                              'Hub Revendeur : 3 comptes maîtres & 10 slots clients',
                            ],
                            isPremium: true,
                            isCurrentPlan: isPremiumOnly,
                            onTap: isFree
                                ? () => _showPaymentOptions(
                                    context,
                                    fallbackPriceInfo,
                                    plan: 'premium',
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPlanCard(
                          context,
                          title: AppLocalizations.of(context)!.businessPlan,
                          price: fallbackBusinessPriceInfo.formattedPrice,
                          features: [
                            AppLocalizations.of(
                              context,
                            )!.businessFeatureResellerUnlimited,
                            AppLocalizations.of(
                              context,
                            )!.businessFeatureAutoReminders,
                            AppLocalizations.of(
                              context,
                            )!.businessFeatureAccountingExports,
                            AppLocalizations.of(
                              context,
                            )!.businessFeatureAdvancedStats,
                            AppLocalizations.of(
                              context,
                            )!.businessFeatureVIPSupport,
                          ],
                          isPremium: true,
                          isBestValue: true,
                          isCurrentPlan: isBusiness,
                          onTap: !isBusiness
                              ? () => _showPaymentOptions(
                                  context,
                                  fallbackBusinessPriceInfo,
                                  plan: 'business',
                                )
                              : null,
                        ),
                      ],
                    );
                  },
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
    List<PlanFeatureCategory>? categories,
    String? planDescription,
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
          if (planDescription != null && planDescription.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              planDescription,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
          if (categories != null && categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () => _showPlanDetailsModal(
                  context,
                  title: title,
                  price: price,
                  description: planDescription,
                  categories: categories,
                ),
                icon: const Icon(Icons.list_alt_rounded, size: 18),
                label: const Text(
                  'Voir tous les détails & fonctionnalités',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
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

  void _showPlanDetailsModal(
    BuildContext context, {
    required String title,
    required String price,
    String? description,
    required List<PlanFeatureCategory> categories,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (sheetCtx, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.h2),
                          const SizedBox(height: 4),
                          Text(
                            price,
                            style: AppTextStyles.h3.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.transparent),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, catIdx) {
                    final cat = categories[catIdx];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            cat.category,
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        ...cat.items.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.highlight
                                  ? Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.06)
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: item.highlight
                                    ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.3)
                                    : Theme.of(context).colorScheme.outline
                                          .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.included
                                      ? Icons.check_circle_rounded
                                      : Icons.remove_circle_outline_rounded,
                                  color: item.included
                                      ? AppColors.success
                                      : Theme.of(context).colorScheme.outline,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: item.highlight
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (item.value != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.value!,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentOptions(
    BuildContext context,
    ({double amount, String currency, String formattedPrice}) priceInfo, {
    String plan = 'premium',
  }) {
    final l10n = AppLocalizations.of(context)!;

    getIt<LogService>().info(
      'Action: Affichage des options de paiement',
      component: 'SubscriptionPage',
      metadata: {'price': priceInfo.formattedPrice, 'plan': plan},
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocBuilder<FintechBloc, FintechState>(
        builder: (ctx, fintechState) {
          final walletBalance = fintechState.balance;
          final formattedWalletBalance = CurrencyHelper.formatAmount(
            walletBalance,
            currencyCode: priceInfo.currency,
          );

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.choosePaymentMethodTitle, style: AppTextStyles.h3),
                const SizedBox(height: 24),
                _buildPaymentMethod(
                  context,
                  icon: Icons.account_balance_wallet_rounded,
                  title: l10n.walletPaymentMethod,
                  subtitle: l10n.walletPaymentSubtitle(formattedWalletBalance),
                  badge: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Instantané',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => _payWithWallet(context, priceInfo, plan: plan),
                ),
                const SizedBox(height: 16),
                _buildPaymentMethod(
                  context,
                  icon: Icons.phone_android,
                  title: 'NotchPay (${l10n.mobileMoney})',
                  subtitle: l10n.mobileMoneyPlatforms(priceInfo.formattedPrice),
                  onTap: () => _initiatePayment(
                    context,
                    'notchpay',
                    priceInfo,
                    plan: plan,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentMethod(
                  context,
                  icon: Icons.credit_card,
                  title: 'Stripe (${l10n.bankCard})',
                  subtitle: l10n.bankCardPlatforms(priceInfo.formattedPrice),
                  onTap: () => _initiatePayment(
                    context,
                    'stripe',
                    priceInfo,
                    plan: plan,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (badge != null) ...[const SizedBox(width: 8), badge],
                    ],
                  ),
                  const SizedBox(height: 2),
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

  Future<void> _payWithWallet(
    BuildContext context,
    ({double amount, String currency, String formattedPrice}) priceInfo, {
    String plan = 'premium',
  }) async {
    Navigator.pop(context); // Close bottom sheet
    final l10n = AppLocalizations.of(context)!;
    final currentBalance = context.read<FintechBloc>().state.balance;

    getIt<LogService>().info(
      'Action: Clic Paiement abonnement par Portefeuille Kauri',
      component: 'SubscriptionPage',
      metadata: {
        'price': priceInfo.formattedPrice,
        'amount': priceInfo.amount,
        'walletBalance': currentBalance,
        'plan': plan,
      },
    );

    if (currentBalance < priceInfo.amount) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.walletPaymentMethod),
          content: Text(
            '${l10n.walletInsufficientBalance}.\n\n'
            'Solde disponible : ${CurrencyHelper.formatAmount(currentBalance, currencyCode: priceInfo.currency)}\n'
            'Requis : ${priceInfo.formattedPrice}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                ctx.push(RouteConstants.wallet);
              },
              child: const Text('Recharger le portefeuille'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.walletSubscriptionConfirmTitle),
        content: Text(
          l10n.walletSubscriptionConfirmMessage(priceInfo.formattedPrice),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmAction),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final paymentService = getIt<PaymentService>();
      final result = await paymentService.paySubscriptionWithWallet(plan: plan);

      if (context.mounted) {
        Navigator.pop(context); // Pop loading dialog

        if (result.success) {
          getIt<LogService>().info(
            'Succès paiement abonnement par portefeuille',
            component: 'SubscriptionPage',
          );
          context.read<AuthBloc>().add(AuthRefreshUserRequested());
          context.read<FintechBloc>().add(FetchWalletBalance());
          context.read<FintechBloc>().add(FetchWalletTransactions());

          ToastUtils.showSuccess(context, l10n.walletSubscriptionSuccess);
        } else {
          getIt<LogService>().warning(
            'Échec paiement abonnement par portefeuille: ${result.message}',
            component: 'SubscriptionPage',
          );
          ToastUtils.showError(context, result.message);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Pop loading dialog
        getIt<LogService>().error(
          'Exception paiement abonnement portefeuille',
          component: 'SubscriptionPage',
          error: e,
        );
        ToastUtils.showError(context, l10n.genericError);
      }
    }
  }

  Future<void> _initiatePayment(
    BuildContext context,
    String method,
    ({double amount, String currency, String formattedPrice}) priceInfo, {
    String plan = 'premium',
  }) async {
    Navigator.pop(context); // Close bottom sheet

    final paymentService = getIt<PaymentService>();
    ({String url, String reference})? init;

    try {
      if (method == 'notchpay') {
        getIt<LogService>().info(
          'Action: Initialisation paiement via NotchPay',
          component: 'SubscriptionPage',
        );

        final user = context.read<AuthBloc>().state.authResponse?.user;
        String? phone = user?.phone;

        if (phone == null || phone.trim().isEmpty) {
          final phoneController = TextEditingController();
          final formKey = GlobalKey<FormState>();

          final enteredPhone = await showDialog<String>(
            context: context,
            builder: (dialogCtx) => AlertDialog(
              title: const Text('Numéro Mobile Money'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Veuillez renseigner votre numéro de téléphone (Orange Money ou MTN MoMo) pour valider le paiement.',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: '+237 6XX XX XX XX',
                        prefixIcon: Icon(Icons.phone_android_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 8) {
                          return 'Numéro de téléphone invalide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      Navigator.pop(dialogCtx, phoneController.text.trim());
                    }
                  },
                  child: const Text('Continuer'),
                ),
              ],
            ),
          );

          if (enteredPhone == null || enteredPhone.trim().isEmpty) {
            return;
          }
          phone = enteredPhone;
        }

        init = await paymentService.initializeNotchPay(
          priceInfo.amount,
          currency: priceInfo.currency,
          phone: phone,
          plan: plan,
        );
      } else {
        getIt<LogService>().info(
          'Action: Initialisation paiement via Stripe',
          component: 'SubscriptionPage',
        );
        init = await paymentService.createStripeCheckout(
          priceInfo.amount,
          priceInfo.currency,
          plan: plan,
        );
      }

      if (init != null) {
        final uri = Uri.parse(init.url);
        if (await canLaunchUrl(uri)) {
          _pendingPaymentReference = init.reference;
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (!context.mounted) return;
          ToastUtils.showError(
            context,
            AppLocalizations.of(context)!.paymentInitError,
          );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
      );
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
