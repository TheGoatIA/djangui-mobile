import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/routes/deep_link_parser.dart';

void main() {
  final token = 'a1b2c3d4' * 8; // 64 lowercase hex chars

  test(
    'well-formed reset link maps to the reset-password screen with its token',
    () {
      final route = resetPasswordRouteFor(
        Uri.parse('https://api.kauri-app.com/reset-password/$token'),
      );
      expect(route, '/reset-password?token=$token');
    },
  );

  test('also works for the bare path delivered by the engine', () {
    expect(
      resetPasswordRouteFor(Uri.parse('/reset-password/$token')),
      '/reset-password?token=$token',
    );
  });

  test('malformed tokens are rejected (no injection into the router)', () {
    for (final bad in [
      'short',
      'A1B2C3D4' * 8, // uppercase
      '${token}00', // too long
      '${token.substring(0, 63)}g', // non-hex
      '$token/../../login',
      '$token%0d%0a',
    ]) {
      expect(
        resetPasswordRouteFor(
          Uri.parse('https://api.kauri-app.com/reset-password/$bad'),
        ),
        isNull,
        reason: bad,
      );
    }
  });

  test('unrelated paths are ignored', () {
    expect(
      resetPasswordRouteFor(Uri.parse('https://api.kauri-app.com/login')),
      isNull,
    );
    expect(
      resetPasswordRouteFor(Uri.parse('kauri://reset-password?token=$token')),
      isNull,
    );
  });
}
