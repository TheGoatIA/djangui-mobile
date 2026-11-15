import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kauri/l10n/app_localizations.dart';
import '../utils/responsive_utils.dart';
import '../constants/route_constants.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../di/injection.dart';
import '../../core/services/tutorial_service.dart';
import '../../features/system/presentation/bloc/system_bloc.dart';
import '../../features/system/data/models/feature_flag_model.dart';

/// Widget principal de structure (Scaffold) incluant une navigation persistante.
///
/// Adapte automatiquement l'interface utilisateur entre :
/// - Une barre de navigation inférieure ([NavigationBar]) pour mobile.
/// - Un rail de navigation ([NavigationRail]) pour tablettes et desktop.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  /// Le conteneur fourni par GoRouter pour gérer les branches de navigation.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go(RouteConstants.login);
        }
      },
      child: BlocBuilder<SystemBloc, SystemState>(
        builder: (context, systemState) {
          final destinations = _getVisibleDestinations(
            context,
            systemState.featureFlags,
          );
          return _buildScaffold(context, destinations);
        },
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    List<_DestinationInfo> destinations,
  ) {
    // Mobile Layout
    if (ResponsiveUtils.isMobile(context)) {
      final currentBranchIndex = navigationShell.currentIndex;
      // Trouve l'index dans la liste filtrée qui correspond à la branche actuelle
      final selectedIndex = destinations.indexWhere(
        (d) => d.branchIndex == currentBranchIndex,
      );

      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex != -1 ? selectedIndex : 0,
          onDestinationSelected: (index) =>
              _onTap(context, index, destinations),
          destinations: destinations.map((d) => d.navDestination).toList(),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      );
    }

    // Tablet/Desktop Layout
    final currentBranchIndex = navigationShell.currentIndex;
    final selectedIndex = destinations.indexWhere(
      (d) => d.branchIndex == currentBranchIndex,
    );

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex != -1 ? selectedIndex : 0,
            onDestinationSelected: (index) =>
                _onTap(context, index, destinations),
            labelType: NavigationRailLabelType.all,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            leading: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
            groupAlignment: -0.9,
            destinations: destinations.map((d) => d.railDestination).toList(),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  /// Gère le changement d'onglet et déclenche les vérifications de tutoriel.
  void _onTap(
    BuildContext context,
    int index,
    List<_DestinationInfo> destinations,
  ) {
    final realIndex = destinations[index].branchIndex;
    // Le tutoriel de l'onglet quitté ne doit pas rester par-dessus le nouvel onglet.
    getIt<TutorialService>().cancelActiveTutorial(context);
    navigationShell.goBranch(
      realIndex,
      initialLocation: realIndex == navigationShell.currentIndex,
    );
    // Force la vérification des tutoriels contextuels au changement de vue.
    getIt<TutorialService>().triggerTutorialCheck();
  }

  /// Filtre et génère les informations de destination en fonction des flags.
  List<_DestinationInfo> _getVisibleDestinations(
    BuildContext context,
    FeatureFlagModel flags,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final List<_DestinationInfo> allDestinations = [
      _DestinationInfo(
        branchIndex: 0,
        navDestination: NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_filled),
          label: l10n.dashboard,
        ),
        railDestination: NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_filled),
          label: Text(l10n.dashboard),
        ),
      ),
      if (flags.featChallenges.isEnabled)
        _DestinationInfo(
          branchIndex: 1,
          navDestination: NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: l10n.challenges,
          ),
          railDestination: NavigationRailDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: Text(l10n.challenges),
          ),
        ),
      if (flags.featBudgets.isEnabled)
        _DestinationInfo(
          branchIndex: 2,
          navDestination: NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: l10n.budgets,
          ),
          railDestination: NavigationRailDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart),
            label: Text(l10n.budgets),
          ),
        ),
      if (flags.featGoals.isEnabled)
        _DestinationInfo(
          branchIndex: 3,
          navDestination: NavigationDestination(
            icon: const Icon(Icons.flag_outlined),
            selectedIcon: const Icon(Icons.flag),
            label: l10n.goals,
          ),
          railDestination: NavigationRailDestination(
            icon: const Icon(Icons.flag_outlined),
            selectedIcon: const Icon(Icons.flag),
            label: Text(l10n.goals),
          ),
        ),
      _DestinationInfo(
        branchIndex: 4,
        navDestination: NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: l10n.profile,
        ),
        railDestination: NavigationRailDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: Text(l10n.profile),
        ),
      ),
    ];

    return allDestinations;
  }
}

/// Classe interne pour stocker les infos de destination.
class _DestinationInfo {
  final int branchIndex;
  final NavigationDestination navDestination;
  final NavigationRailDestination railDestination;

  _DestinationInfo({
    required this.branchIndex,
    required this.navDestination,
    required this.railDestination,
  });
}
