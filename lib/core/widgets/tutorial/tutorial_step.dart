import 'package:flutter/widgets.dart';

/// Décrit une étape d'un tutoriel guidé : la cible à mettre en surbrillance
/// et le texte à afficher dans la carte d'explication associée.
class TutorialStep {
  /// Clé du widget à mettre en surbrillance. Doit être attachée à un widget
  /// déjà construit dans l'arbre au moment où le tutoriel démarre.
  final GlobalKey targetKey;

  final String title;
  final String description;

  /// Forme de la découpe (spotlight) autour de la cible. Par défaut un
  /// rectangle arrondi ; utiliser `CircleBorder()` pour les cibles rondes
  /// (icônes, avatars).
  final ShapeBorder shape;

  /// Marge ajoutée autour des dimensions réelles de la cible avant de
  /// calculer la découpe — évite un halo trop collé au widget.
  final EdgeInsets targetPadding;

  const TutorialStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    this.targetPadding = const EdgeInsets.all(8),
  });
}
