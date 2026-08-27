/// Événements du flux NDJSON de `/coach/ask/stream` — un objet JSON par
/// ligne (`{"delta": "..."}`, `{"done": true, "actions": [...]}`, ou
/// `{"error": "..."}`). Voir `CoachController.askStream` côté backend.
sealed class CoachStreamEvent {
  const CoachStreamEvent();
}

class CoachStreamDelta extends CoachStreamEvent {
  final String text;
  const CoachStreamDelta(this.text);
}

class CoachStreamDone extends CoachStreamEvent {
  final List<dynamic> actions;
  const CoachStreamDone(this.actions);
}

class CoachStreamFailure extends CoachStreamEvent {
  final String message;
  const CoachStreamFailure(this.message);
}
