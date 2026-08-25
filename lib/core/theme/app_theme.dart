import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Classe centrale définissant les thèmes (Clair et Sombre) de l'application.
///
/// Utilise Material 3 et configure tous les styles par défaut des composants
/// standard Flutter (Buttons, Inputs, AppBars, etc.).
class AppTheme {
  /// Retourne la configuration complète du Thème Clair (Light Mode).
  static ThemeData lightTheme([String? fontFamily]) {
    final textTheme = AppTypography.getTextTheme(
      Brightness.light,
      fontFamily ?? AppTypography.fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily ?? AppTypography.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.outline,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,

      // Configuration des barres d'application
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      // Style par défaut des cartes
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Barre de navigation inférieure
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily ?? AppTypography.fontFamily,
          ),
        ),
      ),

      // Style global des boutons surélevés
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Configuration des champs de saisie (Inputs)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  /// Retourne la configuration complète du Thème Sombre (Dark Mode).
  static ThemeData darkTheme([String? fontFamily]) {
    final textTheme = AppTypography.getTextTheme(
      Brightness.dark,
      fontFamily ?? AppTypography.fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily ?? AppTypography.fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDarkTheme,
        onPrimary: AppColors.backgroundDark,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        surfaceContainerHighest: AppColors.backgroundDark,
        onSurfaceVariant: AppColors.onSurfaceDark,
        outline: AppColors.outlineDark,
        outlineVariant: Color(0xFF334155),
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: textTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onBackgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.outlineDark, width: 1),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primaryDarkTheme.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily ?? AppTypography.fontFamily,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDarkTheme,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryDarkTheme,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  /// Retourne le thème exclusif "Obsidienne & Or" pour les membres Premium.
  static ThemeData obsidianGoldTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.goldAccent,
        onPrimary: AppColors.obsidianBlack,
        secondary: AppColors.goldLight,
        onSecondary: AppColors.obsidianBlack,
        surface: AppColors.obsidianSurface,
        onSurface: Colors.white,
        outline: AppColors.goldAccent.withValues(alpha: 0.3),
      ),
      scaffoldBackgroundColor: AppColors.obsidianBlack,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.obsidianSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldAccent, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.obsidianBlack,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.obsidianBlack,
      ),
    );
  }

  /// Retourne le thème exclusif "Nuit Polaire" pour les membres Premium.
  static ThemeData polarNightTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.polarIce,
        onPrimary: AppColors.polarDeepBlue,
        secondary: AppColors.polarSilver,
        onSecondary: AppColors.polarDeepBlue,
        surface: AppColors.polarSurface,
        onSurface: Colors.white,
        outline: AppColors.polarIce.withValues(alpha: 0.2),
      ),
      scaffoldBackgroundColor: AppColors.polarDeepBlue,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.polarSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.polarIce, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.polarDeepBlue,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.polarDeepBlue,
      ),
    );
  }

  /// Retourne le thème exclusif "Crépuscule" pour les membres Premium.
  static ThemeData sunsetGlowTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.sunsetOrange,
        onPrimary: AppColors.sunsetPurple,
        secondary: AppColors.sunsetPink,
        onSecondary: Colors.white,
        surface: AppColors.sunsetSurface,
        onSurface: Colors.white,
        outline: AppColors.sunsetOrange.withValues(alpha: 0.2),
      ),
      scaffoldBackgroundColor: AppColors.sunsetPurple,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.sunsetSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.sunsetOrange, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.sunsetPurple,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.sunsetPurple,
      ),
    );
  }

  /// Retourne le thème exclusif "Forêt d'Émeraude" pour les membres Premium.
  static ThemeData emeraldForestTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.emeraldLime,
        onPrimary: AppColors.emeraldDeep,
        secondary: AppColors.emeraldWood,
        onSecondary: Colors.white,
        surface: AppColors.emeraldSurface,
        onSurface: Colors.white,
        outline: AppColors.emeraldLime.withValues(alpha: 0.2),
      ),
      scaffoldBackgroundColor: AppColors.emeraldDeep,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.emeraldSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.emeraldLime, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.emeraldDeep,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.emeraldDeep,
      ),
    );
  }

  /// Retourne le thème exclusif "Royal de Minuit" pour les membres Premium.
  static ThemeData midnightRoyalTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.royalGold,
        onPrimary: AppColors.royalBlue,
        secondary: AppColors.royalAccent,
        onSecondary: Colors.white,
        surface: AppColors.royalSurface,
        onSurface: Colors.white,
        outline: AppColors.royalAccent.withValues(alpha: 0.3),
      ),
      scaffoldBackgroundColor: AppColors.royalBlue,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.royalSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.royalAccent, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.royalBlue,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.royalBlue,
      ),
    );
  }

  /// Retourne le thème exclusif "Velours Rose" pour les membres Premium.
  static ThemeData roseVelvetTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.roseVelvetAccent,
        onPrimary: Colors.white,
        secondary: AppColors.roseVelvetSecondary,
        onSecondary: AppColors.roseVelvetDeep,
        surface: AppColors.roseVelvetSurface,
        onSurface: Colors.white,
        outline: AppColors.roseVelvetAccent.withValues(alpha: 0.25),
      ),
      scaffoldBackgroundColor: AppColors.roseVelvetDeep,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.roseVelvetSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.roseVelvetAccent, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.roseVelvetDeep,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.roseVelvetDeep,
      ),
    );
  }

  /// Retourne le thème exclusif "Braise Rubis" pour les membres Premium.
  static ThemeData rubyEmberTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.rubyAccent,
        onPrimary: Colors.white,
        secondary: AppColors.rubySecondary,
        onSecondary: AppColors.rubyBlack,
        surface: AppColors.rubySurface,
        onSurface: Colors.white,
        outline: AppColors.rubyAccent.withValues(alpha: 0.25),
      ),
      scaffoldBackgroundColor: AppColors.rubyBlack,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.rubySurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.rubyAccent, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: AppColors.rubyBlack),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.rubyBlack,
      ),
    );
  }

  /// Retourne le thème exclusif "Abysse Océanique" pour les membres Premium.
  static ThemeData oceanAbyssTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.abyssAccent,
        onPrimary: AppColors.abyssDeep,
        secondary: AppColors.abyssSecondary,
        onSecondary: Colors.white,
        surface: AppColors.abyssSurface,
        onSurface: Colors.white,
        outline: AppColors.abyssAccent.withValues(alpha: 0.25),
      ),
      scaffoldBackgroundColor: AppColors.abyssDeep,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.abyssSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.abyssAccent, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: AppColors.abyssDeep),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.abyssDeep,
      ),
    );
  }

  /// Retourne le thème exclusif "Néon Cyber" pour les membres Premium.
  static ThemeData cyberNeonTheme([String? fontFamily]) {
    final base = darkTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.cyberMagenta,
        onPrimary: Colors.white,
        secondary: AppColors.cyberCyan,
        onSecondary: AppColors.cyberVoid,
        surface: AppColors.cyberSurface,
        onSurface: Colors.white,
        outline: AppColors.cyberCyan.withValues(alpha: 0.3),
      ),
      scaffoldBackgroundColor: AppColors.cyberVoid,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.cyberSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cyberMagenta, width: 0.5),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(backgroundColor: AppColors.cyberVoid),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.cyberVoid,
      ),
    );
  }

  /// Retourne le thème exclusif "Nacre Champagne" pour les membres Premium —
  /// le seul thème premium en mode clair, pour ceux qui veulent un look
  /// distinctif sans passer par le mode sombre.
  static ThemeData champagnePearlTheme([String? fontFamily]) {
    final base = lightTheme(fontFamily);
    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary: AppColors.pearlAccent,
        onPrimary: Colors.white,
        secondary: AppColors.pearlSecondary,
        onSecondary: Colors.white,
        surface: AppColors.pearlSurface,
        onSurface: AppColors.pearlSecondary,
        outline: AppColors.pearlAccent.withValues(alpha: 0.3),
      ),
      scaffoldBackgroundColor: AppColors.pearlBackground,
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.pearlSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.pearlAccent.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.pearlBackground,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: AppColors.pearlBackground,
      ),
    );
  }
}
