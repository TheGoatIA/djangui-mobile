import 'package:flutter/material.dart';

/// Définition des ombres portées (Shadows) utilisées dans l'application.
///
/// Suit les conventions de design moderne (sm, md, lg) pour apporter de la
/// profondeur aux surfaces et aux composants.
class AppShadows {
  static const Color _shadowColor = Color(0x1F000000); // Noir à 12% d'opacité

  /// Petite ombre pour les éléments discrets.
  static const List<BoxShadow> sm = [
    BoxShadow(color: _shadowColor, offset: Offset(0, 1), blurRadius: 2),
  ];

  /// Ombre moyenne pour les boutons et petits composants surélevés.
  static const List<BoxShadow> md = [
    BoxShadow(color: _shadowColor, offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(
      color: _shadowColor,
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  /// Ombre prononcée pour les menus contextuels ou les éléments flottants.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: _shadowColor,
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: _shadowColor,
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  /// Ombre spécifique optimisée pour les cartes (Cards) du tableau de bord.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000),
      offset: Offset(0, 0),
      blurRadius: 1,
      spreadRadius: 1,
    ),
  ];

  /// Ombre "Premium" très douce et étendue pour un aspect haut de gamme.
  static const List<BoxShadow> premium = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 10),
      blurRadius: 30,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -2,
    ),
  ];
}
