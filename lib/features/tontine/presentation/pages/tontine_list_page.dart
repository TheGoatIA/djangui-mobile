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
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';

/// Page listant les Tontines (épargne collective) de l'utilisateur.
///
/// La tontine est un système de crédit rotatif et d'épargne solidaire très utilisé
/// en Afrique. Cette page permet de rejoindre ou de créer une tontine.
class TontineListPage extends StatefulWidget {
  const TontineListPage({super.key});

  @override
  State<TontineListPage> createState() => _TontineListPageState();
}

class _TontineListPageState extends State<TontineListPage> {
  // Clés utilisées pour le tutoriel interactif.
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _joinKey = GlobalKey();
  final GlobalKey _createKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Chargement initial des tontines de l'utilisateur
    context.read<TontineBloc>().add(TontinesLoadRequested());
    getIt<LogService>().info(
      'Affichage de la liste des tontines.',
      component: 'TontineListPage',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Relance le tutoriel si le service de tutoriel est réinitialisé
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  /// Démarre le tutoriel interactif si nécessaire.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('tontines_v2')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      tutorialService.startTutorial(context, 'tontines_v2', [
        _joinKey,
        _listKey,
        _createKey,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featTontines,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.tontine);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.tontine,
            isUpdateRequired: true,
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(l10n.tontine),
            elevation: 0,
            actions: [
              // Guide informatif sur le fonctionnement des tontines
              IconButton(
                icon: const Icon(Icons.help_outline),
                tooltip: l10n.tontineGuideTitle,
                onPressed: () =>
                    context.pushNamed(RouteConstants.tontineGuideNamed),
              ),
              // Bouton pour rejoindre une tontine existante via un code
              Showcase(
                key: _joinKey,
                title: l10n.tutorialJoinTontineTitle,
                description: l10n.tutorialJoinTontineDesc,
                child: IconButton(
                  icon: const Icon(Icons.group_add_outlined),
                  tooltip: l10n.joinTontine,
                  onPressed: () =>
                      context.pushNamed(RouteConstants.tontineJoinNamed),
                ),
              ),
            ],
          ),
          body: BlocConsumer<TontineBloc, TontineState>(
            listenWhen: (previous, current) =>
                current.status == TontineStatus.success &&
                previous.status != TontineStatus.success,
            listener: (context, state) {
              // La liste ne monte son Showcase qu'une fois les tontines
              // chargées : on retente ici dès que c'est le cas.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _startTutorial();
              });
            },
            builder: (context, state) {
              // État de chargement initial
              if (state.status == TontineStatus.loading &&
                  state.tontines.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // État vide si aucune tontine n'est rejointe
              if (state.tontines.isEmpty) {
                return Showcase(
                  key: _listKey,
                  title: l10n.tutorialTontineListTitle,
                  description: l10n.tutorialTontineListDesc,
                  child: _buildEmptyState(context, l10n),
                );
              }

              // Liste des tontines actives avec support du rafraîchissement
              return RefreshIndicator(
                onRefresh: () async {
                  getIt<LogService>().info(
                    'Action: Rafraîchissement manuel liste tontines',
                    component: 'TontineListPage',
                  );
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
          // Bouton pour créer une nouvelle tontine
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
      },
    );
  }

  /// Construit l'interface affichée lorsqu'aucune tontine n'est trouvée.
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

  /// Construit la carte visuelle d'une tontine individuelle.
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
                // Fréquence (Hebdomadaire, Mensuelle, etc.)
                Text(_getLocalizedFrequency(tontine.frequency, l10n)),
                const SizedBox(width: 16),
                Icon(
                  Icons.payments_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                // Montant de la cotisation
                Text('${tontine.contributionAmount} ${tontine.currency}'),
              ],
            ),
            const SizedBox(height: 8),
            // Barre de progression de la collecte actuelle
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
        onTap: () => context.pushNamed(
          RouteConstants.tontineDetailsNamed,
          pathParameters: {'id': tontine.id},
        ),
      ),
    );
  }

  /// Traduit la fréquence de la tontine.
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

  /// Gère la demande de création de tontine avec vérification du statut Premium.
  ///
  /// Les utilisateurs gratuits sont limités à une seule tontine active.
  void _handleCreateTontine(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState.authResponse?.user;
    final tontineState = context.read<TontineBloc>().state;

    // Restriction Premium : max 1 tontine pour les utilisateurs non-prémium
    if (user != null && !user.isPremium && tontineState.tontines.isNotEmpty) {
      _showPremiumModal(context);
      return;
    }

    context.pushNamed(RouteConstants.tontineCreateNamed);
  }

  /// Affiche le dialogue invitant à passer à l'offre Premium pour débloquer les tontines illimitées.
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
