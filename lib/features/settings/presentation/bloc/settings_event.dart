part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ThemeChanged extends SettingsEvent {
  final AppThemeType themeType;

  const ThemeChanged(this.themeType);

  @override
  List<Object> get props => [themeType];
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

class UpdateDashboardOrder extends SettingsEvent {
  final List<String> newOrder;

  const UpdateDashboardOrder(this.newOrder);

  @override
  List<Object> get props => [newOrder];
}

class FontChanged extends SettingsEvent {
  final String fontFamily;

  const FontChanged(this.fontFamily);

  @override
  List<Object> get props => [fontFamily];
}

class AppIconChanged extends SettingsEvent {
  final String? iconName;

  const AppIconChanged(this.iconName);

  @override
  List<Object?> get props => [iconName];
}
