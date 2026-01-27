part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final AppThemeType themeType;
  final Locale locale;
  final bool biometricsEnabled;
  final List<String> dashboardOrder;
  final String fontFamily;
  final String? appIcon;

  const SettingsState({
    this.themeType = AppThemeType.system,
    this.locale = const Locale('fr'),
    this.biometricsEnabled = false,
    this.dashboardOrder = const [
      'gamification',
      'balance',
      'invoices',
      'quick_actions',
      'recent_activities',
    ],
    this.fontFamily = 'Outfit',
    this.appIcon,
  });

  SettingsState copyWith({
    AppThemeType? themeType,
    Locale? locale,
    bool? biometricsEnabled,
    List<String>? dashboardOrder,
    String? fontFamily,
    String? appIcon,
  }) {
    return SettingsState(
      themeType: themeType ?? this.themeType,
      locale: locale ?? this.locale,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      dashboardOrder: dashboardOrder ?? this.dashboardOrder,
      fontFamily: fontFamily ?? this.fontFamily,
      appIcon: appIcon ?? this.appIcon,
    );
  }

  @override
  List<Object?> get props => [
    themeType,
    locale,
    biometricsEnabled,
    dashboardOrder,
    fontFamily,
    appIcon,
  ];
}
