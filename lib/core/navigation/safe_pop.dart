import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension SafePop on BuildContext {
  /// Ferme l'écran courant, ou — s'il est le seul de la pile (ouvert par un
  /// lien, une notification, un `go`) — va sur [fallback].
  ///
  /// Un simple `pop()` sur la dernière page vidait la pile du navigateur : plus
  /// aucun écran (assertion GoRouter, constaté en E2E sur « Changer le mot de
  /// passe » ouvert directement).
  void popOrGo(String fallback, [Object? result]) {
    if (canPop()) {
      pop(result);
    } else {
      go(fallback);
    }
  }
}
