import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Gestionnaire de la typographie de l'application.
///
/// Définit le [TextTheme] utilisé par Material Design 3, en précisant les
/// polices, tailles, graisses et interlignages pour chaque style de texte.
class AppTypography {
  /// Nom de la police de caractères principale (Outfit).
  static const String fontFamily = 'Outfit';

  /// Retourne le thème textuel pour le mode clair.
  static TextTheme get lightTextTheme => getTextTheme(Brightness.light);

  /// Retourne le thème textuel adapté au mode sombre.
  static TextTheme get darkTextTheme => getTextTheme(Brightness.dark);

  /// Retourne un TextTheme dynamique basé sur la police et la luminosité.
  static TextTheme getTextTheme(Brightness brightness, [String? family]) {
    final theme = TextTheme(
      // --- Grands titres d'affichage ---
      displayLarge: _style(family).copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 1.12,
        letterSpacing: -0.25,
      ),
      displayMedium: _style(family).copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: 0,
      ),
      displaySmall: _style(family).copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0,
      ),

      // --- Titres de sections ---
      headlineLarge: _style(family).copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0,
      ),
      headlineMedium: _style(family).copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.28,
        letterSpacing: 0,
      ),
      headlineSmall: _style(family).copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0,
      ),

      // --- Titres de composants ---
      titleLarge: _style(family).copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.27,
        letterSpacing: 0,
      ),
      titleMedium: _style(family).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.15,
      ),
      titleSmall: _style(family).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
      ),

      // --- Corps de texte (Lecture) ---
      bodyLarge: _style(family).copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
      ),
      bodyMedium: _style(family).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
      ),
      bodySmall: _style(family).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
      ),

      // --- Étiquettes et petits éléments (Boutons, légendes) ---
      labelLarge: _style(family).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      labelMedium: _style(family).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
      ),
      labelSmall: _style(family).copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
      ),
    );

    return theme.apply(
      displayColor: brightness == Brightness.light
          ? AppColors.textPrimary
          : AppColors.textPrimaryDark,
      bodyColor: brightness == Brightness.light
          ? AppColors.textPrimary
          : AppColors.textPrimaryDark,
    );
  }

  /// Style de base partagé.
  static TextStyle _style([String? family]) {
    try {
      return GoogleFonts.getFont(
        family ?? fontFamily,
      ).copyWith(leadingDistribution: TextLeadingDistribution.even);
    } catch (e) {
      // Fallback si la police n'est pas trouvée par GoogleFonts
      return TextStyle(
        fontFamily: family ?? fontFamily,
        leadingDistribution: TextLeadingDistribution.even,
      );
    }
  }
}
