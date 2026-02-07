import 'package:equatable/equatable.dart';
import '../../data/models/public_settings_model.dart';
import '../../data/models/country_model.dart';
import '../../data/models/feature_flag_model.dart';

enum SystemStatus { initial, loading, success, failure }

enum FeatureStatus { enabled, disabled, updateRequired }

class SystemState extends Equatable {
  final PublicSettingsModel? settings;
  final List<CountryModel> countries;
  final FeatureFlagModel featureFlags;
  final String appVersion;
  final SystemStatus status;
  final String? errorMessage;

  const SystemState({
    this.settings,
    this.countries = const [],
    this.featureFlags = const FeatureFlagModel(),
    this.appVersion = '1.0.0',
    this.status = SystemStatus.initial,
    this.errorMessage,
  });

  SystemState copyWith({
    PublicSettingsModel? settings,
    List<CountryModel>? countries,
    FeatureFlagModel? featureFlags,
    String? appVersion,
    SystemStatus? status,
    String? errorMessage,
  }) {
    return SystemState(
      settings: settings ?? this.settings,
      countries: countries ?? this.countries,
      featureFlags: featureFlags ?? this.featureFlags,
      appVersion: appVersion ?? this.appVersion,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    settings,
    countries,
    featureFlags,
    appVersion,
    status,
    errorMessage,
  ];
}
