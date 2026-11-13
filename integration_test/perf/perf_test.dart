// Mesure de fluidité en mode PROFILE (voir test_driver/perf_driver.dart).
// Chaque scénario est enregistré dans une timeline distincte : démarrage +
// tableau de bord, défilement des listes, ouverture des écrans lourds,
// passage clair → sombre.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../support/robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('performance des parcours principaux', (tester) async {
    await bootstrapOnce();
    final r = Robot(tester);
    await r.launch();

    // Connexion en mode d'images par défaut (la saisie de texte du test n'est
    // pas fiable en fullyLive), puis mesures en fullyLive : toutes les images
    // sont produites comme sur un vrai téléphone.
    await r.settle(
      4,
    ); // laisse l'écran de lancement rediriger vers la connexion
    await r.loginUi('client@kauri-e2e.com');
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    await binding.traceAction(() async {
      await r.go('/wallet');
      await r.settle(2);
      await r.go('/dashboard');
      await r.settle(3);
    }, reportKey: 'tableau_de_bord_et_portefeuille');

    Future<void> scrollScreen(String route) async {
      await r.go(route);
      await r.settle(2);
      final s = find.byType(Scrollable);
      if (s.evaluate().isEmpty) return;
      for (var i = 0; i < 3; i++) {
        await tester.fling(
          s.first,
          const Offset(0, -600),
          2500,
          warnIfMissed: false,
        );
        await r.settle(1);
      }
      for (var i = 0; i < 3; i++) {
        await tester.fling(
          s.first,
          const Offset(0, 600),
          2500,
          warnIfMissed: false,
        );
        await r.settle(1);
      }
    }

    await binding.traceAction(() async {
      for (final route in [
        '/dashboard',
        '/transactions',
        '/wallet',
        '/insights',
        '/profile',
      ]) {
        await scrollScreen(route);
      }
    }, reportKey: 'defilement_des_ecrans');

    await binding.traceAction(() async {
      for (final route in [
        '/budgets',
        '/goals',
        '/challenges',
        '/tontines',
        '/subscription',
        '/support/tickets',
      ]) {
        await r.go(route);
        await r.settle(2.5);
      }
      await r.go('/tontines');
      await r.settle(2);
      if (find.text('Tontine E2E').evaluate().isNotEmpty) {
        await tester.tap(find.text('Tontine E2E').first);
        await r.settle(3);
      }
    }, reportKey: 'navigation_ecrans_lourds');
  });
}
