import 'package:flutter/material.dart';

/// Styles de texte (TextStyles) bruts utilisés dans l'application.
///
/// Note : Il est recommandé d'utiliser le [TextTheme] du contexte via `Theme.of(context).textTheme`
/// plutôt que ces constantes directement, sauf cas exceptionnel.
class AppTextStyles {
  /// Police de caractères principale (Google Fonts: Outfit).
  static const String fontFamily = 'Outfit';

  // --- Titres (Headlines) ---
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headlineLarge = h1;
  static const TextStyle headlineMedium = h2;

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // --- Corps de texte (Body) ---
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // --- Étiquettes (Labels / Captions) ---
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );
}
