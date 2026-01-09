import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djangui/l10n/app_localizations.dart';
import '../utils/responsive_utils.dart';
import '../constants/route_constants.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../di/injection.dart';
import '../../core/services/tutorial_service.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go(RouteConstants.login);
        }
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    // Mobile Layout
    if (ResponsiveUtils.isMobile(context)) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => _onTap(context, index),
          destinations: _buildDestinations(context),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      );
    }

    // Tablet & Desktop Layout
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => _onTap(context, index),
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
            destinations: _buildRailDestinations(context),
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

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    // Trigger tutorial check for the new tab
    getIt<TutorialService>().triggerTutorialCheck();
  }

  List<NavigationDestination> _buildDestinations(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home_filled),
        label: l10n.dashboard,
      ),
      NavigationDestination(
        icon: const Icon(Icons.emoji_events_outlined),
        selectedIcon: const Icon(Icons.emoji_events),
        label: l10n.challenges,
      ),
      NavigationDestination(
        icon: const Icon(Icons.pie_chart_outline),
        selectedIcon: const Icon(Icons.pie_chart),
        label: l10n.budgets,
      ),
      NavigationDestination(
        icon: const Icon(Icons.flag_outlined),
        selectedIcon: const Icon(Icons.flag),
        label: l10n.goals,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: l10n.profile,
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home_filled),
        label: Text(l10n.dashboard),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.emoji_events_outlined),
        selectedIcon: const Icon(Icons.emoji_events),
        label: Text(l10n.challenges),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.pie_chart_outline),
        selectedIcon: const Icon(Icons.pie_chart),
        label: Text(l10n.budgets),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.flag_outlined),
        selectedIcon: const Icon(Icons.flag),
        label: Text(l10n.goals),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(l10n.profile),
      ),
    ];
  }
}
