import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kauri/features/auth/data/datasources/auth_api_service.dart';
import 'package:kauri/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kauri/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements AuthApiService {}

class _MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  group('Delete account — wire format (real Chopper request)', () {
    test(
      'sends DELETE /auth/delete-me with the password in a JSON body',
      () async {
        late http.Request captured;
        final mock = MockClient((req) async {
          captured = req;
          return http.Response(
            '{"success":true}',
            200,
            headers: {'content-type': 'application/json'},
          );
        });
        final client = ChopperClient(
          baseUrl: Uri.parse('https://api.test/api/v1'),
          client: mock,
          services: [AuthApiService.create()],
          converter: const JsonConverter(),
        );

        try {
          await client.getService<AuthApiService>().deleteAccount({
            'password': 'S3cret!pass',
          });
        } catch (_) {
          // response conversion is irrelevant here — only the request is asserted
        }

        expect(captured.method, 'DELETE');
        expect(captured.url.path, '/api/v1/auth/delete-me');
        expect(jsonDecode(captured.body), {'password': 'S3cret!pass'});
      },
    );
  });

  group('AuthRemoteDataSource', () {
    late _MockApi api;
    late _MockLocal local;
    late AuthRemoteDataSourceImpl ds;

    setUp(() {
      api = _MockApi();
      local = _MockLocal();
      ds = AuthRemoteDataSourceImpl(api, local);
    });

    test('changePassword forwards the current refresh token', () async {
      when(() => local.getRefreshToken()).thenAnswer((_) async => 'rt-123');
      when(
        () => api.changePassword(any()),
      ).thenAnswer((_) async => Response(http.Response('{}', 200), null));

      await ds.changePassword('old', 'new');

      final body =
          verify(() => api.changePassword(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(body, {
        'currentPassword': 'old',
        'newPassword': 'new',
        'refreshToken': 'rt-123',
      });
    });

    test('changePassword omits refreshToken when none is stored', () async {
      when(() => local.getRefreshToken()).thenAnswer((_) async => null);
      when(
        () => api.changePassword(any()),
      ).thenAnswer((_) async => Response(http.Response('{}', 200), null));

      await ds.changePassword('old', 'new');

      final body =
          verify(() => api.changePassword(captureAny())).captured.single
              as Map<String, dynamic>;
      expect(body.containsKey('refreshToken'), isFalse);
    });

    test(
      'deleteAccount sends the password, or an empty body without one',
      () async {
        when(
          () => api.deleteAccount(any()),
        ).thenAnswer((_) async => Response(http.Response('{}', 200), null));

        await ds.deleteAccount(password: 'pw');
        await ds.deleteAccount();

        final bodies = verify(() => api.deleteAccount(captureAny())).captured;
        expect(bodies[0], {'password': 'pw'});
        expect(bodies[1], <String, dynamic>{});
      },
    );
  });
}
