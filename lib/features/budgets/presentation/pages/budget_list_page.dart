import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../bloc/budgets_bloc.dart';
import '../bloc/budgets_event.dart';
import '../bloc/budgets_state.dart';
import '../../data/models/budget_model.dart';
import '../../../../l10n/app_localizations.dart';

class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BudgetsBloc>()..add(const GetBudgetsRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.myBudgets)),
        body: BlocBuilder<BudgetsBloc, BudgetsState>(
          builder: (context, state) {
            if (state.status == BudgetsStatus.loading &&
                state.budgets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.budgets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.emptyBudget, width: 150, height: 150),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noBudgetDefined,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.budgets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final budget = state.budgets[index];
                return _BudgetItem(budget: budget);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('${RouteConstants.budgets}/add'),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _BudgetItem extends StatelessWidget {
  final BudgetModel budget;

  const _BudgetItem({required this.budget});

  @override
  Widget build(BuildContext context) {
    final progress = budget.totalAllocated > 0
        ? (budget.totalSpent / budget.totalAllocated).clamp(0.0, 1.0)
        : 0.0;
    final isOverBudget = budget.totalSpent > budget.totalAllocated;
    final color = isOverBudget ? AppColors.error : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                '${budget.period.month}/${budget.period.year}',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.spentLabel}: ${budget.totalSpent.toStringAsFixed(0)} F',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              ),
              Text(
                '${AppLocalizations.of(context)!.limitLabel}: ${budget.totalAllocated.toStringAsFixed(0)} F',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
