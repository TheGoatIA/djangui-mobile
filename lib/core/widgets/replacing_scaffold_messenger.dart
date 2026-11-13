import 'package:flutter/material.dart';

/// ScaffoldMessenger dont chaque nouveau message REMPLACE le précédent.
///
/// Par défaut Flutter met les SnackBar en file : la confirmation d'une action
/// (« Épargne ajoutée ») attendait la fin du message précédent (« Objectif
/// créé », 4 s) — mesuré en E2E : ~3,5 s de retard perçu alors que l'API
/// répondait en < 100 ms. Installé une fois à la racine (MaterialApp.builder),
/// il couvre tous les `ScaffoldMessenger.of(context).showSnackBar(...)`.
class ReplacingScaffoldMessenger extends ScaffoldMessenger {
  const ReplacingScaffoldMessenger({super.key, required super.child});

  @override
  ScaffoldMessengerState createState() => _ReplacingScaffoldMessengerState();
}

class _ReplacingScaffoldMessengerState extends ScaffoldMessengerState {
  @override
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) {
    removeCurrentSnackBar(reason: SnackBarClosedReason.hide);
    return super.showSnackBar(
      snackBar,
      snackBarAnimationStyle: snackBarAnimationStyle,
    );
  }
}
