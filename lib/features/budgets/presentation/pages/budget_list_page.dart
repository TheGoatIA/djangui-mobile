import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_categories.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/budgets_bloc.dart';
import '../bloc/budgets_event.dart';
import '../bloc/budgets_state.dart';
import '../../data/models/budget_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/budget_detail_sheet.dart';
import '../../data/models/auto_budget_response.dart';
import '../../../../core/theme/app_shadows.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';

/// Page listant les budgets mensuels de l'utilisateur.
///
/// Permet de visualiser la consommation de chaque budget par rapport aux limites
/// fixées, d'en ajouter de nouveaux ou de les supprimer.
class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetListView();
  }
}

/// Vue principale de la liste des budgets avec gestion du tutoriel.
class BudgetListView extends StatefulWidget {
  const BudgetListView({super.key});

  @override
  State<BudgetListView> createState() => _BudgetListViewState();
}

class _BudgetListViewState extends State<BudgetListView> {
  // Clés utilisées pour le tutoriel interactif.
  final _listKey = GlobalKey();
  final _addKey = GlobalKey();
  bool _isAnneLoaderVisible = false;

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

  /// Démarre le tutoriel si l'utilisateur ne l'a pas encore vu sur cet écran.
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myBudgets),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.read<BudgetsBloc>().add(
                const GenerateAutoBudgetRequested(),
              );
              _showAnneLoader(context);
            },
            icon: const Icon(Icons.psychology_outlined, size: 20),
            label: Text(
              AppLocalizations.of(context)!.generateViaAnne,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<BudgetsBloc, BudgetsState>(
        listener: (context, state) {
          if (state.status == BudgetsStatus.success) {
            _startTutorial();
            if (_isAnneLoaderVisible && state.autoBudgetResponse != null) {
              _isAnneLoaderVisible = false;
              Navigator.of(context, rootNavigator: true).pop();
              _showAutoBudgetResults(context, state.autoBudgetResponse!);
            }
          } else if (state.status == BudgetsStatus.error) {
            if (_isAnneLoaderVisible) {
              _isAnneLoaderVisible = false;
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Error')),
              );
            }
          }
        },
        child: BlocBuilder<BudgetsBloc, BudgetsState>(
          builder: (context, state) {
            // État de chargement initial
            if (state.status == BudgetsStatus.loading &&
                state.budgets.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // État vide
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

            // Liste des budgets avec support du "pull-to-refresh"
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
                  final budgetWidget = _BudgetItem(budget: budget);

                  // Le premier élément est mis en avant par le tutoriel
                  if (index == 0) {
                    return Showcase(
                      key: _listKey,
                      title: AppLocalizations.of(context)!.tutorialBudgetsTitle,
                      description: AppLocalizations.of(
                        context,
                      )!.tutorialBudgetsDesc,
                      child: budgetWidget,
                    );
                  }

                  return budgetWidget;
                },
              ),
            );
          },
        ),
      ),
      // Bouton pour créer un nouveau budget mensuel
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

  void _showAnneLoader(BuildContext context) {
    _isAnneLoaderVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.anneAnalyzing),
          ],
        ),
      ),
    ).then((_) => _isAnneLoaderVisible = false);
  }

  void _showAutoBudgetResults(
    BuildContext context,
    AutoBudgetResponse response,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.anneAnalysisTitle,
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(response.analysis, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: response.budgets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = response.budgets[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.category, style: AppTextStyles.bodyMedium),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              CurrencyHelper.formatAmount(
                                entry.amount,
                                currencyCode: context
                                    .read<AuthBloc>()
                                    .state
                                    .authResponse
                                    ?.user
                                    .currency,
                              ),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final budgetsBloc = context.read<BudgetsBloc>();

                    // 1. Mapper et agréger les montants par catégorie standard
                    final Map<String, double> aggregatedBudgets = {};
                    for (final entry in response.budgets) {
                      final standardCategory =
                          AppCategories.mapToStandardCategory(entry.category);
                      aggregatedBudgets[standardCategory] =
                          (aggregatedBudgets[standardCategory] ?? 0) +
                          entry.amount;
                    }

                    // 2. Créer les catégories consolidées
                    final List<BudgetCategoryModel> categories =
                        aggregatedBudgets.entries.map((entry) {
                          return BudgetCategoryModel(
                            name: entry.key,
                            allocated: entry.value,
                            spent: 0,
                            percentage: 0,
                          );
                        }).toList();

                    final totalAllocated = categories.fold<double>(
                      0,
                      (sum, item) => sum + item.allocated,
                    );

                    // 3. Envoyer UNE SEULE requête pour tout le budget du mois
                    budgetsBloc.add(const ClearAutoBudgetResponse());
                    budgetsBloc.add(
                      AddBudgetRequested(
                        BudgetModel(
                          id: Uuid().v4(),
                          period: response.budgets.first.period,
                          categories: categories,
                          totalAllocated: totalAllocated,
                          totalSpent: 0,
                          status: 'active',
                          createdAt: DateTime.now(),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.autoBudgetSuccess,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.applyBudgets),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget représentant un seul budget mensuel dans la liste.
class _BudgetItem extends StatelessWidget {
  final BudgetModel budget;

  const _BudgetItem({required this.budget});

  @override
  Widget build(BuildContext context) {
    // Calcul du ratio de consommation du budget
    final progress = budget.totalAllocated > 0
        ? (budget.totalSpent / budget.totalAllocated).clamp(0.0, 1.0)
        : 0.0;

    // Détermination de la couleur (rouge si dépassé, vert/primaire sinon)
    final isOverBudget = budget.totalSpent > budget.totalAllocated;
    final color = isOverBudget
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () {
        // Affiche les détails du budget dans un "bottom sheet"
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
                // Mois et année du budget
                Text(
                  DateFormat.yMMMM(
                    Localizations.localeOf(context).languageCode,
                  ).format(DateTime(budget.period.year, budget.period.month)),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Pourcentage consommé
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Bouton de suppression
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
            // Barre de progression visuelle de la consommation
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
            // Comparaison Dépensé vs Limite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.spentLabel}: ${CurrencyHelper.formatAmount(budget.totalSpent, currencyCode: context.read<AuthBloc>().state.authResponse?.user.currency)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.limitLabel}: ${CurrencyHelper.formatAmount(budget.totalAllocated, currencyCode: context.read<AuthBloc>().state.authResponse?.user.currency)}',
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

  /// Affiche une boîte de dialogue pour confirmer la suppression du budget.
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
