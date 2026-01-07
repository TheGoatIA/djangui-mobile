import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
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
          title: Text(AppLocalizations.of(context)!.myInvestments),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  context.push('${RouteConstants.investments}/add'),
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          // Listen to AuthBloc for premium status
          builder: (context, authState) {
            final isPremium = authState.authResponse?.user.isPremium ?? false;

            if (!isPremium) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.premiumWelcomeTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.investmentsPremiumRestriction,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: AppLocalizations.of(context)!.upgradeToPremium,
                        onPressed: () =>
                            context.push(RouteConstants.subscription),
                      ),
                    ],
                  ),
                ),
              );
            }

            return BlocBuilder<InvestmentsBloc, InvestmentsState>(
              builder: (context, state) {
                if (state.status == InvestmentsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == InvestmentsStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ??
                          AppLocalizations.of(context)!.errorOccurred,
                    ),
                  );
                } else if (state.investments.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.investments.length,
                  itemBuilder: (context, index) {
                    final investment = state.investments[index];
                    return Dismissible(
                      key: Key(investment.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await _showDeleteConfirmation(context);
                      },
                      onDismissed: (direction) {
                        context.read<InvestmentsBloc>().add(
                          DeleteInvestment(investment.id),
                        );
                      },
                      child: _buildInvestmentCard(context, investment),
                    );
                  },
                );
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
          Icon(
            Icons.trending_up,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noInvestments,
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.startBuildingPortfolio,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('${RouteConstants.investments}/add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.addInvestment),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard(BuildContext context, dynamic investment) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'XAF',
      decimalDigits: 0,
    );
    final isPositive = investment.roi >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                  _getTypeName(context, investment.type),
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

  String _getTypeName(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'crypto':
        return l10n.cryptoCurrency;
      case 'stock':
        return l10n.stockMarket;
      case 'real_estate':
        return l10n.realEstate;
      default:
        return l10n.other;
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete),
        content: Text(
          AppLocalizations.of(context)!.deleteInvestmentConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
