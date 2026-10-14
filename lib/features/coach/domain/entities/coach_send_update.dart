import '../../../../core/errors/failures.dart';

/// Émis au fil de l'eau par `CoachRepository.sendMessageStream` pendant que
/// la réponse de l'IA arrive progressivement.
sealed class CoachSendUpdate {
  const CoachSendUpdate();
}

/// [cumulativeText] contient tout le texte reçu jusqu'ici (pas seulement le
/// fragment le plus récent) — plus simple à consommer côté Bloc, qui n'a
/// qu'à remplacer le texte du message en cours plutôt que le concaténer.
class CoachSendDelta extends CoachSendUpdate {
  final String cumulativeText;
  const CoachSendDelta(this.cumulativeText);
}

/// Ne transporte pas d'id : le Bloc réutilise l'id de la bulle placeholder
/// déjà créée au premier [CoachSendDelta] plutôt que d'en recevoir un nouveau
/// à faire correspondre — l'id de stockage local choisi par le repository
/// n'a pas besoin de correspondre à celui affiché à l'écran.
class CoachSendCompleted extends CoachSendUpdate {
  final String text;
  final List<dynamic> actions;
  const CoachSendCompleted(this.text, this.actions);
}

class CoachSendFailed extends CoachSendUpdate {
  final Failure failure;
  const CoachSendFailed(this.failure);
}
