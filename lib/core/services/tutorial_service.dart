import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

/// Service gérant l'état d'affichage des tutoriels et visites guidées (Showcase).
///
/// Permet de savoir si un utilisateur a déjà vu une étape d'initiation et
/// de réinitialiser ces états pour une nouvelle visite.
@lazySingleton
class TutorialService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _kPrefix = 'tutorial_seen_';

  TutorialService(this._prefs);

  /// Vérifie si le tutoriel associé à la clé [key] a déjà été consulté.
  bool hasSeenTutorial(String key) {
    return _prefs.getBool('$_kPrefix$key') ?? false;
  }

  /// Marque le tutoriel associé à la clé [key] comme terminé.
  Future<void> markTutorialAsSeen(String key) async {
    await _prefs.setBool('$_kPrefix$key', true);
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
    notifyListeners();
  }
}
