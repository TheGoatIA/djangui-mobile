import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/budgets_bloc.dart';
import '../bloc/budgets_event.dart';
import '../bloc/budgets_state.dart';
import '../../data/models/budget_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/budget_detail_sheet.dart';
import '../../../../core/theme/app_shadows.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';

class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetListView();
  }
}

class BudgetListView extends StatefulWidget {
  const BudgetListView({super.key});

  @override
  State<BudgetListView> createState() => _BudgetListViewState();
}

class _BudgetListViewState extends State<BudgetListView> {
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
      getIt<AnalyticsManager>().trackEvent(
        feature: 'Budgets',
        action: 'view_list',
      );
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
    if (!tutorialService.hasSeenTutorial('budgets')) {
      try {
        final shell = StatefulNavigationShell.of(context);
        if (shell.currentIndex != 2) return;
      } catch (_) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_listKey, _addKey]);
        tutorialService.markTutorialAsSeen('budgets');
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.myBudgets)),
      body: BlocListener<BudgetsBloc, BudgetsState>(
        listener: (context, state) {
          if (state.status == BudgetsStatus.success) {
            _startTutorial();
          }
        },
        child: BlocBuilder<BudgetsBloc, BudgetsState>(
          builder: (context, state) {
            if (state.status == BudgetsStatus.loading &&
                state.budgets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.budgets.isEmpty) {
              return Center(
                child: Showcase(
                  key: _listKey,
                  title: AppLocalizations.of(context)!.tutorialBudgetsTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.tutorialBudgetsDesc,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.emptyBudget,
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noBudgetDefined,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BudgetsBloc>().add(
                  const GetBudgetsRequested(forceRefresh: true),
                );
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.budgets.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final budget = state.budgets[index];
                  final widget = _BudgetItem(budget: budget);

                  if (index == 0) {
                    return Showcase(
                      key: _listKey,
                      title: AppLocalizations.of(context)!.tutorialBudgetsTitle,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialBudgetsDesc,
                      child: widget,
                    );
                  }

                  return widget;
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: Showcase(
        key: _addKey,
        title: AppLocalizations.of(context)!.tutorialAddBudgetTitle,
        description: AppLocalizations.of(context)!.tutorialAddBudgetDesc,
        child: FloatingActionButton(
          heroTag: 'budgets_fab',
          onPressed: () async {
            final refresh = await context.push<bool>(
              '${RouteConstants.budgets}/add',
            );
            if (refresh == true && context.mounted) {
              context.read<BudgetsBloc>().add(
                const GetBudgetsRequested(forceRefresh: true),
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
    final color = isOverBudget
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BudgetDetailSheet(budget: budget),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMM(
                    Localizations.localeOf(context).languageCode,
                  ).format(DateTime(budget.period.year, budget.period.month)),
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
                IconButton(
                  onPressed: () => _showDeleteDialog(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
                  '${AppLocalizations.of(context)!.spentLabel}: ${budget.totalSpent.toStringAsFixed(0)} XAF',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.limitLabel}: ${budget.totalAllocated.toStringAsFixed(0)} XAF',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteBudget),
        content: Text(AppLocalizations.of(context)!.deleteBudgetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Budgets',
                action: 'delete_success',
                details: {'id': budget.id},
              );
              context.read<BudgetsBloc>().add(DeleteBudgetRequested(budget.id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
