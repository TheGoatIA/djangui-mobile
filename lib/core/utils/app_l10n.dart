import 'dart:ui' show Locale;

import 'package:kauri/di/injection.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Traductions SANS `BuildContext` (blocs, services, dépôts) : langue choisie
/// dans les réglages, sinon le français — même règle que l'interface
/// (SettingsBloc : français par défaut), pour que tous les textes concordent.
AppLocalizations appL10n() {
  String code;
  try {
    code = getIt<SharedPreferences>().getString('language_code') ?? 'fr';
  } catch (_) {
    code = 'fr';
  }
  return lookupAppLocalizations(Locale(code == 'en' ? 'en' : 'fr'));
}
