import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_auth_2_platform_interface/flutter_web_auth_2_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:kauri/core/error/failure.dart';
import 'package:kauri/core/network/network_info.dart';
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/auth/data/datasources/auth_api_service.dart';
import 'package:kauri/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kauri/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kauri/features/auth/data/models/auth_response.dart';
import 'package:kauri/features/auth/data/models/user_model.dart';
import 'package:kauri/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements AuthApiService {}

class _MockLocal extends Mock implements AuthLocalDataSource {}

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockNetwork extends Mock implements NetworkInfo {}

class _MockLog extends Mock implements LogService {}

/// Onglet de connexion simulé : rend l'URL de retour choisie par le test.
class _FakeWebAuth extends FlutterWebAuth2Platform {
  _FakeWebAuth(this.respond);
  final Future<String> Function(String url) respond;
  final List<String> opened = [];

  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    required Map<String, dynamic> options,
  }) {
    opened.add(url);
    return respond(url);
  }

  @override
  Future<void> clearAllDanglingCalls() async {}
}

Map<String, dynamic> _userJson({String? gpchatId}) => {
  '_id': 'u1',
  'email': 'awa@example.com',
  'firstName': 'Awa',
  'lastName': 'Ngono',
  if (gpchatId != null) 'gpchatId': gpchatId,
};

Response<T> _ok<T>(T body) => Response(http.Response('{}', 200), body);

