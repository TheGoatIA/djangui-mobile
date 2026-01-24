import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/route_constants.dart';
import '../bloc/support_bloc.dart';
import '../bloc/support_event.dart';
import '../bloc/support_state.dart';
import '../../data/models/support_ticket_model.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

/// Page listant les tickets de support technique créés par l'utilisateur.
///
/// Permet de suivre l'état de ses demandes, d'en créer de nouvelles ou de consulter
/// les réponses apportées par l'équipe Kauri.
class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  @override
  void initState() {
    super.initState();
    // Chargement initial des tickets
    context.read<SupportBloc>().add(GetTicketsRequested());
    getIt<AnalyticsManager>().trackEvent(
      feature: 'Support',
      action: 'view_tickets',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.supportTicketList),
        actions: [
          // Bouton de rafraîchissement manuel
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<SupportBloc>().add(GetTicketsRequested()),
          ),
        ],
      ),
      body: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          // État de chargement initial
          if (state.status == SupportStatus.loading && state.tickets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Affichage d'une erreur si le chargement échoue
          if (state.status == SupportStatus.failure && state.tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ??
                        AppLocalizations.of(context)!.genericError,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SupportBloc>().add(GetTicketsRequested()),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          // État vide lorsqu'aucun ticket n'est trouvé
          if (state.tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.support_agent_outlined,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noRecentActivities,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Liste des tickets avec support du "pull-to-refresh"
          return RefreshIndicator(
            onRefresh: () async {
              context.read<SupportBloc>().add(GetTicketsRequested());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.tickets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
                return _TicketCard(ticket: ticket);
              },
            ),
          );
        },
      ),
      // Bouton pour créer une nouvelle demande de support
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteConstants.createTicket),
        label: Text(AppLocalizations.of(context)!.createTicket),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

/// Carte représentant un ticket individuel dans la liste.
class _TicketCard extends StatelessWidget {
  final SupportTicketModel ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    );

    return InkWell(
      onTap: () =>
          context.push('${RouteConstants.supportTickets}/${ticket.id}'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge de statut (Ouvert, Répondu, Fermé)
                _StatusBadge(status: ticket.status),
                Text(
                  dateFormat.format(ticket.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Objet du ticket
            Text(
              ticket.subject,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Message initial ou aperçu
            Text(
              ticket.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                // Catégorie de la demande
                Text(
                  ticket.category,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Indicateur du nombre de réponses reçues
                if (ticket.replies != null && ticket.replies!.isNotEmpty) ...[
                  Icon(
                    Icons.reply,
                    size: 14,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${ticket.replies!.length}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge visuel indiquant le statut coloré d'un ticket.
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'open':
        color = AppColors.info;
        label = AppLocalizations.of(context)!.open;
        break;
      case 'answered':
        color = AppColors.success;
        label = AppLocalizations.of(context)!.answered;
        break;
      case 'closed':
        color = AppColors.error.withValues(alpha: 0.7);
        label = AppLocalizations.of(context)!.closed;
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
