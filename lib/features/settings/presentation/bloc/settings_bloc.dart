import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kauri/features/auth/domain/repositories/auth_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;
  final AuthRepository _authRepository;

  SettingsBloc(this._prefs, this._authRepository)
    : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeChanged>(_onThemeChanged);
    on<LocaleChanged>(_onLocaleChanged);
    on<ToggleBiometrics>(_onToggleBiometrics);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final themeIndex = _prefs.getInt('theme_mode');
    final languageCode = _prefs.getString('language_code');
    final biometricsEnabled = _prefs.getBool('biometrics_enabled') ?? false;

    emit(
      state.copyWith(
        themeMode: themeIndex != null
            ? ThemeMode.values[themeIndex]
            : ThemeMode.system,
        locale: languageCode != null
            ? Locale(languageCode)
            : const Locale('fr'),
        biometricsEnabled: biometricsEnabled,
      ),
    );
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setInt('theme_mode', event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setString('language_code', event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));

    // Signaler le changement au backend si l'utilisateur est connecté.
    try {
      if (await _authRepository.isAuthenticated()) {
        await _authRepository.updateLanguage(event.locale.languageCode);
      }
    } catch (e) {
      debugPrint('⚠️ [SettingsBloc] Failed to sync language with backend: $e');
    }
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setBool('biometrics_enabled', event.enabled);
    emit(state.copyWith(biometricsEnabled: event.enabled));
  }
}
