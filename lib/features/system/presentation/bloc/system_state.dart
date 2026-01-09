import 'package:equatable/equatable.dart';
import '../../data/models/public_settings_model.dart';

enum SystemStatus { initial, loading, success, failure }

class SystemState extends Equatable {
  final PublicSettingsModel? settings;
  final SystemStatus status;
  final String? errorMessage;

  const SystemState({
    this.settings,
    this.status = SystemStatus.initial,
    this.errorMessage,
  });

  SystemState copyWith({
    PublicSettingsModel? settings,
    SystemStatus? status,
    String? errorMessage,
  }) {
    return SystemState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [settings, status, errorMessage];
}
