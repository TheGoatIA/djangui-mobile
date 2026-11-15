import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kauri/core/services/log_service.dart';
import 'package:kauri/core/services/payment_init_error.dart';
import 'package:kauri/core/services/payment_service.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/subscription/data/datasources/payment_api_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements PaymentApiService {}

class _MockLog extends Mock implements LogService {}

/// Un paiement refusé par le serveur doit remonter SON message
/// (constat staging : mode simulation → « Initialisation paiement échouée »).
void main() {
  late _MockApi api;
  late PaymentService service;
  const refus =
      'Les paiements réels sont actuellement désactivés '
      '(Mode Portefeuille Virtuel / Simulation).';

  Response<Map<String, dynamic>> refused() => Response<Map<String, dynamic>>(
    http.Response('{"status":"error","message":"$refus"}', 400),
    null,
    error: '{"status":"error","message":"$refus"}',
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    api = _MockApi();
    service = PaymentService(api);
    if (getIt.isRegistered<LogService>()) getIt.unregister<LogService>();
    getIt.registerSingleton<LogService>(_MockLog());
  });

  tearDown(() => getIt.unregister<LogService>());

  test('NotchPay refusé : exception avec le message du serveur', () async {
    when(
      () => api.initializeNotchPay(any()),
    ).thenAnswer((_) async => refused());
    await expectLater(
      service.initializeNotchPay(1000),
      throwsA(
        isA<PaymentInitException>().having((e) => e.message, 'message', refus),
      ),
    );
  });

  test('Stripe refusé : exception avec le message du serveur', () async {
    when(
      () => api.createStripeCheckout(any()),
    ).thenAnswer((_) async => refused());
    await expectLater(
      service.createStripeCheckout(1000, 'XAF'),
      throwsA(isA<PaymentInitException>()),
    );
  });

  test('refus sans message lisible : null (comportement inchangé)', () async {
    when(() => api.initializeNotchPay(any())).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        http.Response('<html>502</html>', 502),
        null,
        error: '<html>502</html>',
      ),
    );
    expect(await service.initializeNotchPay(1000), isNull);
  });
}
