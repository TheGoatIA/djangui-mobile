import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/analytics/analytics_service.dart';
import 'package:kauri/core/error/failure.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/auth/data/models/auth_response.dart';
import 'package:kauri/features/auth/data/models/user_model.dart';
import 'package:kauri/features/auth/domain/repositories/auth_repository.dart';
import 'package:kauri/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kauri/features/auth/presentation/widgets/gpchat_link_tile.dart';
import 'package:kauri/features/upload/domain/repositories/upload_repository.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository {}

class _MockUpload extends Mock implements UploadRepository {}

class _MockLog extends Mock implements LogService {}

class _MockAnalytics extends Mock implements AnalyticsService {}

UserModel _user({String? gpchatId}) => UserModel.fromJson({
  '_id': 'u1',
  'email': 'awa@example.com',
  'firstName': 'Awa',
  'lastName': 'Ngono',
  if (gpchatId != null) 'gpchatId': gpchatId,
});

void _register<T extends Object>(T instance) {
  if (getIt.isRegistered<T>()) getIt.unregister<T>();
  getIt.registerSingleton<T>(instance);
}

void _unregister<T extends Object>() {
  if (getIt.isRegistered<T>()) getIt.unregister<T>();
}

void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    final analytics = _MockAnalytics();
    when(() => analytics.setUserId(any())).thenAnswer((_) async {});
    when(
      () => analytics.logEvent(any(), parameters: any(named: 'parameters')),
    ).thenAnswer((_) async {});
    _register<TelemetryService>(TelemetryService());
    _register<LogService>(_MockLog());
    _register<AnalyticsService>(analytics);
    _register<AuthRepository>(repo);
  });

  tearDown(() {
    _unregister<TelemetryService>();
    _unregister<LogService>();
    _unregister<AnalyticsService>();
    _unregister<AuthRepository>();
  });

  group('AuthBloc — connexion GPChat', () {
    final auth = AuthResponse(
      tokens: Tokens(accessToken: 'a', refreshToken: 'r'),
      user: _user(gpchatId: 'gp1'),
    );

    blocTest<AuthBloc, AuthState>(
      'succès → authentifié',
      build: () {
        when(
          () => repo.signInWithGpchat(countryCode: any(named: 'countryCode')),
        ).thenAnswer((_) async => Right(auth));
        when(() => repo.updateDeviceInfo()).thenAnswer((_) async {});
        when(() => repo.logConnection()).thenAnswer((_) async {});
        return AuthBloc(repo, _MockUpload());
      },
      act: (b) => b.add(const AuthGpchatSignInRequested(countryCode: 'CM')),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.authenticated)
            .having((s) => s.authResponse, 'authResponse', auth),
      ],
      verify: (_) {
        verify(() => repo.signInWithGpchat(countryCode: 'CM')).called(1);
        verify(() => repo.logConnection()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'échec → message d’erreur',
      build: () {
        when(
          () => repo.signInWithGpchat(countryCode: any(named: 'countryCode')),
        ).thenAnswer((_) async => Left(AuthFailure('annulée')));
        return AuthBloc(repo, _MockUpload());
      },
      act: (b) => b.add(const AuthGpchatSignInRequested()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'annulée'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'exception → erreur',
      build: () {
        when(
          () => repo.signInWithGpchat(countryCode: any(named: 'countryCode')),
        ).thenThrow(StateError('boom'));
        return AuthBloc(repo, _MockUpload());
      },
      act: (b) => b.add(const AuthGpchatSignInRequested()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.error),
      ],
    );
  });

  group('GpchatLinkTile', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: GpchatLinkTile()),
        ),
      );
      await tester.pumpAndSettle();
    }

    AppLocalizations l10n(WidgetTester tester) =>
        AppLocalizations.of(tester.element(find.byType(GpchatLinkTile)))!;

    testWidgets('non lié → Lier → lié', (tester) async {
      when(() => repo.getCurrentUser()).thenAnswer((_) async => Right(_user()));
      when(
        () => repo.linkGpchat(),
      ).thenAnswer((_) async => Right(_user(gpchatId: 'gp1')));
      await pump(tester);
      final t = l10n(tester);

      expect(find.text(t.gpchatNotLinkedDesc), findsOneWidget);
      await tester.tap(find.text(t.gpchatLink));
      await tester.pumpAndSettle();

      expect(find.text(t.gpchatLinkedDesc), findsOneWidget);
      expect(find.text(t.gpchatUnlink), findsOneWidget);
      expect(find.text(t.gpchatLinked), findsOneWidget);
    });

    testWidgets('échec de liaison → message, reste non lié', (tester) async {
      when(() => repo.getCurrentUser()).thenAnswer((_) async => Right(_user()));
      when(
        () => repo.linkGpchat(),
      ).thenAnswer((_) async => Left(AuthFailure('Connexion annulée')));
      await pump(tester);
      final t = l10n(tester);

      await tester.tap(find.text(t.gpchatLink));
      await tester.pumpAndSettle();

      expect(find.text('Connexion annulée'), findsOneWidget);
      expect(find.text(t.gpchatLink), findsOneWidget);
    });

    testWidgets('lié → Délier : annuler puis confirmer', (tester) async {
      when(
        () => repo.getCurrentUser(),
      ).thenAnswer((_) async => Right(_user(gpchatId: 'gp1')));
      when(() => repo.unlinkGpchat()).thenAnswer((_) async => Right(_user()));
      await pump(tester);
      final t = l10n(tester);

      await tester.tap(find.text(t.gpchatUnlink));
      await tester.pumpAndSettle();
      expect(find.text(t.gpchatUnlinkTitle), findsOneWidget);
      await tester.tap(find.text(t.cancel));
      await tester.pumpAndSettle();
      verifyNever(() => repo.unlinkGpchat());

      await tester.tap(find.text(t.gpchatUnlink));
      await tester.pumpAndSettle();
      await tester.tap(find.text(t.gpchatUnlink).last);
      await tester.pumpAndSettle();

      verify(() => repo.unlinkGpchat()).called(1);
      expect(find.text(t.gpchatNotLinkedDesc), findsOneWidget);
      expect(find.text(t.gpchatUnlinked), findsOneWidget);
    });

    testWidgets('déliaison refusée → message, reste lié', (tester) async {
      when(
        () => repo.getCurrentUser(),
      ).thenAnswer((_) async => Right(_user(gpchatId: 'gp1')));
      when(
        () => repo.unlinkGpchat(),
      ).thenAnswer((_) async => Left(AuthFailure('Seul moyen de connexion')));
      await pump(tester);
      final t = l10n(tester);

      await tester.tap(find.text(t.gpchatUnlink));
      await tester.pumpAndSettle();
      await tester.tap(find.text(t.gpchatUnlink).last);
      await tester.pumpAndSettle();

      expect(find.text('Seul moyen de connexion'), findsOneWidget);
      expect(find.text(t.gpchatLinkedDesc), findsOneWidget);
    });
  });
}
