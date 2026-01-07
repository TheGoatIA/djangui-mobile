part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends SettingsEvent {
  final ThemeMode themeMode;

  const ThemeChanged(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class LocaleChanged extends SettingsEvent {
  final Locale locale;

  const LocaleChanged(this.locale);

  @override
  List<Object> get props => [locale];
}

class LoadSettings extends SettingsEvent {}

class ToggleBiometrics extends SettingsEvent {
  final bool enabled;

  const ToggleBiometrics(this.enabled);

  @override
  List<Object> get props => [enabled];
}
