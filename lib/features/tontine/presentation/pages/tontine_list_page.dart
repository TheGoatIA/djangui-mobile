import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';
import '../bloc/tontine_bloc.dart';
import '../bloc/tontine_event.dart';
import '../bloc/tontine_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

import 'package:showcaseview/showcaseview.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/tutorial_service.dart';

class TontineListPage extends StatefulWidget {
  const TontineListPage({super.key});

  @override
  State<TontineListPage> createState() => _TontineListPageState();
}

class _TontineListPageState extends State<TontineListPage> {
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _joinKey = GlobalKey();
  final GlobalKey _createKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<TontineBloc>().add(TontinesLoadRequested());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('tontines_v2')) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(
          context,
        ).startShowCase([_joinKey, _listKey, _createKey]);
        tutorialService.markTutorialAsSeen('tontines_v2');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.tontine),
        elevation: 0,
        actions: [
          Showcase(
            key: _joinKey,
            title: l10n.tutorialJoinTontineTitle,
            description: l10n.tutorialJoinTontineDesc,
            child: IconButton(
              icon: const Icon(Icons.group_add_outlined),
              tooltip: l10n.joinTontine,
              onPressed: () => context.push(RouteConstants.joinTontine),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TontineBloc, TontineState>(
        builder: (context, state) {
          if (state.status == TontineStatus.loading && state.tontines.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.tontines.isEmpty) {
            return Showcase(
              key: _listKey,
              title: l10n.tutorialTontineListTitle,
              description: l10n.tutorialTontineListDesc,
              child: _buildEmptyState(context, l10n),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TontineBloc>().add(TontinesLoadRequested());
            },
            child: Showcase(
              key: _listKey,
              title: l10n.tutorialTontineListTitle,
              description: l10n.tutorialTontineListDesc,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tontines.length,
                itemBuilder: (context, index) {
                  final tontine = state.tontines[index];
                  return _buildTontineCard(context, tontine, l10n)
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                      .slideX(begin: 0.2, end: 0);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Showcase(
        key: _createKey,
        title: l10n.tutorialCreateTontineButtonTitle,
        description: l10n.tutorialCreateTontineButtonDesc,
        child: FloatingActionButton.extended(
          onPressed: () => _handleCreateTontine(context),
          label: Text(l10n.createTontine),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(l10n.noTontineJoined, style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Text(
            l10n.startTontineDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _handleCreateTontine(context),
            child: Text(l10n.createMyFirstTontine),
          ),
        ],
      ),
    );
  }

  Widget _buildTontineCard(
    BuildContext context,
    dynamic tontine,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black45,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(tontine.name, style: AppTextStyles.h3),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_repeat, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(_getLocalizedFrequency(tontine.frequency, l10n)),
                const SizedBox(width: 16),
                Icon(
                  Icons.payments_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text('${tontine.contributionAmount} ${tontine.currency}'),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: tontine.turnSummary != null
                    ? tontine.turnSummary.collectedAmount /
                          tontine.turnSummary.expectedAmount
                    : 0,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                minHeight: 6,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('${RouteConstants.tontines}/${tontine.id}'),
      ),
    );
  }

  String _getLocalizedFrequency(String frequency, AppLocalizations l10n) {
    switch (frequency.toLowerCase()) {
      case 'weekly':
        return l10n.frequencyWeekly;
      case 'monthly':
        return l10n.frequencyMonthly;
      case 'yearly':
        return l10n.frequencyYearly;
      case 'daily':
        return l10n.daily;
      default:
        return frequency;
    }
  }

  void _handleCreateTontine(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState.authResponse?.user;
    final tontineState = context.read<TontineBloc>().state;

    // Premium logic check
    if (user != null && !user.isPremium && tontineState.tontines.isNotEmpty) {
      _showPremiumModal(context);
      return;
    }

    context.push(RouteConstants.createTontine);
  }

  void _showPremiumModal(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 48),
            const SizedBox(height: 16),
            Text(l10n.premiumRequired, style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              l10n.tontinePremiumRestrictionDesc,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(RouteConstants.subscription);
                },
                child: Text(l10n.discoverOffers),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
