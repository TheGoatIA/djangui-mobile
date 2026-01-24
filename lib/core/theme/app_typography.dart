import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gestionnaire de la typographie de l'application.
///
/// Définit le [TextTheme] utilisé par Material Design 3, en précisant les
/// polices, tailles, graisses et interlignages pour chaque style de texte.
class AppTypography {
  /// Nom de la police de caractères principale (Outfit).
  static const String fontFamily = 'Outfit';

  /// Retourne le thème textuel pour le mode clair.
  static TextTheme get lightTextTheme =>
      TextTheme(
        // --- Grands titres d'affichage ---
        displayLarge: _baseStyle.copyWith(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          height: 1.12,
          letterSpacing: -0.25,
        ),
        displayMedium: _baseStyle.copyWith(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: 0,
        ),
        displaySmall: _baseStyle.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0,
        ),

        // --- Titres de sections ---
        headlineLarge: _baseStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0,
        ),
        headlineMedium: _baseStyle.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.28,
          letterSpacing: 0,
        ),
        headlineSmall: _baseStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
          letterSpacing: 0,
        ),

        // --- Titres de composants ---
        titleLarge: _baseStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 1.27,
          letterSpacing: 0,
        ),
        titleMedium: _baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0.15,
        ),
        titleSmall: _baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.1,
        ),

        // --- Corps de texte (Lecture) ---
        bodyLarge: _baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        bodyMedium: _baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: 0.25,
        ),
        bodySmall: _baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0.4,
        ),

        // --- Étiquettes et petits éléments (Boutons, légendes) ---
        labelLarge: _baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          letterSpacing: 0.1,
        ),
        labelMedium: _baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.33,
          letterSpacing: 0.5,
        ),
        labelSmall: _baseStyle.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.45,
          letterSpacing: 0.5,
        ),
      ).apply(
        displayColor: AppColors.textPrimary,
        bodyColor: AppColors.textPrimary,
      );

  /// Retourne le thème textuel adapté au mode sombre.
  static TextTheme get darkTextTheme => lightTextTheme.apply(
    displayColor: AppColors.textPrimaryDark,
    bodyColor: AppColors.textPrimaryDark,
  );

  /// Style de base partagé par tous les textes pour garantir la cohérence de la police.
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: fontFamily,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
