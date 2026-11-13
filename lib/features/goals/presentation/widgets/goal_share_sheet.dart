import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kauri/core/theme/app_colors.dart';
import 'package:kauri/core/theme/app_text_styles.dart';
import 'package:kauri/l10n/app_localizations.dart';
import '../../data/models/goal_model.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';

/// Ouvre la feuille de partage d'un objectif : affiche directement le code
/// d'invitation s'il existe déjà, sinon en demande un au serveur d'abord.
/// Factorisé en fonction libre (plutôt qu'une méthode privée d'un seul
/// widget, comme pour Budget) car les objectifs exposent le partage depuis
/// deux écrans (liste et détail).
void showGoalShareSheet(BuildContext context, GoalModel goal) {
  final bloc = context.read<GoalsBloc>();
  if (goal.inviteCode != null) {
    _showInviteCodeSheet(context, goal.inviteCode!);
  } else {
    bloc.add(ShareGoalRequested(goal.id));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: BlocConsumer<GoalsBloc, GoalsState>(
          listenWhen: (p, c) => p.shareStatus != c.shareStatus,
          listener: (context, state) {
            if (state.shareStatus == GoalSideStatus.success &&
                state.shareInviteCode != null) {
              Navigator.pop(sheetContext);
              _showInviteCodeSheet(context, state.shareInviteCode!);
            }
          },
          builder: (context, state) => Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

void _showInviteCodeSheet(BuildContext context, String inviteCode) {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.shareGoal, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            l10n.shareGoalDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                inviteCode,
                style: AppTextStyles.h2.copyWith(
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: inviteCode));
                ScaffoldMessenger.of(
                  sheetContext,
                ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
              },
              icon: const Icon(Icons.copy_outlined),
              label: Text(l10n.copyToClipboard),
            ),
          ),
        ],
      ),
    ),
  );
}

class GoalSharedBadge extends StatelessWidget {
  const GoalSharedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_outlined, size: 12, color: AppColors.info),
          const SizedBox(width: 4),
          Text(
            l10n.sharedBadge,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalParticipantsSection extends StatelessWidget {
  final GoalModel goal;

  const GoalParticipantsSection({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.goalParticipants,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocBuilder<GoalsBloc, GoalsState>(
          buildWhen: (p, c) => p.participants != c.participants,
          builder: (context, state) {
            if (state.participants.isEmpty) {
              return Text(
                l10n.noDataAvailable,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Column(
              children: state.participants.map((p) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      p.displayName.isNotEmpty
                          ? p.displayName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  title: Text(p.displayName),
                  trailing: goal.isOwner
                      ? IconButton(
                          icon: const Icon(Icons.person_remove_outlined),
                          tooltip: l10n.removeParticipant,
                          onPressed: () {
                            context.read<GoalsBloc>().add(
                              RemoveGoalParticipantRequested(goal.id, p.id),
                            );
                          },
                        )
                      : null,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Boîte de confirmation avant de quitter un objectif partagé — appelée
/// depuis GoalDetailPage.
void showLeaveGoalConfirmation(BuildContext context, GoalModel goal) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.leaveGoal),
      content: Text(l10n.leaveGoalConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<GoalsBloc>().add(LeaveGoalRequested(goal.id));
            Navigator.pop(dialogContext);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          child: Text(l10n.leaveGoal),
        ),
      ],
    ),
  );
}
