import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/system_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/utils/version_utils.dart';
import '../../data/models/feature_flag_model.dart';
import 'package:kauri/core/error/error_mapper.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:opentelemetry/api.dart';

import 'system_event.dart';
import 'system_state.dart';

export 'system_event.dart';
export 'system_state.dart';

@injectable
class SystemBloc extends Bloc<SystemEvent, SystemState> {
  final SystemRepository _repository;
  TelemetryService get _telemetry => getIt<TelemetryService>();

  SystemBloc(this._repository) : super(const SystemState()) {
    on<InitializeSystem>(_onInitializeSystem);
    on<GetPublicSettingsRequested>(_onGetPublicSettingsRequested);
    on<GetCountriesRequested>(_onGetCountriesRequested);
    on<GetFeatureFlagsRequested>(_onGetFeatureFlagsRequested);

    add(const InitializeSystem());
  }

  Future<void> _onInitializeSystem(
    InitializeSystem event,
    Emitter<SystemState> emit,
  ) async {
    final span = _telemetry.tracer.startSpan(
      'System: Initialize',
      kind: SpanKind.internal,
    );

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      span.setAttribute(
        Attribute.fromString('app.version', packageInfo.version),
      );
      emit(state.copyWith(appVersion: packageInfo.version));
    } catch (e, s) {
      span.recordException(e, stackTrace: s);
      // Don't rethrow for system init to avoid crashing app start, just log
    } finally {
      span.end();
    }
  }

  FeatureStatus getFeatureStatus(FeatureConfig config) {
    if (!config.isEnabled) return FeatureStatus.disabled;
    if (!VersionUtils.isAtLeast(state.appVersion, config.minAppVersion)) {
      return FeatureStatus.updateRequired;
    }
    return FeatureStatus.enabled;
  }

  Future<void> _onGetPublicSettingsRequested(
    GetPublicSettingsRequested event,
    Emitter<SystemState> emit,
  ) async {
    emit(state.copyWith(status: SystemStatus.loading));
    try {
      final settings = await _repository.getPublicSettings();
      emit(state.copyWith(status: SystemStatus.success, settings: settings));
    } catch (e) {
      emit(
        state.copyWith(
          status: SystemStatus.failure,
          errorMessage: ErrorMapper.safeMessage(e),
        ),
      );
    }
  }

  Future<void> _onGetCountriesRequested(
    GetCountriesRequested event,
    Emitter<SystemState> emit,
  ) async {
    emit(state.copyWith(status: SystemStatus.loading));
    try {
      final countries = await _repository.getCountries();
      emit(state.copyWith(status: SystemStatus.success, countries: countries));
    } catch (e) {
      emit(
        state.copyWith(
          status: SystemStatus.failure,
          errorMessage: ErrorMapper.safeMessage(e),
        ),
      );
    }
  }

  Future<void> _onGetFeatureFlagsRequested(
    GetFeatureFlagsRequested event,
    Emitter<SystemState> emit,
  ) async {
    emit(state.copyWith(status: SystemStatus.loading));
    try {
      final flags = await _repository.getFeatureFlags();
      emit(state.copyWith(status: SystemStatus.success, featureFlags: flags));
    } catch (e) {
      emit(
        state.copyWith(
          status: SystemStatus.failure,
          errorMessage: ErrorMapper.safeMessage(e),
        ),
      );
    }
  }
}
