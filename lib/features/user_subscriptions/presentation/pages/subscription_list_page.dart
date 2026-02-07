import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/subscription_bloc.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';

/// Page listant les abonnements (factures récurrentes) de l'utilisateur.
///
/// Cette page permet de gérer ses abonnements, d'en ajouter manuellement
/// ou de lancer une détection automatique via les notifications/SMS.
class SubscriptionListPage extends StatefulWidget {
  const SubscriptionListPage({super.key});

  @override
  State<SubscriptionListPage> createState() => _SubscriptionListPageState();
}

class _SubscriptionListPageState extends State<SubscriptionListPage> {
  // Clés utilisées pour le tutoriel interactif.
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _detectKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Chargement initial des abonnements et suivi analytique
      context.read<SubscriptionBloc>().add(GetSubscriptionsRequested());
      _startTutorial();
      getIt<AnalyticsManager>().trackEvent(
        feature: 'Subscription',
        action: 'view_list',
      );
    });
  }

  /// Démarre le tutoriel interactif si l'utilisateur ne l'a pas encore vu.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('subscriptions')) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(
          context,
        ).startShowCase([_detectKey, _listKey, _addKey]);
        tutorialService.markTutorialAsSeen('subscriptions');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featSubscriptions,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.mySubscriptions);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.mySubscriptions,
            isUpdateRequired: true,
          );
        }

        return BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                title: Text(l10n.mySubscriptions),
                actions: [
                  // Bouton de détection automatique "Magique"
                  Showcase(
                    key: _detectKey,
                    title: l10n.tutorialDetectSubscriptionTitle,
                    description: l10n.tutorialDetectSubscriptionDesc,
                    child: IconButton(
                      onPressed: () {
                        getIt<AnalyticsManager>().trackEvent(
                          feature: 'Subscription',
                          action: 'detect_attempt',
                        );
                        context.read<SubscriptionBloc>().add(
                          DetectSubscriptionsRequested(),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome),
                      tooltip: l10n.detectSubscriptions,
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  final bloc = context.read<SubscriptionBloc>();
                  bloc.add(GetSubscriptionsRequested());
                  await bloc.stream.firstWhere(
                    (state) => state.status != SubscriptionStatus.loading,
                  );
                },
                child: Builder(
                  builder: (context) {
                    // État de chargement initial
                    if (state.status == SubscriptionStatus.loading &&
                        state.subscriptions.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Affichage si aucun abonnement n'est enregistré
                    if (state.subscriptions.isEmpty) {
                      return Showcase(
                        key: _listKey,
                        title: l10n.tutorialSubscriptionListTitle,
                        description: l10n.tutorialSubscriptionListDesc,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.subscript_rounded,
                                  size: 80,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noSubscriptionsFound,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Showcase(
                                  key: _addKey,
                                  title: l10n.tutorialAddSubscriptionTitle,
                                  description: l10n.tutorialAddSubscriptionDesc,
                                  child: ElevatedButton.icon(
                                    onPressed: () => context.push(
                                      '${RouteConstants.userSubscriptions}/add',
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: Text(l10n.addSubscription),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // Liste des abonnements actifs
                    return Showcase(
                      key: _listKey,
                      title: l10n.tutorialSubscriptionListTitle,
                      description: l10n.tutorialSubscriptionListDesc,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemCount: state.subscriptions.length,
                        itemBuilder: (context, index) {
                          final sub = state.subscriptions[index];
                          final nextDate = DateFormat.yMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(sub.nextBillingDate);
                          final currency = sub.currency;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(sub.category),
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                sub.provider != null &&
                                        sub.provider!.isNotEmpty &&
                                        sub.provider != sub.name
                                    ? '${sub.name} (${sub.provider})'
                                    : sub.name,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${l10n.paymentLabel} $nextDate',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.repeat,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _getLocalizedFrequency(
                                          sub.frequency,
                                          l10n,
                                        ),
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyHelper.formatAmount(
                                      sub.amount,
                                      currencyCode: currency,
                                    ),
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        sub.status,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getLocalizedStatus(sub.status, l10n),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: _getStatusColor(sub.status),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => context.push(
                                '${RouteConstants.userSubscriptions}/${sub.id}',
                                extra: sub,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // Bouton flottant pour l'ajout rapide
              floatingActionButton: state.subscriptions.isNotEmpty
                  ? Showcase(
                      key: _addKey,
                      title: l10n.tutorialAddSubscriptionTitle,
                      description: l10n.tutorialAddSubscriptionDesc,
                      child: FloatingActionButton(
                        onPressed: () => context.push(
                          '${RouteConstants.userSubscriptions}/add',
                        ),
                        child: const Icon(Icons.add),
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  /// Retourne l'icône appropriée selon la catégorie de l'abonnement.
  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'streaming':
        return Icons.play_circle_outline;
      case 'utilités':
      case 'utilities':
        return Icons.lightbulb_outline;
      case 'santé':
      case 'health':
        return Icons.medical_information_outlined;
      case 'finance':
        return Icons.account_balance_wallet_outlined;
      case 'education':
        return Icons.school_outlined;
      default:
        return Icons.subscriptions_outlined;
    }
  }

  /// Retourne la couleur associée au statut de l'abonnement.
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'paused':
        return AppColors.warning;
      case 'cancelled':
      case 'expired':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  /// Traduit la fréquence de facturation.
  String _getLocalizedFrequency(String frequency, AppLocalizations l10n) {
    switch (frequency.toLowerCase()) {
      case 'weekly':
        return l10n.frequencyWeekly;
      case 'monthly':
        return l10n.frequencyMonthly;
      case 'yearly':
        return l10n.frequencyYearly;
      default:
        return frequency;
    }
  }

  /// Traduit le statut de l'abonnement.
  String _getLocalizedStatus(String? status, AppLocalizations l10n) {
    switch (status?.toLowerCase()) {
      case 'active':
        return l10n.statusActive;
      case 'paused':
        return l10n.statusPaused;
      case 'cancelled':
        return l10n.statusCancelled;
      case 'expired':
        return l10n.statusExpired;
      default:
        return status ?? l10n.active;
    }
  }
}
