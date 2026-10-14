import 'package:flutter/material.dart';
import 'package:kauri/core/services/success_animation_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/core/widgets/tutorial/tutorial_overlay.dart';
import 'package:kauri/core/widgets/tutorial/tutorial_step.dart';
import 'package:kauri/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

/// Service gérant l'état d'affichage des tutoriels et visites guidées.
///
/// Toutes les pages doivent démarrer leurs tutoriels via [startTutorial] et
/// libérer leur séquence via [cancelActiveTutorial] dans `dispose()`, plutôt
/// que de piloter directement l'overlay : cela garantit qu'une clé n'est
/// jamais marquée comme "vue" tant que l'utilisateur ne l'a pas réellement
/// terminée, et qu'on n'a jamais deux séquences qui se chevauchent (une seule
/// séquence active à la fois, quel que soit l'écran).
@lazySingleton
class TutorialService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _kPrefix = 'tutorial_seen_';

  TutorialService(this._prefs);

  bool _tutorialInProgress = false;
  String? _activeTutorialKey;

  /// Vrai si une séquence de tutoriel est en cours d'affichage quelque part
  /// dans l'app (une seule à la fois).
  bool get isTutorialInProgress => _tutorialInProgress;

  /// Vérifie si le tutoriel associé à la clé [key] a déjà été consulté.
  bool hasSeenTutorial(String key) {
    return _prefs.getBool('$_kPrefix$key') ?? false;
  }

  /// Démarre la séquence [steps] pour la clé [key] si elle n'a pas déjà été
  /// vue et qu'aucune autre séquence n'est en cours.
  ///
  /// [steps] doit contenir uniquement les étapes dont la cible est réellement
  /// construite dans l'arbre au moment de l'appel (ex : ne pas inclure une
  /// étape cachée derrière un feature flag désactivé ou un état de
  /// chargement) — une cible introuvable est simplement sautée plutôt que de
  /// bloquer la séquence, mais autant ne pas la lister du tout.
  ///
  /// Retourne `true` si la séquence a effectivement démarré.
  bool startTutorial(
    BuildContext context,
    String key,
    List<TutorialStep> steps,
  ) {
    if (steps.isEmpty || hasSeenTutorial(key) || _tutorialInProgress) {
      return false;
    }
    _tutorialInProgress = true;
    _activeTutorialKey = key;
    TutorialOverlayController.show(
      context,
      steps: steps,
      onFinish: () => _onSequenceEnded(seen: true),
      onSkip: () => _onSequenceEnded(seen: false),
    );
    return true;
  }

  Future<void> _onSequenceEnded({required bool seen}) async {
    _tutorialInProgress = false;
    final key = _activeTutorialKey;
    _activeTutorialKey = null;
    if (key == null) return;
    if (seen) {
      await markTutorialAsSeen(key);
      // Petit moment de satisfaction à la fin d'une séquence complétée.
      getIt<SuccessAnimationService>().showSuccess();
    }
  }

  /// À appeler depuis `dispose()` des pages qui démarrent un tutoriel, pour
  /// fermer proprement l'overlay et libérer le verrou [isTutorialInProgress]
  /// si l'utilisateur quitte la page avant d'avoir terminé la séquence.
  void cancelActiveTutorial(BuildContext context) {
    TutorialOverlayController.hide();
    _tutorialInProgress = false;
    _activeTutorialKey = null;
  }

  /// Marque le tutoriel associé à la clé [key] comme terminé.
  Future<void> markTutorialAsSeen(String key) async {
    await _prefs.setBool('$_kPrefix$key', true);

    // Telemetry: Tutorial Funnel
    getIt<TelemetryService>().recordEvent('ux.tutorial.step_completed', {
      'step_key': key,
    });
  }

  /// Déclenche une notification aux écouteurs pour forcer une vérification (rebuild UI).
  void triggerTutorialCheck() {
    notifyListeners();
  }

  /// Réinitialise l'état d'un tutoriel spécifique.
  Future<void> resetTutorial(String key) async {
    await _prefs.remove('$_kPrefix$key');
  }

  /// Supprime tous les marqueurs de tutoriels consultés.
  /// Utile pour proposer à l'utilisateur de refaire toute la découverte de l'app.
  Future<void> resetAllTutorials() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_kPrefix)) {
        await _prefs.remove(key);
      }
    }
    _tutorialInProgress = false;
    _activeTutorialKey = null;
    notifyListeners();
  }
}
