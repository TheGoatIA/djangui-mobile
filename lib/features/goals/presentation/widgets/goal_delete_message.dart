import 'package:intl/intl.dart';
import 'package:kauri/l10n/app_localizations.dart';

import '../../data/models/goal_model.dart';

/// Texte de confirmation de suppression d'un objectif : annonce la pénalité de
/// sortie anticipée (montant exact) quand l'API va en retenir une.
String goalDeleteMessage(
  AppLocalizations l10n,
  GoalModel goal, {
  DateTime? now,
}) {
  final penalty = goal.earlyExitPenalty(now);
  if (penalty <= 0) return l10n.deleteGoalConfirmation;
  final money = NumberFormat.decimalPattern('fr');
  return l10n.deleteGoalWithPenalty(
    money.format(goal.currentAmount),
    money.format(penalty),
    DateFormat.yMMMd('fr').format(goal.deadline.toLocal()),
  );
}
