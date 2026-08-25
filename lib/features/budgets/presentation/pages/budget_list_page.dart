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

import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

/// Page listant les budgets mensuels de l'utilisateur.
///
/// Permet de visualiser la consommation de chaque budget par rapport aux limites
/// fixées, d'en ajouter de nouveaux ou de les supprimer.
class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featBudgets,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.myBudgets);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.myBudgets,
            isUpdateRequired: true,
          );
        }
        return const BudgetListView();
      },
    );
  }
}

/// Vue principale de la liste des budgets avec gestion du tutoriel.
class BudgetListView extends StatefulWidget {
  const BudgetListView({super.key});

  @override
  State<BudgetListView> createState() => _BudgetListViewState();
}

class _BudgetListViewState extends State<BudgetListView>
    with WidgetsBindingObserver, SecureScreenMixin<BudgetListView> {
  // Clés utilisées pour le tutoriel interactif.
  final _listKey = GlobalKey();
  final _addKey = GlobalKey();
  final _anneKey = GlobalKey();
  bool _isAnneLoaderVisible = false;

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la liste des budgets.',
      component: 'BudgetListPage',
    );
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
    if (tutorialService.hasSeenTutorial('budgets')) return;
    try {
      final shell = StatefulNavigationShell.of(context);
      if (shell.currentIndex != 2) return;
    } catch (_) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final showAnneStep = context
          .read<SystemBloc>()
          .state
          .featureFlags
          .aiBudgetGeneration
          .isEnabled;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'budgets', [
        if (showAnneStep)
          TutorialStep(
            targetKey: _anneKey,
            title: l10n.tutorialAnneTitle,
            description: l10n.tutorialAnneDesc,
          ),
        TutorialStep(
          targetKey: _listKey,
          title: l10n.tutorialBudgetsTitle,
          description: l10n.tutorialBudgetsDesc,
        ),
        TutorialStep(
          targetKey: _addKey,
          title: l10n.tutorialAddBudgetTitle,
          description: l10n.tutorialAddBudgetDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myBudgets),
        actions: [
          BlocBuilder<SystemBloc, SystemState>(
            builder: (context, systemState) {
              if (!systemState.featureFlags.aiBudgetGeneration.isEnabled) {
                return const SizedBox.shrink();
              }
              return KeyedSubtree(
                key: _anneKey,
                child: TextButton.icon(
                  onPressed: () {
                    getIt<LogService>().info(
                      'Action: Demande de génération automatique via Anne',
                      component: 'BudgetListPage',
                    );
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
              );
            },
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
                child: KeyedSubtree(
                  key: _listKey,
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
                getIt<LogService>().info(
                  'Rafraîchissement de la liste des budgets (Pull-to-refresh)',
                  component: 'BudgetListPage',
                );
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
                    return KeyedSubtree(key: _listKey, child: budgetWidget);
                  }

                  return budgetWidget;
                },
              ),
            );
          },
        ),
      ),
      // Bouton pour créer un nouveau budget mensuel
      floatingActionButton: KeyedSubtree(
        key: _addKey,
        child: FloatingActionButton(
          heroTag: 'budgets_fab',
          onPressed: () async {
            getIt<LogService>().info(
              'Navigation vers la page d\'ajout de budget depuis la liste',
              component: 'BudgetListPage',
            );
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
                  onPressed: () async {
                    final budgetsBloc = context.read<BudgetsBloc>();

                    // 1. Détecter si un budget existe déjà pour cette période
                    final existingBudget = budgetsBloc.state.budgets.any(
                      (b) =>
                          b.period.year == response.budgets.first.period.year &&
                          b.period.month == response.budgets.first.period.month,
                    );

                    if (existingBudget) {
                      final shouldReplace = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.budgetExistsTitle,
                          ),
                          content: Text(
                            AppLocalizations.of(context)!.budgetExistsMessage,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(
                                AppLocalizations.of(context)!.replaceBudget,
                              ),
                            ),
                          ],
                        ),
                      );

                      if (shouldReplace != true) return;

                      // Si on remplace, on supprime d'abord l'existant
                      final budgetToDelete = budgetsBloc.state.budgets
                          .firstWhere(
                            (b) =>
                                b.period.year ==
                                    response.budgets.first.period.year &&
                                b.period.month ==
                                    response.budgets.first.period.month,
                          );
                      budgetsBloc.add(DeleteBudgetRequested(budgetToDelete.id));
                    }

                    // 2. Mapper et agréger les montants par catégorie standard
                    final Map<String, double> aggregatedBudgets = {};
                    for (final entry in response.budgets) {
                      final standardCategory =
                          AppCategories.mapToStandardCategory(entry.category);
                      aggregatedBudgets[standardCategory] =
                          (aggregatedBudgets[standardCategory] ?? 0) +
                          entry.amount;
                    }

                    // 3. Créer les catégories consolidées
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

                    // 4. Envoyer UNE SEULE requête pour tout le budget du mois
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
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.autoBudgetSuccess,
                          ),
                        ),
                      );
                    }
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
        getIt<LogService>().info(
          'Consultation des détails du budget (Sheet): ${budget.id}',
          component: 'BudgetListPage',
        );
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
