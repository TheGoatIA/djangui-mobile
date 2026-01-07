part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool biometricsEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('fr'),
    this.biometricsEnabled = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? biometricsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }

  @override
  List<Object> get props => [themeMode, locale, biometricsEnabled];
}
