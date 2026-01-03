import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../bloc/transactions_bloc.dart';
import '../../data/models/transaction_model.dart';
import '../../../../l10n/app_localizations.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<TransactionsBloc>()..add(const GetTransactionsRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.transactions),
          actions: [
            IconButton(
              onPressed: () => context.read<TransactionsBloc>().add(
                const GetTransactionsRequested(forceRefresh: true),
              ),
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
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
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
                  return _TransactionItem(transaction: transaction);
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('${RouteConstants.transactions}/add'),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? AppColors.success : AppColors.error;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                Text(
                  transaction.category,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${NumberFormat('#,###').format(transaction.amount)} F',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd MMM').format(transaction.date),
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
