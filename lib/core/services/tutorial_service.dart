import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TutorialService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _kPrefix = 'tutorial_seen_';

  TutorialService(this._prefs);

  /// Checks if a tutorial for the given [key] has been seen.
  bool hasSeenTutorial(String key) {
    return _prefs.getBool('$_kPrefix$key') ?? false;
  }

  /// Marks a tutorial for the given [key] as seen.
  Future<void> markTutorialAsSeen(String key) async {
    await _prefs.setBool('$_kPrefix$key', true);
  }

  void triggerTutorialCheck() {
    notifyListeners();
  }

  /// Resets a tutorial for the given [key]. Useful for testing.
  Future<void> resetTutorial(String key) async {
    await _prefs.remove('$_kPrefix$key');
  }

  /// Resets all tutorials.
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
