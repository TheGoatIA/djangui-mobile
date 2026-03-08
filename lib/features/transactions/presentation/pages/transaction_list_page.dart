import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/transactions_bloc.dart';
import '../../data/models/transaction_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../budgets/presentation/bloc/budgets_bloc.dart';
import '../../../budgets/presentation/bloc/budgets_event.dart';
import '../../../goals/presentation/bloc/goals_bloc.dart';
import '../../../goals/presentation/bloc/goals_event.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../payments/presentation/bloc/fintech_bloc.dart';
import '../../../payments/presentation/bloc/fintech_event.dart';
import '../../../payments/presentation/bloc/fintech_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/toast_utils.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featManualTransactions,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.transactions);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.transactions,
            isUpdateRequired: true,
          );
        }
        return const TransactionListView();
      },
    );
  }
}

class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key});

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la liste des transactions.',
      component: 'TransactionListPage',
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
    if (!tutorialService.hasSeenTutorial('transactions')) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_listKey, _addKey]);
        tutorialService.markTutorialAsSeen('transactions');
      });
    }
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactions),
        actions: [
          IconButton(
            onPressed: () {
              getIt<LogService>().info(
                'Rafraîchissement manuel de la liste des transactions (Bouton)',
                component: 'TransactionListPage',
              );
              context.read<TransactionsBloc>().add(
                const GetTransactionsRequested(forceRefresh: true),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.status == TransactionsStatus.loading &&
              state.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransactionsStatus.error &&
              state.transactions.isEmpty) {
            return Center(
              child: Text(
                state.errorMessage ??
                    AppLocalizations.of(context)!.genericError,
              ),
            );
          }

          if (state.transactions.isEmpty) {
            return Center(
              child: Showcase(
                key: _listKey,
                title: AppLocalizations.of(context)!.tutorialTransactionsTitle,
                description: AppLocalizations.of(
                  context,
                )!.tutorialTransactionsDesc,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.emptyTransactions,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noRecentActivities,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return MultiBlocListener(
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
                  } else if (fintechState.status ==
                      FintechStatus.receiptError) {
                    ToastUtils.showError(
                      context,
                      fintechState.message ??
                          AppLocalizations.of(context)!.genericError,
                    );
                  }
                },
              ),
            ],
            child: RefreshIndicator(
              onRefresh: () async {
                getIt<LogService>().info(
                  'Rafraîchissement de la liste des transactions (Pull-to-refresh)',
                  component: 'TransactionListPage',
                );
                context.read<TransactionsBloc>().add(
                  const GetTransactionsRequested(forceRefresh: true),
                );
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.transactions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final transaction = state.transactions[index];
                  final widget = _TransactionItem(transaction: transaction);

                  if (index == 0) {
                    return Showcase(
                      key: _listKey,
                      title: AppLocalizations.of(
                        context,
                      )!.tutorialTransactionsTitle,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialTransactionsDesc,
                      child: widget,
                    );
                  }

                  return widget;
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Showcase(
        key: _addKey,
        title: AppLocalizations.of(context)!.tutorialAddTransactionTitle,
        description: AppLocalizations.of(context)!.tutorialAddTransactionDesc,
        child: FloatingActionButton(
          heroTag: 'transactions_fab',
          onPressed: () async {
            getIt<LogService>().info(
              'Navigation vers la page d\'ajout de transaction depuis la liste',
              component: 'TransactionListPage',
            );
            final refresh = await context.push<bool>(
              '${RouteConstants.transactions}/add',
            );
            if (refresh == true && context.mounted) {
              context.read<TransactionsBloc>().add(
                const GetTransactionsRequested(forceRefresh: true),
              );
              context.read<BudgetsBloc>().add(
                const GetBudgetsRequested(forceRefresh: true),
              );
              context.read<GoalsBloc>().add(
                const GetGoalsRequested(forceRefresh: true),
              );
            }
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
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

class _TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final isManual = transaction.isManualBudgetEntry;
    final isReal = transaction.isRealWalletTransaction;
    final color = isIncome ? AppColors.success : AppColors.error;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        getIt<LogService>().info(
          'Consultation des détails de la transaction: ${transaction.id}',
          component: 'TransactionListPage',
        );
        context.pushNamed(
          RouteConstants.transactionDetails,
          pathParameters: {'id': transaction.id},
          extra: transaction,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isManual
              ? Theme.of(context).colorScheme.surfaceBright
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isManual
              ? Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                )
              : null,
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
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        transaction.category,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isManual) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.manualTransactionBadge,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${CurrencyHelper.formatAmount(transaction.amount, currencyCode: transaction.currency)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd MMM').format(transaction.date),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (isReal) ...[
              const SizedBox(width: 8),
              BlocBuilder<FintechBloc, FintechState>(
                builder: (context, fintechState) {
                  if (fintechState.downloadingReceiptId == transaction.id) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return IconButton(
                    onPressed: () {
                      context.read<FintechBloc>().add(
                        DownloadReceipt(transactionId: transaction.id),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 20),
                    color: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
