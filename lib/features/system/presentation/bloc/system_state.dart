import 'package:equatable/equatable.dart';
import '../../data/models/public_settings_model.dart';
import '../../data/models/country_model.dart';

enum SystemStatus { initial, loading, success, failure }

class SystemState extends Equatable {
  final PublicSettingsModel? settings;
  final List<CountryModel> countries;
  final SystemStatus status;
  final String? errorMessage;

  const SystemState({
    this.settings,
    this.countries = const [],
    this.status = SystemStatus.initial,
    this.errorMessage,
  });

  SystemState copyWith({
    PublicSettingsModel? settings,
    List<CountryModel>? countries,
    SystemStatus? status,
    String? errorMessage,
  }) {
    return SystemState(
      settings: settings ?? this.settings,
      countries: countries ?? this.countries,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [settings, countries, status, errorMessage];
}
