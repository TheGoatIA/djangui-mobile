import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/core/widgets/glass_card.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_event.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_state.dart';
import 'package:kauri/features/payments/data/models/fintech_models.dart';
import 'package:kauri/features/payments/presentation/bloc/payment_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/payment_state.dart';
import 'package:kauri/features/payments/presentation/bloc/payment_event.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kauri/core/mixins/secure_screen_mixin.dart';
import 'package:kauri/core/widgets/debounced_button.dart';
import 'package:kauri/core/utils/currency_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:kauri/core/widgets/tutorial/tutorial_step.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/core/services/tutorial_service.dart';
import 'package:go_router/go_router.dart';
import 'package:kauri/core/constants/route_constants.dart';
import 'package:kauri/core/widgets/transaction_status_badge.dart';
import 'package:kauri/features/system/presentation/bloc/system_bloc.dart';

class WalletDashboardPage extends StatefulWidget {
  const WalletDashboardPage({super.key});

  @override
  State<WalletDashboardPage> createState() => _WalletDashboardPageState();
}

class _WalletDashboardPageState extends State<WalletDashboardPage>
    with WidgetsBindingObserver, SecureScreenMixin<WalletDashboardPage> {
  bool _showAllTransactions = false;
  final GlobalKey _rechargeKey = GlobalKey();
  bool _isAwaitingPaymentReturn = false;
  // Tracked locally (rather than derived purely from state) so the popup is
  // popped exactly once and before any success/error feedback is shown for
  // the same state transition — see the FintechBloc listener below.
  bool _isWithdrawDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<FintechBloc>().add(FetchWalletBalance());
    context.read<FintechBloc>().add(FetchWalletTransactions());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
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

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('wallet_recharge')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'wallet_recharge', [
        TutorialStep(
          targetKey: _rechargeKey,
          title: l10n.tutorialWalletRechargeTitle,
          description: l10n.tutorialWalletRechargeDesc,
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<FintechBloc>().add(FetchWalletBalance());
      context.read<FintechBloc>().add(FetchWalletTransactions());

      if (_isAwaitingPaymentReturn) {
        _isAwaitingPaymentReturn = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vérification de votre paiement en cours...'),
            duration: const Duration(seconds: 4),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            context.read<FintechBloc>().add(FetchWalletBalance());
            context.read<FintechBloc>().add(FetchWalletTransactions());
          }
        });

        Future.delayed(const Duration(seconds: 8), () {
          if (mounted) {
            context.read<FintechBloc>().add(FetchWalletBalance());
            context.read<FintechBloc>().add(FetchWalletTransactions());
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: 'XAF',
      decimalDigits: 0,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.loading)),
              );
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is PaymentSuccess) {
              _handlePaymentRedirection(state.response.url);
            }
          },
        ),
        BlocListener<FintechBloc, FintechState>(
          listener: (context, state) {
            // Popup de chargement pendant le retrait : ouvert dès que le bloc
            // signale le début du traitement, refermé dès qu'il se termine —
            // toujours AVANT d'afficher le résultat (snackbar/dialogue
            // ci-dessous), pour ne jamais empiler les deux dialogues.
            if (!_isWithdrawDialogShowing && state.isProcessingWithdrawal) {
              _isWithdrawDialogShowing = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => PopScope(
                  canPop: false,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.withdrawInProgress,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.withdrawInProgressHint,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (_isWithdrawDialogShowing &&
                !state.isProcessingWithdrawal) {
              _isWithdrawDialogShowing = false;
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state.status == FintechStatus.withdrawalSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message ??
                        AppLocalizations.of(context)!.withdrawSuccess,
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<FintechBloc>().add(FetchWalletBalance());
              context.read<FintechBloc>().add(FetchWalletTransactions());
            } else if (state.status == FintechStatus.withdrawalError ||
                (state.status == FintechStatus.error &&
                    state.message != null)) {
              final isKycError = state.message != null &&
                  (state.message!.toLowerCase().contains('kyc') ||
                      state.message!.toLowerCase().contains('identité'));
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: Icon(
                    isKycError
                        ? Icons.verified_user_outlined
                        : Icons.error_outline_rounded,
                    color: isKycError ? AppColors.primary : Colors.red,
                    size: 48,
                  ),
                  title: Builder(
                    builder: (context) {
                      final kycLevel = context
                              .read<AuthBloc>()
                              .state
                              .authResponse
                              ?.user
                              .kycLevel ??
                          'none';
                      if (isKycError && kycLevel == 'pending') {
                        return const Text(
                          'Vérification KYC en cours',
                          textAlign: TextAlign.center,
                        );
                      }
                      return Text(
                        isKycError ? 'Vérification KYC requise' : 'Retrait échoué',
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  content: Builder(
                    builder: (context) {
                      final kycLevel = context
                              .read<AuthBloc>()
                              .state
                              .authResponse
                              ?.user
                              .kycLevel ??
                          'none';
                      if (isKycError && kycLevel == 'pending') {
                        return const Text(
                          'Vos documents d\'identité sont actuellement en cours d\'examen par notre équipe de conformité (24h à 48h). Les retraits seront automatiquement débloqués dès validation.',
                          textAlign: TextAlign.center,
                        );
                      }
                      return Text(
                        state.message ??
                            'Une erreur est survenue. Veuillez réessayer.',
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    if (isKycError) ...[
                      Builder(
                        builder: (context) {
                          final kycLevel = context
                                  .read<AuthBloc>()
                                  .state
                                  .authResponse
                                  ?.user
                                  .kycLevel ??
                              'none';
                          if (kycLevel == 'pending') {
                            return ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Compris'),
                            );
                          }
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Plus tard'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.push(RouteConstants.kycSubmission);
                                },
                                child: const Text('Vérifier mon KYC'),
                              ),
                            ],
                          );
                        },
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Compris'),
                      ),
                    ],
                  ],
                ),
              );
            } else if (state.status == FintechStatus.receiptReady &&
                state.message != null) {
              launchUrl(
                Uri.parse(state.message!),
                mode: LaunchMode.externalApplication,
              );
            } else if (state.status == FintechStatus.receiptError &&
                state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.walletTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<FintechBloc>().add(FetchWalletBalance());
                context.read<FintechBloc>().add(FetchWalletTransactions());
              },
            ),
          ],
        ),
        body: BlocBuilder<FintechBloc, FintechState>(
          builder: (context, state) {
            final realTransactions = state.transactions
                .where((t) => t.isRealWalletTransaction)
                .toList();
            final balance = state.balance;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FintechBloc>().add(FetchWalletBalance());
                context.read<FintechBloc>().add(FetchWalletTransactions());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(
                      balance,
                      realTransactions,
                      currencyFormat,
                    ),
                    BlocBuilder<SystemBloc, SystemState>(
                      builder: (context, systemState) {
                        if (systemState.featureFlags.featRealMoney.isEnabled) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildSimulationModeBanner(),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildQuickActions(),
                    const SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.recentTransactions,
                      style: AppTextStyles.h3.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    _buildTransactionList(
                      state,
                      realTransactions,
                      currencyFormat,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    double balance,
    List<FintechTransactionModel> transactions,
    NumberFormat format,
  ) {
    // Dynamic calculation of incomes and outcomes (ignoring failed, cancelled transactions and technical refunds)
    final validTransactions = transactions.where((t) {
      final s = t.status.toLowerCase().trim();
      return s != 'failed' && s != 'cancelled' && s != 'canceled' && s != 'rejected';
    });

    final incomes = validTransactions
        .where(
          (t) =>
              (t.type == 'credit' ||
                  t.type == 'deposit' ||
                  t.type == 'income') &&
              !t.description.toLowerCase().contains('remboursement') &&
              !t.description.toLowerCase().contains('refund'),
        )
        .fold(0.0, (sum, t) => sum + t.amount);
    final outcomes = validTransactions
        .where(
          (t) =>
              (t.type == 'debit' ||
                  t.type == 'withdrawal' ||
                  t.type == 'expense') &&
              !t.description.toLowerCase().contains('remboursement') &&
              !t.description.toLowerCase().contains('refund'),
        )
        .fold(0.0, (sum, t) => sum + t.amount);

    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
              AppLocalizations.of(context)!.availableBalance,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              format.format(balance),
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildBalanceIndicator(
                    label: AppLocalizations.of(context)!.incomes,
                    amount: incomes,
                    icon: Icons.arrow_downward,
                    color: Colors.greenAccent,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                Expanded(
                  child: _buildBalanceIndicator(
                    label: AppLocalizations.of(context)!.outcomes,
                    amount: outcomes,
                    icon: Icons.arrow_upward,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceIndicator({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    final format = NumberFormat.compact(locale: 'fr_FR');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${format.format(amount)} CFA',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationModeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mode Portefeuille Virtuel — dépôts et retraits réels désactivés',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: KeyedSubtree(
            key: _rechargeKey,
            child: _buildActionBtn(
              icon: Icons.add_circle_outline,
              label: AppLocalizations.of(context)!.recharge,
              onTap: () => _showRechargeDialog(),
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionBtn(
            icon: Icons.file_upload_outlined,
            label: AppLocalizations.of(context)!.withdraw,
            onTap: () => _showWithdrawDialog(),
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(
    FintechState state,
    List<FintechTransactionModel> realTransactions,
    NumberFormat format,
  ) {
    if (state.status == FintechStatus.loading && realTransactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (realTransactions.isEmpty) {
      return _buildEmptyState();
    }

    final displayTransactions = _showAllTransactions
        ? realTransactions
        : realTransactions.take(10).toList();

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayTransactions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tx = displayTransactions[index];
            return _buildTransactionItem(tx, format, state);
          },
        ),
        if (!_showAllTransactions && realTransactions.length > 10)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllTransactions = true;
                });
              },
              child: Text(
                'Voir plus',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionItem(
    FintechTransactionModel tx,
    NumberFormat format,
    FintechState state,
  ) {
    final isCredit =
        tx.type == 'credit' || tx.type == 'deposit' || tx.type == 'income';
    final isCash = tx.type == 'cash';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCash
                  ? Colors.grey.withValues(alpha: 0.1)
                  : (isCredit
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCash ? Icons.history : (isCredit ? Icons.add : Icons.remove),
              color: isCash
                  ? Colors.grey
                  : (isCredit ? Colors.green : Colors.red),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy HH:mm').format(tx.createdAt),
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    TransactionStatusBadge(
                      status: tx.status,
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
                '${isCash ? '' : (isCredit ? '+' : '-')} ${format.format(tx.amount)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isCash
                      ? Colors.grey
                      : (isCredit ? Colors.green : Colors.red),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (state.downloadingReceiptId == tx.id)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    context.read<FintechBloc>().add(
                      DownloadReceipt(transactionId: tx.id),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 20),
                  color: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _handlePaymentRedirection(String url) async {
    _isAwaitingPaymentReturn = true;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _isAwaitingPaymentReturn = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
        );
      }
    }
  }

  /// Server-controlled: admin can switch the whole platform between real-money
  /// and virtual/simulation mode at any time (see SystemBloc.featureFlags,
  /// backed by GET /config/features). When disabled, the backend rejects
  /// deposit/withdrawal requests outright — this guard avoids sending the user
  /// into a payment flow that will just fail server-side, and explains why.
  bool _isRealMoneyEnabled() =>
      context.read<SystemBloc>().state.featureFlags.featRealMoney.isEnabled;

  void _showSimulationModeNotice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(
          Icons.science_outlined,
          color: AppColors.primary,
          size: 48,
        ),
        title: const Text(
          'Mode Portefeuille Virtuel',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Kauri fonctionne actuellement en mode simulation : les dépôts et retraits en argent réel sont temporairement désactivés. Vous pouvez continuer à utiliser toutes les autres fonctionnalités (tontines, objectifs, défis, budgets...) normalement.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  void _showRechargeDialog() {
    if (!_isRealMoneyEnabled()) {
      _showSimulationModeNotice();
      return;
    }
    final amountController = TextEditingController();
    final phoneController = TextEditingController();
    final user = context.read<AuthBloc>().state.authResponse?.user;

    // Pre-fill phone if available
    if (user?.phone != null) {
      phoneController.text = user!.phone!;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.recharge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.amountLabel,
                hintText: AppLocalizations.of(context)!.amountHint,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.phoneNumberLabel,
                hintText: AppLocalizations.of(context)!.phoneNumberHint,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DebouncedButton(
                    text: AppLocalizations.of(context)!.notchpayLabel,
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text);
                      final phone = phoneController.text.trim();
                      if (amount != null && amount > 50000) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.rechargeLimitError,
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      if (amount != null && amount > 0 && phone.isNotEmpty) {
                        Navigator.pop(context);
                        context.read<PaymentBloc>().add(
                          InitNotchPayPayment(amount: amount, phone: phone),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DebouncedButton(
                    text: AppLocalizations.of(context)!.stripeLabel,
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text);
                      if (amount != null && amount > 50000) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.rechargeLimitError,
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      if (amount != null && amount > 0) {
                        Navigator.pop(context);
                        context.read<PaymentBloc>().add(
                          InitStripeCheckout(amount: amount, currency: 'XAF'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    if (!_isRealMoneyEnabled()) {
      _showSimulationModeNotice();
      return;
    }
    final amountController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedOperator = 'CM_OM';

    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    final user = authState.authResponse?.user;
    final isPremium =
        user?.isPremium ??
        (user?.subscription?.plan == 'premium' &&
            user?.subscription?.status == 'active');
    final double feePercent = isPremium ? 0.015 : 0.03;
    final double currentBalance = context.read<FintechBloc>().state.balance;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final rawAmount =
              double.tryParse(amountController.text.replaceAll(' ', '')) ?? 0.0;
          final fees = rawAmount > 0
              ? (rawAmount * feePercent < 100 ? 100.0 : (rawAmount * feePercent))
              : 0.0;
          final totalDebited = rawAmount > 0 ? rawAmount + fees : 0.0;
          final remainingBalance = currentBalance - totalDebited;

          final isBelowMin = rawAmount > 0 && rawAmount < 500;
          final isAboveMax = rawAmount > 50000;
          final isInsufficientFunds = totalDebited > currentBalance;
          final hasPhone = phoneController.text.trim().length >= 9;
          final canSubmit =
              rawAmount >= 500 &&
              rawAmount <= 50000 &&
              !isInsufficientFunds &&
              hasPhone;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.withdraw,
                  style: AppTextStyles.h2.copyWith(fontSize: 18),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.amountLabel,
                      hintText: '500 - 50 000 FCFA',
                      prefixIcon: const Icon(Icons.payments_outlined, size: 20),
                      suffixText: 'FCFA',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumberLabel,
                      hintText: l10n.phoneNumberHint,
                      prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedOperator,
                    decoration: InputDecoration(
                      labelText: l10n.withdrawOperator,
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CM_OM',
                        child: Text('Orange Money Cameroun'),
                      ),
                      DropdownMenuItem(
                        value: 'CM_MOMO',
                        child: Text('MTN MoMo Cameroun'),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedOperator = val!),
                  ),
                  const SizedBox(height: 16),

                  // Encadré récapitulatif des frais
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isInsufficientFunds
                            ? AppColors.error.withValues(alpha: 0.5)
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.withdrawSummaryTitle,
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isPremium)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  l10n.withdrawPremiumDiscountTag,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 16),
                        _buildFeeRow(
                          l10n.withdrawAmountRequested,
                          CurrencyHelper.formatAmount(rawAmount),
                        ),
                        const SizedBox(height: 6),
                        _buildFeeRow(
                          '${l10n.withdrawFeesLabel} (${isPremium ? '1.5%' : '3%'})',
                          '+ ${CurrencyHelper.formatAmount(fees)}',
                          valueColor: isPremium ? AppColors.success : null,
                        ),
                        const Divider(height: 16),
                        _buildFeeRow(
                          l10n.withdrawTotalDebited,
                          CurrencyHelper.formatAmount(totalDebited),
                          isBold: true,
                        ),
                        const SizedBox(height: 6),
                        _buildFeeRow(
                          l10n.withdrawRemainingBalance,
                          CurrencyHelper.formatAmount(remainingBalance),
                          valueColor: remainingBalance < 0 ? AppColors.error : AppColors.success,
                        ),
                      ],
                    ),
                  ),

                  // Messages d'alerte / indications
                  if (isBelowMin) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.withdrawMinAmountError,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else if (isAboveMax) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.withdrawMaxAmountError,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else if (isInsufficientFunds) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.withdrawInsufficientFundsForFees,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      isPremium
                          ? l10n.withdrawPremiumFeeHint
                          : l10n.withdrawFreeFeeHint,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isPremium
                            ? AppColors.success
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              DebouncedButton(
                isFullWidth: false,
                text: l10n.confirmAction,
                color: canSubmit ? null : Colors.grey,
                onPressed: () async {
                  if (!canSubmit) return;
                  Navigator.pop(context);
                  context.read<FintechBloc>().add(
                    RequestWithdrawal(
                      amount: rawAmount,
                      phoneNumber: phoneController.text.trim(),
                      provider: selectedOperator,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeeRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)
              : AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ??
                (isBold
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.history, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.noTransactions,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
