import 'package:flutter/material.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:showcaseview/showcaseview.dart';

/// Service gérant l'état d'affichage des tutoriels et visites guidées (Showcase).
///
/// Toutes les pages doivent démarrer leurs tutoriels via [startTutorial] et
/// libérer leur séquence via [cancelActiveTutorial] dans `dispose()`, plutôt
/// que d'appeler directement `ShowCaseWidget.of(context)` : cela garantit
/// qu'une clé n'est jamais marquée comme "vue" tant que l'utilisateur ne l'a
/// pas réellement terminée, et qu'on n'a jamais deux séquences qui se
/// chevauchent (il n'existe qu'un seul [ShowCaseWidget] racine dans l'app).
@lazySingleton
class TutorialService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _kPrefix = 'tutorial_seen_';

  TutorialService(this._prefs);

  bool _tutorialInProgress = false;
  String? _activeTutorialKey;

  /// Vrai si une séquence de showcase est en cours d'affichage quelque part
  /// dans l'app (il n'y a qu'un ShowCaseWidget racine, donc une seule à la fois).
  bool get isTutorialInProgress => _tutorialInProgress;

  /// Vérifie si le tutoriel associé à la clé [key] a déjà été consulté.
  bool hasSeenTutorial(String key) {
    return _prefs.getBool('$_kPrefix$key') ?? false;
  }

  /// Démarre la séquence de showcase [targets] pour la clé [key] si elle n'a
  /// pas déjà été vue et qu'aucune autre séquence n'est en cours.
  ///
  /// [targets] doit contenir uniquement les clés des [Showcase] réellement
  /// construits dans l'arbre au moment de l'appel (ex : ne pas inclure une
  /// clé cachée derrière un feature flag désactivé ou un état de chargement),
  /// sinon la séquence reste bloquée indéfiniment sur cette étape.
  ///
  /// Retourne `true` si la séquence a effectivement démarré.
  bool startTutorial(
    BuildContext context,
    String key,
    List<GlobalKey> targets,
  ) {
    if (targets.isEmpty || hasSeenTutorial(key) || _tutorialInProgress) {
      return false;
    }
    _tutorialInProgress = true;
    _activeTutorialKey = key;
    ShowCaseWidget.of(context).startShowCase(targets);
    return true;
  }

  /// À relier au `onFinish` du [ShowCaseWidget] racine (lib/main.dart).
  /// Marque la séquence active comme vue uniquement quand l'utilisateur est
  /// allé jusqu'au bout, pour ne jamais "brûler" un tutoriel qui n'a pas pu
  /// s'afficher correctement.
  Future<void> completeActiveTutorial() async {
    _tutorialInProgress = false;
    final key = _activeTutorialKey;
    _activeTutorialKey = null;
    if (key == null) return;
    await markTutorialAsSeen(key);
  }

  /// À appeler depuis `dispose()` des pages qui démarrent un tutoriel, pour
  /// fermer proprement l'overlay et libérer le verrou [isTutorialInProgress]
  /// si l'utilisateur quitte la page avant d'avoir terminé la séquence.
  void cancelActiveTutorial(BuildContext context) {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
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
