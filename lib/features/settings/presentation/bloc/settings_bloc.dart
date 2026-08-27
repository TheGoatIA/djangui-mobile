import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kauri/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/theme/app_theme_type.dart';
import '../../../../core/services/app_icon_service.dart';
import '../../../../core/services/log_service.dart';
import '../../../../di/injection.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences _prefs;
  final AuthRepository _authRepository;
  LogService get _logger => getIt<LogService>();

  SettingsBloc(this._prefs, this._authRepository)
    : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeChanged>(_onThemeChanged);
    on<LocaleChanged>(_onLocaleChanged);
    on<ToggleBiometrics>(_onToggleBiometrics);
    on<UpdateDashboardOrder>(_onUpdateDashboardOrder);
    on<FontChanged>(_onFontChanged);
    on<AppIconChanged>(_onAppIconChanged);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final themeIndex = _prefs.getInt('theme_mode');
    final languageCode = _prefs.getString('language_code');
    final biometricsEnabled = _prefs.getBool('biometrics_enabled') ?? false;

    final storedDashboardOrder = _prefs.getStringList('dashboard_order');
    // Un utilisateur qui a déjà réordonné son dashboard a une liste persistée
    // qui ne connaît pas les nouvelles clés de widget ajoutées depuis (ex.
    // 'reste_a_vivre') — sans ce merge, ces widgets ne s'afficheraient plus
    // jamais pour lui une fois qu'il a personnalisé l'ordre une première fois.
    final dashboardOrder = storedDashboardOrder != null
        ? [
            ...storedDashboardOrder,
            ...state.dashboardOrder.where(
              (key) => !storedDashboardOrder.contains(key),
            ),
          ]
        : null;
    final fontFamily = _prefs.getString('font_family') ?? 'Outfit';
    final appIcon = _prefs.getString('app_icon');

    emit(
      state.copyWith(
        themeType: themeIndex != null
            ? AppThemeType.values[themeIndex]
            : AppThemeType.system,
        locale: languageCode != null
            ? Locale(languageCode)
            : const Locale('fr'),
        biometricsEnabled: biometricsEnabled,
        dashboardOrder: dashboardOrder,
        fontFamily: fontFamily,
        appIcon: appIcon,
      ),
    );
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info(
      'Changement du thème: ${event.themeType.name}',
      component: 'SettingsBloc',
    );
    await _prefs.setInt('theme_mode', event.themeType.index);
    emit(state.copyWith(themeType: event.themeType));
  }

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info(
      'Changement de la langue: ${event.locale.languageCode}',
      component: 'SettingsBloc',
    );
    await _prefs.setString('language_code', event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));

    // Signaler le changement au backend si l'utilisateur est connecté.
    try {
      if (await _authRepository.isAuthenticated()) {
        await _authRepository.updateLanguage(event.locale.languageCode);
      }
    } catch (e) {
      _logger.warning(
        'Échec de la synchronisation de la langue avec le backend',
        component: 'SettingsBloc',
        metadata: {'error': e.toString()},
      );
    }
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info(
      'Modification de la biométrie: ${event.enabled}',
      component: 'SettingsBloc',
    );
    await _prefs.setBool('biometrics_enabled', event.enabled);
    emit(state.copyWith(biometricsEnabled: event.enabled));
  }

  Future<void> _onUpdateDashboardOrder(
    UpdateDashboardOrder event,
    Emitter<SettingsState> emit,
  ) async {
    await _prefs.setStringList('dashboard_order', event.newOrder);
    emit(state.copyWith(dashboardOrder: event.newOrder));
  }

  Future<void> _onFontChanged(
    FontChanged event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info(
      'Changement de police: ${event.fontFamily}',
      component: 'SettingsBloc',
    );
    await _prefs.setString('font_family', event.fontFamily);
    emit(state.copyWith(fontFamily: event.fontFamily));
  }

  Future<void> _onAppIconChanged(
    AppIconChanged event,
    Emitter<SettingsState> emit,
  ) async {
    _logger.info(
      'Changement d\'icône de l\'application: ${event.iconName}',
      component: 'SettingsBloc',
    );
    // 1. Sauvegarder la préférence locale (Source de vérité UI)
    if (event.iconName != null) {
      await _prefs.setString('app_icon', event.iconName!);
    } else {
      await _prefs.remove('app_icon');
    }

    emit(state.copyWith(appIcon: event.iconName));

    // 2. Appeler le service natif (Fire-and-forget pour ne pas bloquer l'UI)
    // On ne bloque pas l'émission de l'état car le changement d'icône peut être lent ou kill l'app.
    getIt<AppIconService>().changeIcon(event.iconName);
  }
}
