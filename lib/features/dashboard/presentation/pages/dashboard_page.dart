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

import '../../../../core/services/notification_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Sync FCM token when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<NotificationService>().syncFcmToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<DashboardBloc>()..add(GetDashboardDataRequested()),
        ),
      ],
      child: MultiBlocListener(
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
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: _buildAppBar(context),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                    GetDashboardDataRequested(),
                  );
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
                      const GamificationHeader(),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildBalanceCard(context)
                            .animate()
                            .fade(duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildQuickActions(context)
                          .animate(delay: 200.ms)
                          .fade(duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
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
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
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
              color: AppColors.textSecondary,
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
          onPressed: () {},
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
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
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
              return Text(
                '${NumberFormat.decimalPattern('fr').format(balance)} FCFA',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final income = state.report?.monthlyIncome ?? 0;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceInfo(
                    context,
                    AppLocalizations.of(context)!.monthlyIncome,
                    NumberFormat.decimalPattern('fr').format(income),
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
                    NumberFormat.decimalPattern(
                      'fr',
                    ).format(state.report?.totalSpent ?? 0),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(BuildContext context, String label, String amount) {
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
          '$amount FCFA',
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
              AppColors.primary,
              onTap: () => context.push('${RouteConstants.investments}/add'),
            ),
            _buildActionItem(
              Icons.bar_chart_outlined,
              AppLocalizations.of(context)!.insights,
              AppColors.secondary,
              onTap: () => context.push(RouteConstants.insights),
            ),
            _buildActionItem(
              Icons.sms_outlined,
              AppLocalizations.of(context)!.importSms,
              AppColors.accent,
              onTap: () async {
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
                color: AppColors.textSecondary,
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
                        '${isIncome ? '+' : '-'}${t.amount.toStringAsFixed(0)} F',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd('fr').format(t.date),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
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
