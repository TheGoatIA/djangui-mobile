import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';

enum AppThemeType {
  light,
  dark,
  system,
  obsidianGold,
  polarNight,
  sunsetGlow,
  emeraldForest,
  midnightRoyal,
  roseVelvet,
  rubyEmber,
  oceanAbyss,
  cyberNeon,
  champagnePearl;

  bool get isPremiumOnly => switch (this) {
    AppThemeType.light || AppThemeType.dark || AppThemeType.system => false,
    _ => true,
  };

  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeType.light:
      case AppThemeType.champagnePearl:
        return ThemeMode.light;
      case AppThemeType.dark:
      case AppThemeType.obsidianGold:
      case AppThemeType.polarNight:
      case AppThemeType.sunsetGlow:
      case AppThemeType.emeraldForest:
      case AppThemeType.midnightRoyal:
      case AppThemeType.roseVelvet:
      case AppThemeType.rubyEmber:
      case AppThemeType.oceanAbyss:
      case AppThemeType.cyberNeon:
        return ThemeMode.dark;
      case AppThemeType.system:
        return ThemeMode.system;
    }
  }

  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case AppThemeType.light:
        return l10n.lightTheme;
      case AppThemeType.dark:
        return l10n.darkTheme;
      case AppThemeType.system:
        return l10n.systemTheme;
      case AppThemeType.obsidianGold:
        return l10n.obsidianGoldThemeLabel;
      case AppThemeType.polarNight:
        return l10n.polarNightThemeLabel;
      case AppThemeType.sunsetGlow:
        return l10n.sunsetGlowThemeLabel;
      case AppThemeType.emeraldForest:
        return l10n.emeraldForestThemeLabel;
      case AppThemeType.midnightRoyal:
        return l10n.midnightRoyalThemeLabel;
      case AppThemeType.roseVelvet:
        return l10n.roseVelvetThemeLabel;
      case AppThemeType.rubyEmber:
        return l10n.rubyEmberThemeLabel;
      case AppThemeType.oceanAbyss:
        return l10n.oceanAbyssThemeLabel;
      case AppThemeType.cyberNeon:
        return l10n.cyberNeonThemeLabel;
      case AppThemeType.champagnePearl:
        return l10n.champagnePearlThemeLabel;
    }
  }

  /// The two colors used to render this theme's swatch preview in the
  /// selection grid — kept alongside the enum so the picker UI never has to
  /// duplicate a switch over every theme just to know what to paint.
  List<Color> get previewColors {
    switch (this) {
      case AppThemeType.light:
        return const [Color(0xFFFFFFFF), Color(0xFF059669)];
      case AppThemeType.dark:
        return const [Color(0xFF0F172A), Color(0xFF10B981)];
      case AppThemeType.system:
        return const [Color(0xFF9CA3AF), Color(0xFF059669)];
      case AppThemeType.obsidianGold:
        return const [Color(0xFF0F0F0F), Color(0xFFD4AF37)];
      case AppThemeType.polarNight:
        return const [Color(0xFF0B1118), Color(0xFF81D4FA)];
      case AppThemeType.sunsetGlow:
        return const [Color(0xFF2D1B36), Color(0xFFFF8C42)];
      case AppThemeType.emeraldForest:
        return const [Color(0xFF062C21), Color(0xFFD4E157)];
      case AppThemeType.midnightRoyal:
        return const [Color(0xFF0D1B2A), Color(0xFFE0E1DD)];
      case AppThemeType.roseVelvet:
        return const [Color(0xFF2A0E1D), Color(0xFFF43F8E)];
      case AppThemeType.rubyEmber:
        return const [Color(0xFF120505), Color(0xFFE0263E)];
      case AppThemeType.oceanAbyss:
        return const [Color(0xFF031B26), Color(0xFF22D3EE)];
      case AppThemeType.cyberNeon:
        return const [Color(0xFF0A0118), Color(0xFFF72585)];
      case AppThemeType.champagnePearl:
        return const [Color(0xFFFBF3EC), Color(0xFFB8895A)];
    }
  }
}
