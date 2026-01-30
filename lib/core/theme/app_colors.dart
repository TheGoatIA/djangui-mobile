import 'package:flutter/material.dart';

/// Définition de la palette de couleurs officielle de l'application Kauri.
///
/// Centralise les couleurs de marque, les neutres pour les modes clair/sombre,
/// ainsi que les couleurs sémantiques (succès, erreur, etc.).
class AppColors {
  // --- Couleurs de marque (Kauri Brand) ---
  /// Vert émeraude signature de Kauri.
  static const Color primary = Color(0xFF059669);

  /// Vert profond utilisé pour les contrastes ou les fonds sombres.
  static const Color primaryDark = Color(0xFF064E3B);

  /// Vert émeraude clair utilisé pour les interactions ou les accents.
  static const Color primaryLight = Color(0xFF10B981);

  /// Or Kauri utilisé pour les éléments Premium ou les récompenses.
  static const Color secondary = Color(0xFFD4AF37);

  /// Ambre utilisé pour attirer l'attention sur des éléments spécifiques.
  static const Color accent = Color(0xFFF59E0B);

  /// Or clair pour les états secondaires.
  static const Color secondaryLight = Color(0xFFFCD34D);

  // --- Dégradés (Gradients) ---
  /// Dégradé de marque basé sur les variations de vert.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dégradé mixte Vert-Or représentant l'identité visuelle Kauri.
  static const LinearGradient kauriGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dégradé de surface doux pour les fonds en mode clair.
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dégradé de surface pour les fonds en mode sombre.
  static const LinearGradient surfaceDarkGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // --- Neutres : Mode Clair (Light Mode) ---
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF111827);
  static const Color onSurface = Color(0xFF374151);
  static const Color outline = Color(0xFFE5E7EB);

  // --- Neutres : Mode Sombre (Dark Mode) ---
  static const Color primaryDarkTheme = Color(0xFF10B981);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color onSurfaceDark = Color(0xFFCBD5E1);
  static const Color outlineDark = Color(0xFF334155);
  static const Color darkSurface = surfaceDark;

  // --- Couleurs Sémantiques ---
  /// Couleur de validation et de succès.
  static const Color success = Color(0xFF059669);

  /// Couleur d'alerte ou de mise en garde.
  static const Color warning = Color(0xFFF59E0B);

  /// Couleur d'erreur critique.
  static const Color error = Color(0xFFEF4444);

  /// Couleur d'information neutre.
  static const Color info = Color(0xFF3B82F6);

  // --- Couleurs de texte (Mode Clair) ---
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // --- Couleurs de texte (Mode Sombre) ---
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);

  // --- Obsidian & Gold (Premium) ---
  static const Color obsidianBlack = Color(0xFF0F0F0F);
  static const Color obsidianSurface = Color(0xFF1A1A1A);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFD700);

  static const LinearGradient obsidianGoldGradient = LinearGradient(
    colors: [obsidianBlack, Color(0xFF2C2C2C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Polar Night (Premium) ---
  static const Color polarDeepBlue = Color(0xFF0B1118);
  static const Color polarSurface = Color(0xFF141D26);
  static const Color polarIce = Color(0xFF81D4FA);
  static const Color polarSilver = Color(0xFFB0BEC5);

  static const LinearGradient polarNightGradient = LinearGradient(
    colors: [polarDeepBlue, Color(0xFF1A2634)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Sunset Glow (Premium) ---
  static const Color sunsetPurple = Color(0xFF2D1B36);
  static const Color sunsetSurface = Color(0xFF3B2447);
  static const Color sunsetOrange = Color(0xFFFF8C42);
  static const Color sunsetPink = Color(0xFFF06292);

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [sunsetPurple, Color(0xFF4A2C59)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Emerald Forest (Premium) ---
  static const Color emeraldDeep = Color(0xFF062C21);
  static const Color emeraldSurface = Color(0xFF0A3D2E);
  static const Color emeraldLime = Color(0xFFD4E157);
  static const Color emeraldWood = Color(0xFF795548);

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [emeraldDeep, Color(0xFF0E4D3B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Midnight Royal (Premium) ---
  static const Color royalBlue = Color(0xFF0D1B2A);
  static const Color royalSurface = Color(0xFF1B263B);
  static const Color royalGold = Color(0xFFE0E1DD);
  static const Color royalAccent = Color(0xFF415A77);

  static const LinearGradient royalGradient = LinearGradient(
    colors: [royalBlue, Color(0xFF1B3A5A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
