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
  midnightRoyal;

  bool get isPremiumOnly => switch (this) {
    AppThemeType.light || AppThemeType.dark || AppThemeType.system => false,
    _ => true,
  };

  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeType.light:
        return ThemeMode.light;
      case AppThemeType.dark:
      case AppThemeType.obsidianGold:
      case AppThemeType.polarNight:
      case AppThemeType.sunsetGlow:
      case AppThemeType.emeraldForest:
      case AppThemeType.midnightRoyal:
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
    }
  }
}
