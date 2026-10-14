import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/features/system/data/models/feature_flag_model.dart';
import 'package:kauri/features/system/domain/repositories/system_repository.dart';
import 'package:kauri/features/system/presentation/bloc/system_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';

class MockSystemRepository extends Mock implements SystemRepository {}

class MockTelemetryService extends Mock implements TelemetryService {}

void main() {
  late SystemBloc systemBloc;
  late MockSystemRepository mockSystemRepository;

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Kauri',
      packageName: 'com.kauri.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    mockSystemRepository = MockSystemRepository();
    if (getIt.isRegistered<TelemetryService>()) {
      getIt.unregister<TelemetryService>();
    }
    getIt.registerSingleton<TelemetryService>(TelemetryService());

    systemBloc = SystemBloc(mockSystemRepository);
  });

  tearDown(() {
    systemBloc.close();
    if (getIt.isRegistered<TelemetryService>()) {
      getIt.unregister<TelemetryService>();
    }
  });

  group('SystemBloc Feature Flags', () {
    const testFlags = FeatureFlagModel(
      aiCoachChat: FeatureConfig(isEnabled: false),
      aiInsights: FeatureConfig(isEnabled: true, minAppVersion: '1.0.0'),
      featGoals: FeatureConfig(isEnabled: true, minAppVersion: '2.0.0'),
      featChallenges: FeatureConfig(isEnabled: true, minAppVersion: '1.0.0'),
    );

    blocTest<SystemBloc, SystemState>(
      'emits [loading, success] with correct feature flags when GetFeatureFlagsRequested is added',
      build: () {
        when(
          () => mockSystemRepository.getFeatureFlags(),
        ).thenAnswer((_) async => testFlags);
        return systemBloc;
      },
      act: (bloc) => bloc.add(const GetFeatureFlagsRequested()),
      expect: () => [
        const SystemState(status: SystemStatus.loading),
        const SystemState(
          status: SystemStatus.success,
          featureFlags: testFlags,
        ),
      ],
      verify: (_) {
        verify(() => mockSystemRepository.getFeatureFlags()).called(1);
      },
    );

    test('getFeatureStatus returns correct status based on version', () {
      // Mock VersionUtils or just check current behavior
      // Note: Assuming current version in pubspec.yaml or where it is read

      // Disabled feature
      final status1 = systemBloc.getFeatureStatus(testFlags.aiCoachChat);
      expect(status1, FeatureStatus.disabled);

      // Enabled feature (version 1.0.0 <= current)
      final status2 = systemBloc.getFeatureStatus(testFlags.aiInsights);
      expect(status2, FeatureStatus.enabled);

      // Update required (version 2.0.0 > 1.0.0 - assuming current is 1.0.0)
      final status3 = systemBloc.getFeatureStatus(testFlags.featGoals);
      expect(status3, FeatureStatus.updateRequired);
    });

    blocTest<SystemBloc, SystemState>(
      'emits [loading, failure] when fetching feature flags fails',
      build: () {
        when(
          () => mockSystemRepository.getFeatureFlags(),
        ).thenThrow(Exception('Failed to fetch flags'));
        return systemBloc;
      },
      act: (bloc) => bloc.add(const GetFeatureFlagsRequested()),
      expect: () => [
        const SystemState(status: SystemStatus.loading),
        isA<SystemState>().having(
          (s) => s.status,
          'status',
          SystemStatus.failure,
        ),
      ],
    );
  });
}
