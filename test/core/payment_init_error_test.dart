import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/services/payment_init_error.dart';

/// Le message du serveur doit arriver à l'écran quand un paiement est refusé
/// (constat staging : « Initialisation paiement échouée » au lieu de
/// « Les paiements réels sont actuellement désactivés »).
void main() {
  const refus =
      'Les paiements réels sont actuellement désactivés '
      '(Mode Portefeuille Virtuel / Simulation).';

  test('réponse JSON en texte (cas Chopper) : message extrait', () {
    expect(serverErrorMessage('{"status":"error","message":"$refus"}'), refus);
  });

  test('réponse déjà décodée (Map) : message extrait', () {
    expect(serverErrorMessage(<String, dynamic>{'message': refus}), refus);
  });

  test('réponse sans message, vide, non JSON ou nulle : null', () {
    expect(serverErrorMessage('{"status":"error"}'), isNull);
    expect(serverErrorMessage(<String, dynamic>{'message': '  '}), isNull);
    expect(serverErrorMessage('<html>Erreur 502</html>'), isNull);
    expect(serverErrorMessage(null), isNull);
  });

  test("l'exception transporte le message tel quel", () {
    const e = PaymentInitException(refus);
    expect(e.message, refus);
    expect(e.toString(), refus);
  });
}
