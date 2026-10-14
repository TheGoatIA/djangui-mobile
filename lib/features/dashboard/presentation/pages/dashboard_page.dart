import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/widgets/transaction_status_badge.dart';
import '../../../../di/injection.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../transactions/presentation/bloc/transactions_bloc.dart';
import '../../../gamification/presentation/widgets/gamification_header.dart';
import '../../../gamification/presentation/widgets/level_up_dialog.dart';
import '../../../user_subscriptions/presentation/bloc/subscription_bloc.dart';
import '../../../user_subscriptions/presentation/widgets/next_invoices_widget.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../system/data/models/feature_flag_model.dart';

import '../bloc/dashboard_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/features/settings/presentation/bloc/settings_bloc.dart';
import '../../../payments/presentation/bloc/fintech_bloc.dart';
import '../../../payments/presentation/bloc/fintech_state.dart';
import '../../../payments/presentation/bloc/fintech_event.dart';
import '../widgets/real_money_welcome_carousel.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

/// Page d'accueil (Tableau de bord) de l'application.
///
/// Cette page centralise les informations financières de l'utilisateur :
/// solde, revenus, dépenses, abonnements à venir et activités récentes.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardView();
  }
}

/// Vue détaillée du tableau de bord avec gestion du tutoriel (Showcase).
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with WidgetsBindingObserver, SecureScreenMixin<DashboardView> {
  // Clés utilisées pour le tutoriel interactif (Showcase)
  final GlobalKey _gamificationKey = GlobalKey();
  final GlobalKey _balanceKey = GlobalKey();
  final GlobalKey _quickActionsKey = GlobalKey();
  final GlobalKey _incomeKey = GlobalKey();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Synchronisation du jeton de notification et suivi analytique
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<LogService>().info(
        'Affichage du tableau de bord principal.',
        component: 'DashboardPage',
      );
      getIt<NotificationService>().syncFcmToken();
      getIt<AnalyticsManager>().trackEvent(
        feature: 'Dashboard',
        action: 'view',
      );
      // Petit délai pour laisser la session et les tokens se stabiliser au démarrage
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.read<FintechBloc>().add(FetchWalletBalance());
          context.read<TransactionsBloc>().add(
            const GetTransactionsRequested(forceRefresh: true),
          );
          context.read<DashboardBloc>().add(GetDashboardDataRequested());
        }
      });
      _checkAndShowWelcomeModal();
      _startTutorial();
    });
  }

  void _checkAndShowWelcomeModal() async {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('real_money_welcome')) {
      final user = context.read<AuthBloc>().state.authResponse?.user;
      // Server-driven: the admin can flip real-money mode on/off at any time
      // (see SystemBloc's featureFlags, fetched at splash from GET /config/features).
      // Falls back to EnvConfig.enableRealMoney (default: false) if the flags
      // fetch itself fails — assume simulation mode, not real money, when unsure.
      final featureFlags = context.read<SystemBloc>().state.featureFlags;
      final isRealMoneyEnabled = featureFlags.featRealMoney.isEnabled;
      // Same allowlist the server actually enforces (never a hardcoded
      // country/currency literal here) — see the equivalent fix in
      // app_router.dart. Otherwise this popup could tell a user real money
      // has arrived for them while the server still rejects their deposits.
      final isCountryAllowed =
          user != null &&
          featureFlags.realMoneyCountries.contains(user.country);
      if (isRealMoneyEnabled && isCountryAllowed) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RealMoneyWelcomeCarousel(),
        );
        tutorialService.markTutorialAsSeen('real_money_welcome');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Relance le tutoriel si le service de tutoriel est réinitialisé
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void dispose() {
    // Ferme les infobulles du tutoriel si la page est quittée
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  /// Démarre le tutoriel interactif si l'utilisateur ne l'a pas encore vu sur cet écran.
  ///
  /// La liste des cibles est recalculée à chaque appel à partir de l'état
  /// courant (feature flags, pays, ordre du dashboard choisi par
  /// l'utilisateur) : une carte masquée (flag désactivé, section retirée par
  /// l'utilisateur, pays non éligible) ne doit jamais être incluse, sinon la
  /// séquence entière reste bloquée sur cette étape.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('dashboard_v2')) return;
    try {
      final shell = StatefulNavigationShell.of(context);
      if (shell.currentIndex != 0) return;
    } catch (_) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final order = context.read<SettingsBloc>().state.dashboardOrder;
      final flags = context.read<SystemBloc>().state.featureFlags;
      final isCameroon =
          context.read<AuthBloc>().state.authResponse?.user.country == 'CM';

      final l10n = AppLocalizations.of(context)!;
      final steps = <TutorialStep>[
        if (order.contains('gamification') && flags.featGamification.isEnabled)
          TutorialStep(
            targetKey: _gamificationKey,
            title: l10n.tutorialGamificationTitle,
            description: l10n.tutorialGamificationDesc,
          ),
        if (order.contains('balance') && isCameroon) ...[
          TutorialStep(
            targetKey: _balanceKey,
            title: l10n.tutorialBalanceCardTitle,
            description: l10n.tutorialBalanceCardDesc,
          ),
          TutorialStep(
            targetKey: _incomeKey,
            title: l10n.tutorialIncomeTitle,
            description: l10n.tutorialIncomeDesc,
            shape: const CircleBorder(),
          ),
        ],
        TutorialStep(
          targetKey: _quickActionsKey,
          title: l10n.tutorialQuickActionsTitle,
          description: l10n.tutorialQuickActionsDesc,
        ),
      ];
      tutorialService.startTutorial(context, 'dashboard_v2', steps);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Écoute les changements d'état d'authentification
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.unauthenticated) {
              context.read<TransactionsBloc>().add(ResetTransactionsStatus());
              context.go(RouteConstants.login);
            } else if (state.status == AuthStatus.authenticated) {
              // On attend un court instant pour que le token soit bien propagé dans les intercepteurs
              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  context.read<FintechBloc>().add(FetchWalletBalance());
                  context.read<DashboardBloc>().add(
                    GetDashboardDataRequested(),
                  );
                }
              });
            }
          },
        ),
        // Affiche un dialogue en cas de montée de niveau (gamification)
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            return previous.status == AuthStatus.authenticated &&
                current.status == AuthStatus.authenticated &&
                previous.authResponse?.user != null &&
                current.authResponse?.user != null &&
                current.authResponse!.user.level >
                    previous.authResponse!.user.level;
          },
          listener: (context, state) {
            showDialog(
              context: context,
              builder: (_) => LevelUpDialog(
                newLevel: state.authResponse!.user.level,
                onContinue: () => Navigator.of(context).pop(),
              ),
            );
          },
        ),
        // Actualise le dashboard après des modifications de données
        BlocListener<TransactionsBloc, TransactionsState>(
          listenWhen: (previous, current) =>
              current.status == TransactionsStatus.success &&
              previous.status != TransactionsStatus.success,
          listener: (context, state) {
            context.read<DashboardBloc>().add(GetDashboardDataRequested());
          },
        ),
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listenWhen: (previous, current) =>
              current.status == SubscriptionStatus.success &&
              previous.status != SubscriptionStatus.success,
          listener: (context, state) {
            context.read<DashboardBloc>().add(GetDashboardDataRequested());
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            if (previous.authResponse?.user == null ||
                current.authResponse?.user == null) {
              return false;
            }
            return previous.authResponse!.user != current.authResponse!.user;
          },
          listener: (context, state) {
            context.read<DashboardBloc>().add(GetDashboardDataRequested());
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<FintechBloc>().add(FetchWalletBalance());
            context.read<DashboardBloc>().add(GetDashboardDataRequested());
            context.read<TransactionsBloc>().add(
              const GetTransactionsRequested(forceRefresh: true),
            );
          },
          child: BlocBuilder<SystemBloc, SystemState>(
            builder: (context, systemState) {
              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  final widgets = _buildDashboardWidgets(
                    context,
                    settingsState.dashboardOrder,
                    systemState.featureFlags,
                  );

                  if (_isEditing) {
                    return ReorderableListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      onReorderItem: (oldIndex, newIndex) {
                        final items = List<String>.from(
                          settingsState.dashboardOrder,
                        );
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                        context.read<SettingsBloc>().add(
                          UpdateDashboardOrder(items),
                        );
                      },
                      children: widgets
                          .asMap()
                          .entries
                          .map(
                            (entry) => Material(
                              key: ValueKey(
                                settingsState.dashboardOrder[entry.key],
                              ),
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Opacity(opacity: 0.7, child: entry.value),
                                    const Positioned.fill(
                                      child: Center(
                                        child: Icon(
                                          Icons.drag_indicator,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widgets,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDashboardWidgets(
    BuildContext context,
    List<String> order,
    FeatureFlagModel flags,
  ) {
    final Map<String, Widget> widgetMap = {
      'gamification': flags.featGamification.isEnabled
          ? KeyedSubtree(
              key: _gamificationKey,
              child: const GamificationHeader(),
            )
          : const SizedBox.shrink(),
      'balance':
          BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final isCameroon =
                      authState.authResponse?.user.country == 'CM';
                  if (!isCameroon) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: KeyedSubtree(
                      key: _balanceKey,
                      child: GestureDetector(
                        onTap: () async {
                          await context.push(RouteConstants.wallet);
                          if (context.mounted) {
                            context.read<FintechBloc>().add(
                              FetchWalletBalance(),
                            );
                            context.read<DashboardBloc>().add(
                              GetDashboardDataRequested(),
                            );
                          }
                        },
                        child: _buildBalanceCard(context),
                      ),
                    ),
                  );
                },
              )
              .animate()
              .fade(duration: 500.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
      'invoices': flags.featSubscriptions.isEnabled
          ? const NextInvoicesWidget()
                .animate(delay: 100.ms)
                .fade(duration: 500.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad)
          : const SizedBox.shrink(),
      'quick_actions':
          KeyedSubtree(
                key: _quickActionsKey,
                child: _buildQuickActions(context, flags),
              )
              .animate(delay: 200.ms)
              .fade(duration: 500.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
      'other_tools': _buildOtherToolsCard(context, flags)
          .animate(delay: 250.ms)
          .fade(duration: 500.ms)
          .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
      'recent_activities': Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            context,
            AppLocalizations.of(context)!.recentActivities,
            action:
                context
                    .watch<SystemBloc>()
                    .state
                    .featureFlags
                    .featManualTransactions
                    .isEnabled
                ? TextButton.icon(
                    onPressed: () =>
                        context.push(RouteConstants.addTransaction),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: Text(
                      AppLocalizations.of(context)!.add,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ).animate(delay: 300.ms).fade(),
          const SizedBox(height: 16),
          _buildRecentActivities(context)
              .animate(delay: 400.ms)
              .fade(duration: 500.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  getIt<LogService>().info(
                    'Navigation vers la liste complète des transactions',
                    component: 'DashboardPage',
                  );
                  context.push(RouteConstants.transactions);
                },
                icon: const Icon(Icons.list_alt),
                label: Text(AppLocalizations.of(context)!.manageTransactions),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ).animate(delay: 500.ms).fade(),
        ],
      ),
    };

    return order
        .map((id) => widgetMap[id] ?? const SizedBox())
        .map(
          (w) =>
              Padding(padding: const EdgeInsets.only(bottom: 24.0), child: w),
        )
        .toList();
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final localizations = AppLocalizations.of(context)!;

    if (hour >= 6 && hour < 12) {
      return localizations.greetingMorning;
    } else if (hour >= 12 && hour < 18) {
      return localizations.greetingAfternoon;
    } else {
      return localizations.greetingEvening;
    }
  }

  /// Construit la barre d'application avec salutations, notifications et bouton déconnexion.
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(context),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final userName =
                  state.authResponse?.user.fullName ??
                  AppLocalizations.of(context)!.user;
              return Text(
                userName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        BlocBuilder<SystemBloc, SystemState>(
          builder: (context, systemState) {
            if (!systemState.featureFlags.featNotifications.isEnabled) {
              return const SizedBox.shrink();
            }
            return BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                return Badge(
                  label: Text(state.unreadCount.toString()),
                  isLabelVisible: state.unreadCount > 0,
                  child: IconButton(
                    onPressed: () {
                      getIt<LogService>().info(
                        'Navigation vers les notifications',
                        component: 'DashboardPage',
                      );
                      context.push(RouteConstants.notifications);
                    },
                    icon: Icon(
                      Icons.notifications_none_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            );
          },
        ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              getIt<LogService>().info(
                'Demande de déconnexion (App Bar)',
                component: 'DashboardPage',
              );
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState.authResponse?.user.isPremium ?? false) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                icon: Icon(
                  _isEditing ? Icons.check_circle : Icons.tune_rounded,
                  color: _isEditing
                      ? AppColors.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.totalBalance,
                style: AppTextStyles.labelLarge.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.walletTitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<FintechBloc, FintechState>(
            builder: (context, state) {
              final balance = state.balance;

              final userCurrency = context
                  .read<AuthBloc>()
                  .state
                  .authResponse
                  ?.user
                  .currency;

              final systemState = context.watch<SystemBloc>().state;
              String? currencySymbol;
              if (systemState.countries.isNotEmpty) {
                currencySymbol = systemState.countries
                    .firstWhere(
                      (c) => c.currency == userCurrency,
                      orElse: () => systemState.countries.firstWhere(
                        (c) => c.code == 'CM', // Cameroun par défaut
                        orElse: () => systemState.countries.first,
                      ),
                    )
                    .currencySymbol;
              }

              final isLoading =
                  state.status == FintechStatus.loading ||
                  state.status == FintechStatus.initial ||
                  (state.status == FintechStatus.error && state.balance == 0);
              final displayBalance = isLoading ? null : balance;

              return Text(
                displayBalance != null
                    ? CurrencyHelper.formatAmount(
                        displayBalance,
                        currencyCode: userCurrency,
                        currencySymbol: currencySymbol,
                      )
                    : '---',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final income = state.report?.monthlyIncome ?? 0;
              final spent = state.report?.totalSpent ?? 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceInfo(
                    context,
                    AppLocalizations.of(context)!.monthlyIncome,
                    income.toDouble(),
                    isIncome: true,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.24),
                  ),
                  _buildBalanceInfo(
                    context,
                    AppLocalizations.of(context)!.totalExpenses,
                    spent.toDouble(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Construit un élément d'information (Revenu ou Dépense) pour la carte de solde.
  Widget _buildBalanceInfo(
    BuildContext context,
    String label,
    double amount, {
    bool isIncome = false,
  }) {
    final userCurrency = context
        .read<AuthBloc>()
        .state
        .authResponse
        ?.user
        .currency;

    final systemState = context.watch<SystemBloc>().state;
    String? currencySymbol;
    if (systemState.countries.isNotEmpty) {
      currencySymbol = systemState.countries
          .firstWhere(
            (c) => c.currency == userCurrency,
            orElse: () => systemState.countries.first,
          )
          .currencySymbol;
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.7),
              ),
            ),
            if (isIncome) ...[
              const SizedBox(width: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    getIt<LogService>().info(
                      'Ouverture du dialogue de mise à jour du revenu',
                      component: 'DashboardPage',
                    );
                    _showEditIncomeDialog(context, amount);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyHelper.formatAmount(
            amount,
            currencyCode: userCurrency,
            currencySymbol: currencySymbol,
          ),
          style: AppTextStyles.bodyLarge.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    // Cible du tutoriel si c'est la section Revenus
    if (isIncome) {
      return KeyedSubtree(key: _incomeKey, child: content);
    }

    return content;
  }

  /// Affiche une boîte de dialogue pour mettre à jour le revenu mensuel estimé.
  void _showEditIncomeDialog(BuildContext context, double currentAmount) {
    final controller = TextEditingController(
      text: currentAmount > 0 ? currentAmount.toStringAsFixed(0) : '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.updateIncomeTitle),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.incomeLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.money_sharp),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.invalidAmount;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final amount = double.tryParse(controller.text) ?? 0.0;
                getIt<LogService>().info(
                  'Mise à jour du revenu mensuel: $amount',
                  component: 'DashboardPage',
                );
                context.read<AuthBloc>().add(
                  AuthUpdateProfileRequested(monthlyIncome: amount),
                );
                Navigator.of(context).pop();
              } else {
                getIt<LogService>().warning(
                  'Échec de validation du formulaire de revenu',
                  component: 'DashboardPage',
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  /// Construit la ligne des boutons d'actions rapides.
  Widget _buildQuickActions(BuildContext context, FeatureFlagModel flags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.quickActions,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final tontinesStatus = context.read<SystemBloc>().getFeatureStatus(
              flags.featTontines,
            );
            final subscriptionsStatus = context
                .read<SystemBloc>()
                .getFeatureStatus(flags.featSubscriptions);
            final coachStatus = context.read<SystemBloc>().getFeatureStatus(
              flags.aiCoachChat,
            );

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (tontinesStatus != FeatureStatus.disabled)
                        _buildActionItem(
                          Icons.groups_outlined,
                          AppLocalizations.of(context)!.tontine,
                          Theme.of(context).colorScheme.tertiary,
                          isUpdateRequired:
                              tontinesStatus == FeatureStatus.updateRequired,
                          onTap: () => context.push(RouteConstants.tontines),
                        ),
                      _buildActionItem(
                        Icons.storefront_rounded,
                        'Revendeur',
                        AppColors.primary,
                        onTap: () => context.push(RouteConstants.resellerHub),
                      ),
                      if (subscriptionsStatus != FeatureStatus.disabled)
                        _buildActionItem(
                          Icons.receipt_long_outlined,
                          AppLocalizations.of(context)!.subscriptions,
                          Colors.orange,
                          isUpdateRequired:
                              subscriptionsStatus ==
                              FeatureStatus.updateRequired,
                          onTap: () =>
                              context.push(RouteConstants.userSubscriptions),
                        ),
                      if (coachStatus != FeatureStatus.disabled)
                        _buildActionItem(
                          Icons.smart_toy_outlined,
                          AppLocalizations.of(context)!.coach,
                          Colors.indigo,
                          isUpdateRequired:
                              coachStatus == FeatureStatus.updateRequired,
                          onTap: () => context.push(RouteConstants.coach),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Construit la carte "Autres outils" pour regrouper Investir, Analyses, etc.
  Widget _buildOtherToolsCard(BuildContext context, FeatureFlagModel flags) {
    final investmentsStatus = context.read<SystemBloc>().getFeatureStatus(
      flags.featInvestments,
    );
    final insightsStatus = context.read<SystemBloc>().getFeatureStatus(
      flags.aiInsights,
    );

    final hasVisibleTools =
        investmentsStatus != FeatureStatus.disabled ||
        insightsStatus != FeatureStatus.disabled;

    if (!hasVisibleTools) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.otherTools,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.card,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                if (investmentsStatus != FeatureStatus.disabled)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (investmentsStatus == FeatureStatus.updateRequired) {
                          _showUpdateRequiredDialog(context);
                        } else {
                          context.push('${RouteConstants.investments}/add');
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppLocalizations.of(context)!.invest,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (investmentsStatus != FeatureStatus.disabled &&
                    insightsStatus != FeatureStatus.disabled)
                  const SizedBox(width: 12),
                if (insightsStatus != FeatureStatus.disabled)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (insightsStatus == FeatureStatus.updateRequired) {
                          _showUpdateRequiredDialog(context);
                        } else {
                          context.push(RouteConstants.insights);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.insights_rounded,
                              color: Colors.blue,
                              size: 26,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppLocalizations.of(context)!.insights,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un bouton d'action individuel pour la section d'actions rapides.
  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
    bool isUpdateRequired = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isUpdateRequired) {
          _showUpdateRequiredDialog(context);
        } else {
          onTap?.call();
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.card,
            ),
            child: Opacity(
              opacity: isUpdateRequired ? 0.5 : 1.0,
              child: Icon(icon, color: color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: isUpdateRequired ? Colors.grey : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchStore() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;

    // ID réel de l'App Store
    const String appId = "6757806640";

    final Uri playStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );
    final Uri appStoreUri = Uri.parse('https://apps.apple.com/app/id$appId');

    final Uri url = Platform.isAndroid ? playStoreUri : appStoreUri;

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showUpdateRequiredDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.featureDisabledTitle),
        content: Text("${l10n.featureDisabledMessage} (Version requise)"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.back),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchStore();
            },
            child: Text("Mettre à jour"),
          ),
        ],
      ),
    );
  }

  /// Construit un en-tête de section avec un titre et une action optionnelle.
  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (action != null) ...[const SizedBox(width: 8), action],
            ],
          ),
        ],
      ),
    );
  }

  /// Construit la liste des dernières transactions enregistrées.
  Widget _buildRecentActivities(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state.status == TransactionsStatus.loading &&
            state.transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.transactions.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noRecentActivities,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        // Affiche uniquement les 3 dernières transactions sur le tableau de bord
        final recentTransactions = state.transactions.take(3).toList();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentTransactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final t = recentTransactions[index];
            final isIncome = t.type == 'income';
            final color = isIncome ? AppColors.success : AppColors.error;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              t.category,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 6),
                            TransactionStatusBadge(
                              status: t.status,
                              compact: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'}${CurrencyHelper.formatAmount(t.amount, currencyCode: context.read<AuthBloc>().state.authResponse?.user.currency)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd('fr').format(t.date),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );
  }
}
