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
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class WalletDashboardPage extends StatefulWidget {
  const WalletDashboardPage({super.key});

  @override
  State<WalletDashboardPage> createState() => _WalletDashboardPageState();
}

class _WalletDashboardPageState extends State<WalletDashboardPage>
    with WidgetsBindingObserver, SecureScreenMixin {
  bool _showAllTransactions = false;

  @override
  void initState() {
    super.initState();
    context.read<FintechBloc>().add(FetchWalletBalance());
    context.read<FintechBloc>().add(FetchWalletTransactions());
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
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                  title: const Text(
                    'Retrait échoué',
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    state.message ??
                        'Une erreur est survenue. Veuillez réessayer.',
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
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
    // Dynamic calculation of incomes and outcomes
    final incomes = transactions
        .where(
          (t) =>
              (t.type == 'credit' ||
                  t.type == 'deposit' ||
                  t.type == 'income') &&
              !t.description.toLowerCase().contains('remboursement') &&
              !t.description.toLowerCase().contains('refund'),
        )
        .fold(0.0, (sum, t) => sum + t.amount);
    final outcomes = transactions
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionBtn(
            icon: Icons.add_circle_outline,
            label: AppLocalizations.of(context)!.recharge,
            onTap: () => _showRechargeDialog(),
            color: AppColors.primary,
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
                Text(
                  DateFormat('dd MMM yyyy HH:mm').format(tx.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
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
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
        );
      }
    }
  }

  void _showRechargeDialog() {
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
    final amountController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedOperator = 'CM_OM';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.withdraw),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.amountLabel,
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
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedOperator,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'CM_OM', child: Text('Orange Money')),
                  DropdownMenuItem(value: 'CM_MOMO', child: Text('MTN MoMo')),
                ],
                onChanged: (val) => setState(() => selectedOperator = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            DebouncedButton(
              isFullWidth: false,
              text: AppLocalizations.of(context)!.confirmAction,
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null &&
                    amount > 0 &&
                    phoneController.text.isNotEmpty) {
                  Navigator.pop(context);
                  context.read<FintechBloc>().add(
                    RequestWithdrawal(
                      amount: amount,
                      phoneNumber: phoneController.text,
                      provider: selectedOperator,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
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
