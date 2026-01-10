import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../transactions/presentation/bloc/transactions_bloc.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../../gamification/presentation/widgets/gamification_header.dart';
import '../../../gamification/presentation/widgets/level_up_dialog.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../core/services/sms_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/services/notification_service.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/utils/currency_helper.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DashboardBloc>()..add(GetDashboardDataRequested()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey _gamificationKey = GlobalKey();
  final GlobalKey _balanceKey = GlobalKey();
  final GlobalKey _quickActionsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Sync FCM token when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<NotificationService>().syncFcmToken();
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Watch for tutorial reset
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    super.dispose();
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('dashboard')) {
      try {
        final shell = StatefulNavigationShell.of(context);
        if (shell.currentIndex != 0) return;
      } catch (_) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(
          context,
        ).startShowCase([_gamificationKey, _balanceKey, _quickActionsKey]);
        tutorialService.markTutorialAsSeen('dashboard');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.unauthenticated) {
              context.go(RouteConstants.login);
            }
          },
        ),
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
        BlocListener<TransactionsBloc, TransactionsState>(
          listenWhen: (previous, current) =>
              current.status == TransactionsStatus.success &&
              previous.status != TransactionsStatus.success,
          listener: (context, state) {
            // Refresh dashboard when a transaction is added/updated successfully
            context.read<DashboardBloc>().add(GetDashboardDataRequested());
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            // Listen for significant profile changes that affect dashboard (e.g. monthlyIncome)
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
            context.read<DashboardBloc>().add(GetDashboardDataRequested());
            context.read<TransactionsBloc>().add(
              const GetTransactionsRequested(forceRefresh: true),
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Showcase(
                  key: _gamificationKey,
                  title: AppLocalizations.of(
                    context,
                  )!.tutorialGamificationTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.tutorialGamificationDesc,
                  child: const GamificationHeader(),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                      Showcase(
                            key: _balanceKey,
                            title: AppLocalizations.of(
                              context,
                            )!.tutorialBalanceCardTitle,
                            description: AppLocalizations.of(
                              context,
                            )!.tutorialBalanceCardDesc,
                            child: _buildBalanceCard(context),
                          )
                          .animate()
                          .fade(duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                ),
                const SizedBox(height: 24),
                Showcase(
                      key: _quickActionsKey,
                      title: AppLocalizations.of(
                        context,
                      )!.tutorialQuickActionsTitle,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialQuickActionsDesc,
                      child: _buildQuickActions(context),
                    )
                    .animate(delay: 200.ms)
                    .fade(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  context,
                  AppLocalizations.of(context)!.recentActivities,
                  () => context.push(RouteConstants.transactions),
                ).animate(delay: 300.ms).fade(),
                const SizedBox(height: 16),
                _buildRecentActivities(context)
                    .animate(delay: 400.ms)
                    .fade(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.greeting,
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
        IconButton(
          onPressed: () => context.push(RouteConstants.notifications),
          icon: Icon(
            Icons.notifications_none_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () =>
                context.read<AuthBloc>().add(AuthLogoutRequested()),
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
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
          Text(
            AppLocalizations.of(context)!.totalBalance,
            style: AppTextStyles.labelLarge.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final balance = state.report?.walletBalance ?? 0;
              final userCurrency = context
                  .read<AuthBloc>()
                  .state
                  .authResponse
                  ?.user
                  .currency;

              return Text(
                CurrencyHelper.formatAmount(
                  balance.toDouble(),
                  currencyCode: userCurrency,
                ),
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

  Widget _buildBalanceInfo(BuildContext context, String label, double amount) {
    final userCurrency = context
        .read<AuthBloc>()
        .state
        .authResponse
        ?.user
        .currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyHelper.formatAmount(amount, currencyCode: userCurrency),
          style: AppTextStyles.bodyLarge.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.quickActions,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionItem(
              Icons.add_circle_outline,
              AppLocalizations.of(context)!.invest,
              Theme.of(context).colorScheme.primary,
              onTap: () => context.push('${RouteConstants.investments}/add'),
            ),
            _buildActionItem(
              Icons.bar_chart_outlined,
              AppLocalizations.of(context)!.insights,
              Theme.of(context).colorScheme.secondary,
              onTap: () => context.push(RouteConstants.insights),
            ),
            _buildActionItem(
              Icons.sms_outlined,
              AppLocalizations.of(context)!.importSms,
              Theme.of(context).colorScheme.tertiary,
              onTap: () async {
                final authState = context.read<AuthBloc>().state;
                final isPremium =
                    authState.authResponse?.user.isPremium ?? false;

                if (!isPremium) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.smsImportPremiumRestriction,
                      ),
                      action: SnackBarAction(
                        label: AppLocalizations.of(context)!.seeOffers,
                        onPressed: () =>
                            context.push(RouteConstants.subscription),
                      ),
                    ),
                  );
                  return;
                }

                if (!Platform.isAndroid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.featureNotAvailableOnIos,
                      ),
                    ),
                  );
                  return;
                }
                final smsService = getIt<SMSService>();
                final granted = await smsService.requestPermission();
                if (granted) {
                  // Show loading
                  if (!context.mounted) return;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.scanningSms,
                        ),
                      ),
                    );
                  }

                  final transactions = await smsService.getRecentTransactions();
                  if (transactions.isNotEmpty) {
                    // Automatically add the first one for demo or show a picker
                    // For now, let's add them via TransactionsBloc
                    if (!context.mounted) return;
                    for (final t in transactions) {
                      context.read<TransactionsBloc>().add(
                        AddTransactionRequested(
                          TransactionModel(
                            id: const Uuid().v4(),
                            amount: t.amount,
                            type: 'expense',
                            category: AppLocalizations.of(context)!.automatic,
                            description: t.description,
                            date: t.date,
                          ),
                        ),
                      );
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.transactionsImported(transactions.length),
                          ),
                        ),
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.smsPermissionRequired,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            _buildActionItem(
              Icons.smart_toy_outlined,
              AppLocalizations.of(context)!.coach,
              Colors.indigo,
              onTap: () => context.push(RouteConstants.coach),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.card,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(AppLocalizations.of(context)!.seeAll),
        ),
      ],
    );
  }

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
                        Text(
                          t.category,
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
