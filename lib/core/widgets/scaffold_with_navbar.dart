import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:djangui/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Mobile Layout
    if (ResponsiveUtils.isMobile(context)) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => _onTap(context, index),
          destinations: _buildDestinations(context),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
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
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary.withValues(alpha: 0.2),
            leading: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
            groupAlignment: -0.9,
            destinations: _buildRailDestinations(context),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: AppColors.outline,
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
