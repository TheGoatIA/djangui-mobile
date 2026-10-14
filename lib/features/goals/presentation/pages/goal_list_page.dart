import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';
import '../../data/models/goal_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/route_constants.dart';
import '../widgets/goal_share_sheet.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/utils/currency_helper.dart';

import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

/// Page listant les objectifs d'épargne de l'utilisateur.
///
/// Permet de visualiser la progression de chaque objectif, d'en ajouter de nouveaux,
/// de les partager ou de les supprimer.
class GoalListPage extends StatelessWidget {
  const GoalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoalListView();
  }
}

/// Vue principale de la liste des objectifs avec gestion du tutoriel.
class GoalListView extends StatefulWidget {
  const GoalListView({super.key});

  @override
  State<GoalListView> createState() => _GoalListViewState();
}

class _GoalListViewState extends State<GoalListView>
    with WidgetsBindingObserver, SecureScreenMixin<GoalListView> {
  // Clés utilisées pour le tutoriel interactif.
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la liste des objectifs.',
      component: 'GoalListPage',
    );
    context.read<GoalsBloc>().add(const GetGoalsRequested(forceRefresh: true));
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

  /// Démarre le tutoriel si l'utilisateur ne l'a pas encore vu sur cet écran.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('goals')) return;
    try {
      final shell = StatefulNavigationShell.of(context);
      if (shell.currentIndex != 3) return;
    } catch (_) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'goals', [
        TutorialStep(
          targetKey: _listKey,
          title: l10n.tutorialGoalsTitle,
          description: l10n.tutorialGoalsDesc,
        ),
        TutorialStep(
          targetKey: _addKey,
          title: l10n.tutorialAddGoalTitle,
          description: l10n.tutorialAddGoalDesc,
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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featGoals,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.myGoals);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.myGoals,
            isUpdateRequired: true,
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(l10n.myGoals),
            actions: [
              IconButton(
                onPressed: () async {
                  final refresh = await context.push<bool>(
                    RouteConstants.joinGoal,
                  );
                  if (refresh == true && context.mounted) {
                    context.read<GoalsBloc>().add(
                      const GetGoalsRequested(forceRefresh: true),
                    );
                  }
                },
                icon: const Icon(Icons.group_add_outlined),
                tooltip: l10n.joinGoal,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: BlocListener<GoalsBloc, GoalsState>(
            listener: (context, state) {
              if (state.status == GoalsStatus.success) {
                _startTutorial();
              } else if (state.status == GoalsStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? l10n.errorGoal)),
                );
              }
            },
            child: BlocBuilder<GoalsBloc, GoalsState>(
              builder: (context, state) {
                // État de chargement initial
                if (state.status == GoalsStatus.loading &&
                    state.goals.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // État vide
                if (state.goals.isEmpty) {
                  return Center(
                    child: KeyedSubtree(
                      key: _listKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.emptyGoals,
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noGoalDefined,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Liste des objectifs avec support du "pull-to-refresh"
                return RefreshIndicator(
                  onRefresh: () async {
                    getIt<LogService>().info(
                      'Rafraîchissement de la liste des objectifs (Pull-to-refresh)',
                      component: 'GoalListPage',
                    );
                    context.read<GoalsBloc>().add(
                      const GetGoalsRequested(forceRefresh: true),
                    );
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.goals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final goal = state.goals[index];
                      final goalWidget = _GoalItem(goal: goal);

                      // Le premier élément est mis en avant par le tutoriel
                      if (index == 0) {
                        return KeyedSubtree(key: _listKey, child: goalWidget);
                      }

                      return goalWidget;
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: KeyedSubtree(
            key: _addKey,
            child: FloatingActionButton(
              heroTag: 'goals_fab',
              onPressed: () async {
                getIt<LogService>().info(
                  'Navigation vers la page d\'ajout d\'objectif depuis la liste',
                  component: 'GoalListPage',
                );
                final result = await context.pushNamed<bool>('goal-add');
                if (result == true && context.mounted) {
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
      },
    );
  }
}

/// Widget représentant un seul objectif d'épargne dans la liste.
class _GoalItem extends StatelessWidget {
  final GoalModel goal;

  const _GoalItem({required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final daysRemaining = goal.deadline.difference(DateTime.now()).inDays;

    return InkWell(
      onTap: () {
        getIt<LogService>().info(
          'Consultation des détails de l\'objectif: ${goal.id}',
          component: 'GoalListPage',
        );
        context.pushNamed('goal-details', pathParameters: {'id': goal.id});
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
                  goal.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Menu contextuel (Partager/Supprimer)
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'share') {
                      getIt<LogService>().info(
                        'Action: Partage de l\'objectif ${goal.id}',
                        component: 'GoalListPage',
                      );
                      getIt<AnalyticsManager>().trackEvent(
                        feature: 'Goals',
                        action: 'share',
                        details: {'id': goal.id},
                      );
                      showGoalShareSheet(context, goal);
                    } else if (value == 'delete') {
                      getIt<LogService>().info(
                        'Action: Demande de suppression de l\'objectif ${goal.id}',
                        component: 'GoalListPage',
                      );
                      _showDeleteDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 20,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.share),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // État de progression financier
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) {
                    final userCurrency =
                        context
                            .read<AuthBloc>()
                            .state
                            .authResponse
                            ?.user
                            .currency ??
                        goal.currency;
                    return Text(
                      '${CurrencyHelper.formatAmount(goal.currentAmount, currencyCode: userCurrency)} / ${CurrencyHelper.formatAmount(goal.targetAmount, currencyCode: userCurrency)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Barre de progression visuelle
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 16),

            // Jours restants avant l'échéance
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  daysRemaining > 0
                      ? AppLocalizations.of(
                          context,
                        )!.daysRemaining(daysRemaining)
                      : AppLocalizations.of(context)!.deadlinePassed,
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

  /// Affiche une boîte de dialogue pour confirmer la suppression d'un objectif.
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete),
        content: Text(AppLocalizations.of(context)!.deleteGoalConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Goals',
                action: 'delete_success',
                details: {'id': goal.id},
              );
              context.read<GoalsBloc>().add(DeleteGoalRequested(goal.id));
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
