import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../bloc/investments_bloc.dart';

class InvestmentsPage extends StatelessWidget {
  const InvestmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<InvestmentsBloc>()..add(const LoadInvestments()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Mes Investissements'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push('${RouteConstants.investments}/add'),
            ),
          ],
        ),
        body: BlocBuilder<InvestmentsBloc, InvestmentsState>(
          builder: (context, state) {
            if (state.status == InvestmentsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == InvestmentsStatus.error) {
              return Center(
                child: Text(state.errorMessage ?? 'Une erreur est survenue'),
              );
            } else if (state.investments.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.investments.length,
              itemBuilder: (context, index) {
                final investment = state.investments[index];
                return _buildInvestmentCard(investment);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trending_up, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucun investissement',
            style: AppTextStyles.h3.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez à construire votre portefeuille',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('${RouteConstants.investments}/add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ajouter un investissement'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(dynamic investment) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'FCFA',
      decimalDigits: 0,
    );
    final isPositive = investment.roi >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getIconColor(investment.type).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(investment.type),
              color: _getIconColor(investment.type),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getTypeName(investment.type),
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(investment.currentAmount),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${investment.roi.toStringAsFixed(1)}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isPositive ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'crypto':
        return Icons.currency_bitcoin;
      case 'stock':
        return Icons.show_chart;
      case 'real_estate':
        return Icons.home_work_outlined;
      default:
        return Icons.savings_outlined;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'crypto':
        return Colors.orange;
      case 'stock':
        return Colors.blue;
      case 'real_estate':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'crypto':
        return 'Crypto-monnaie';
      case 'stock':
        return 'Bourse';
      case 'real_estate':
        return 'Immobilier';
      default:
        return 'Autre';
    }
  }
}