Response<T> _ko<T>() =>
    Response<T>(http.Response('{"message":"refusé"}', 400), null);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => registerFallbackValue(UserModel.fromJson(_userJson())));

  group('AuthRemoteDataSource — GPChat', () {
    late _MockApi api;
    late AuthRemoteDataSourceImpl ds;

    setUp(() {
      api = _MockApi();
      ds = AuthRemoteDataSourceImpl(api, _MockLocal());
    });

    test('gpchatExchange envoie code + secret et rend la réponse', () async {
      final auth = AuthResponse(
        tokens: Tokens(accessToken: 'a', refreshToken: 'r'),
        user: UserModel.fromJson(_userJson()),
      );
      when(() => api.gpchatExchange(any())).thenAnswer((_) async => _ok(auth));
      expect(await ds.gpchatExchange('c', 'v'), auth);
      expect(verify(() => api.gpchatExchange(captureAny())).captured.single, {
        'code': 'c',
        'verifier': 'v',
      });

      when(
        () => api.gpchatExchange(any()),
      ).thenAnswer((_) async => _ko<AuthResponse>());
      expect(() => ds.gpchatExchange('c', 'v'), throwsException);
    });

    test('gpchatLinkStart rend l’URL de la page GPChat', () async {
      when(() => api.gpchatLinkStart(any())).thenAnswer(
        (_) async => _ok<Map<String, dynamic>>({'url': 'https://gp/x'}),
      );
      expect(await ds.gpchatLinkStart('ch', 'android'), 'https://gp/x');

      when(
        () => api.gpchatLinkStart(any()),
      ).thenAnswer((_) async => _ko<Map<String, dynamic>>());
      expect(() => ds.gpchatLinkStart('ch', 'android'), throwsException);
    });

    test('gpchatLinkConfirm et gpchatUnlink rendent le profil', () async {
      when(() => api.gpchatLinkConfirm(any())).thenAnswer(
        (_) async =>
            _ok<Map<String, dynamic>>({'user': _userJson(gpchatId: 'gp1')}),
      );
      expect((await ds.gpchatLinkConfirm('c', 'v')).gpchatId, 'gp1');
      when(() => api.gpchatUnlink()).thenAnswer(
        (_) async => _ok<Map<String, dynamic>>({'user': _userJson()}),
      );
      expect((await ds.gpchatUnlink()).gpchatId, isNull);

      when(
        () => api.gpchatLinkConfirm(any()),
      ).thenAnswer((_) async => _ko<Map<String, dynamic>>());
      when(
        () => api.gpchatUnlink(),
      ).thenAnswer((_) async => _ko<Map<String, dynamic>>());
      expect(() => ds.gpchatLinkConfirm('c', 'v'), throwsException);
      expect(() => ds.gpchatUnlink(), throwsException);
    });
  });

  group('AuthRepositoryImpl — GPChat', () {
    late _MockRemote remote;
    late _MockLocal local;
    late _MockNetwork network;
    late AuthRepositoryImpl repo;
    final auth = AuthResponse(
      tokens: Tokens(accessToken: 'at', refreshToken: 'rt'),
      user: UserModel.fromJson(_userJson(gpchatId: 'gp1')),
    );

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      network = _MockNetwork();
      repo = AuthRepositoryImpl(remote, local, network);
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(
        () => local.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});
      when(() => local.saveUser(any())).thenAnswer((_) async {});
      when(() => local.saveLoginProvider(any())).thenAnswer((_) async {});
      if (getIt.isRegistered<LogService>()) getIt.unregister<LogService>();
      getIt.registerSingleton<LogService>(_MockLog());
    });

    tearDown(() {
      if (getIt.isRegistered<LogService>()) getIt.unregister<LogService>();
    });

    void webAuth(Future<String> Function(String url) respond) =>
        FlutterWebAuth2Platform.instance = _FakeWebAuth(respond);

    test(
      'connexion : le secret envoyé correspond au challenge de la page',
      () async {
        late Uri opened;
        webAuth((url) async {
          opened = Uri.parse(url);
          return 'kauri-auth://gpchat?code=abc';
        });
        when(
          () => remote.gpchatExchange(any(), any()),
        ).thenAnswer((_) async => auth);

        final result = await repo.signInWithGpchat(countryCode: 'CM');

        expect(result.isRight(), isTrue);
        expect(opened.path, endsWith('/auth/gpchat/start'));
        expect(opened.queryParameters['country'], 'CM');
        final verifier =
            verify(
                  () => remote.gpchatExchange('abc', captureAny()),
                ).captured.single
                as String;
        expect(
          sha256.convert(utf8.encode(verifier)).toString(),
          opened.queryParameters['challenge'],
        );
        verify(() => local.saveLoginProvider('gpchat')).called(1);
        verify(
          () => local.saveTokens(accessToken: 'at', refreshToken: 'rt'),
        ).called(1);
      },
    );

    test('connexion : annulation, erreur, onglet fermé, panne', () async {
      webAuth((_) async => 'kauri-auth://gpchat?error=cancelled');
      expect((await repo.signInWithGpchat()).isLeft(), isTrue);
      webAuth((_) async => 'kauri-auth://gpchat?error=failed');
      expect((await repo.signInWithGpchat()).isLeft(), isTrue);
      webAuth((_) => Future.error(PlatformException(code: 'CANCELED')));
      expect((await repo.signInWithGpchat()).isLeft(), isTrue);
      webAuth((_) => Future.error(PlatformException(code: 'OTHER')));
      expect((await repo.signInWithGpchat()).isLeft(), isTrue);
      webAuth((_) async => 'kauri-auth://gpchat?code=abc');
      when(
        () => remote.gpchatExchange(any(), any()),
      ).thenThrow(Exception('401'));
      expect((await repo.signInWithGpchat()).isLeft(), isTrue);
      verifyNever(() => local.saveLoginProvider(any()));
    });

    test('hors ligne : rien n’est ouvert', () async {
      final fake = _FakeWebAuth((_) async => '');
      FlutterWebAuth2Platform.instance = fake;
      when(() => network.isConnected).thenAnswer((_) async => false);
      final r1 = await repo.signInWithGpchat();
      final r2 = await repo.linkGpchat();
      final r3 = await repo.unlinkGpchat();
      for (final r in [r1, r2, r3]) {
        expect(r.fold((f) => f, (_) => null), isA<NetworkFailure>());
      }
      expect(fake.opened, isEmpty);
    });

    test('liaison : confirme avec le secret du challenge envoyé', () async {
      when(
        () => remote.gpchatLinkStart(any(), any()),
      ).thenAnswer((_) async => 'https://gp/authorize?state=s');
      webAuth((_) async => 'kauri-auth://gpchat?link_code=lc');
      when(
        () => remote.gpchatLinkConfirm(any(), any()),
      ).thenAnswer((_) async => UserModel.fromJson(_userJson(gpchatId: 'gp1')));

      final result = await repo.linkGpchat();

      expect(result.fold((_) => null, (u) => u.gpchatId), 'gp1');
      final challenge =
          verify(
                () => remote.gpchatLinkStart(captureAny(), any()),
              ).captured.single
              as String;
      final verifier =
          verify(
                () => remote.gpchatLinkConfirm('lc', captureAny()),
              ).captured.single
              as String;
      expect(sha256.convert(utf8.encode(verifier)).toString(), challenge);
      verify(() => local.saveUser(any())).called(1);
    });

    test('liaison : annulation, échec, onglet fermé, panne', () async {
      when(
        () => remote.gpchatLinkStart(any(), any()),
      ).thenAnswer((_) async => 'https://gp/authorize');
      webAuth((_) async => 'kauri-auth://gpchat?error=cancelled');
      expect((await repo.linkGpchat()).isLeft(), isTrue);
      webAuth((_) async => 'kauri-auth://gpchat?error=failed');
      expect((await repo.linkGpchat()).isLeft(), isTrue);
      webAuth((_) => Future.error(PlatformException(code: 'CANCELED')));
      expect((await repo.linkGpchat()).isLeft(), isTrue);
      webAuth((_) => Future.error(PlatformException(code: 'OTHER')));
      expect((await repo.linkGpchat()).isLeft(), isTrue);
      when(
        () => remote.gpchatLinkStart(any(), any()),
      ).thenThrow(Exception('403'));
      expect((await repo.linkGpchat()).isLeft(), isTrue);
      verifyNever(() => local.saveUser(any()));
    });

    test('déliaison : met à jour le profil local, ou échoue', () async {
      when(
        () => remote.gpchatUnlink(),
      ).thenAnswer((_) async => UserModel.fromJson(_userJson()));
      final ok = await repo.unlinkGpchat();
      expect(ok.fold((_) => 'ko', (u) => u.gpchatId), isNull);
      verify(() => local.saveUser(any())).called(1);

      when(() => remote.gpchatUnlink()).thenThrow(Exception('400'));
      final ko = await repo.unlinkGpchat();
      expect(ko.fold((f) => f, (_) => null), isA<Failure>());
    });
  });
}
