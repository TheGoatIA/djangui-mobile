// Parcours UI réels de l'application complète (main(), DI, router, blocs) sur
// émulateur, contre l'API E2E locale seedée.
//
//   (API)    E2E_PUBLIC_HOST=10.0.2.2 node scripts/e2e-server.js
//   (mobile) flutter test integration_test/app_flows_test.dart -d emulator-5554 \
//              --dart-define=API_BASE_URL=http://10.0.2.2:5055/api/v1
//
// Ce test a besoin d'un seed frais : "Tontine E2E" doit être ACTIVE (le test de
// contrat la clôture par vote).
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kauri/core/config/env_config.dart';
import 'package:kauri/main.dart' as app;
import 'package:kauri/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _email = 'client@kauri-e2e.com';
const _password = 'E2e-Passw0rd!';

/// Avance l'horloge par petits pas (l'app a des animations/polling infinis :
/// pumpAndSettle ne rendrait jamais la main).
Future<void> settle(WidgetTester tester, {int seconds = 3}) async {
  for (var i = 0; i < seconds * 4; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

/// Attend qu'un finder apparaisse (réseau réel → délais variables).
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  int timeoutSeconds = 20,
}) async {
  for (var i = 0; i < timeoutSeconds * 4; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 250));
  }
  fail('Introuvable après ${timeoutSeconds}s : $finder');
}

/// Ferme un éventuel tutoriel (overlay « Passer »).
Future<void> dismissTutorial(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    final skip = find.text('Passer');
    if (skip.evaluate().isEmpty) return;
    await tester.tap(skip.first, warnIfMissed: false);
    await settle(tester, seconds: 1);
  }
}

/// Aucun écran rouge / gris d'erreur Flutter, aucune exception non gérée.
void expectHealthyScreen(WidgetTester tester, String where) {
  final ex = tester.takeException();
  expect(ex, isNull, reason: '$where : exception $ex');
  expect(
    find.byType(ErrorWidget),
    findsNothing,
    reason: '$where : ErrorWidget affiché',
  );
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets(
    'connexion par l\'écran → visite de tous les écrans → vote de clôture',
    (tester) async {
      expect(
        EnvConfig.apiBaseUrl,
        contains(':5055'),
        reason: 'API E2E locale uniquement',
      );

      // Onboarding et tutoriels déjà vus : on teste les fonctionnalités.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.setBool('hasSeenOnboarding', true);
      for (final k in [
        'dashboard',
        'transactions',
        'budgets',
        'goals',
        'challenges',
        'coach',
        'insights',
        'profile',
        'security',
        'subscription',
        'subscriptions',
        'tontine_details',
        'wallet_recharge',
        'investments',
        'reseller_hub',
        'view',
        'view_list',
      ]) {
        await prefs.setBool('tutorial_seen_$k', true);
      }

      app.main();
      await settle(tester, seconds: 2);
      // Pas de télémétrie Google depuis les tests.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

      // ---------- Connexion (session éventuelle d'un run précédent → déconnexion via l'écran login)
      await waitFor(tester, find.byType(TextFormField), timeoutSeconds: 40);
      expectHealthyScreen(tester, 'login');

      // Validation du formulaire côté client
      await tester.tap(find.text('Se connecter').last);
      await settle(tester, seconds: 1);
      expect(find.textContaining('email', findRichText: true), findsWidgets);

      // Mauvais mot de passe → message, reste sur le login
      await tester.enterText(find.byType(TextFormField).at(0), _email);
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Mauvais-Passw0rd!',
      );
      await tester.tap(find.text('Se connecter').last);
      await settle(tester, seconds: 4);
      expect(
        find.byType(TextFormField),
        findsWidgets,
        reason: 'doit rester sur le login',
      );
      expectHealthyScreen(tester, 'login (mauvais mot de passe)');

      // Bon mot de passe → tableau de bord
      await tester.enterText(find.byType(TextFormField).at(1), _password);
      await tester.tap(find.text('Se connecter').last);
      await waitFor(tester, find.textContaining('Awa'), timeoutSeconds: 30);
      await settle(tester, seconds: 3);
      await dismissTutorial(tester);
      expectHealthyScreen(tester, 'dashboard');

      // ---------- Chaque écran principal s'affiche sans erreur avec de vraies données
      const routes = <String>[
        '/wallet',
        '/transactions',
        '/transactions/add',
        '/budgets',
        '/goals',
        '/challenges',
        '/insights',
        '/notifications',
        '/profile',
        '/security',
        '/sessions',
        '/change-password',
        '/subscription',
        '/user-subscriptions',
        '/support/tickets',
        '/support/tickets/create',
        '/tontines',
        '/tontines/create',
        '/tontines/join',
        '/tontines/guide',
        '/coach',
        '/about',
        '/real-money-info',
        '/investments',
        '/dashboard',
      ];
      for (final r in routes) {
        appRouter.go(r);
        await settle(tester, seconds: 4);
        await dismissTutorial(tester);
        expectHealthyScreen(tester, r);
        debugPrint('✅ écran $r');
      }

      // ---------- Tontine active : carte de vote, proposition, vote
      appRouter.go('/tontines');
      await waitFor(tester, find.text('Tontine E2E'));
      await tester.tap(find.text('Tontine E2E').first);
      await settle(tester, seconds: 4);
      await dismissTutorial(tester);
      expectHealthyScreen(tester, 'détail tontine');

      final card = find.byKey(const Key('tontineClosureVoteCard'));
      await tester.scrollUntilVisible(
        card,
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await waitFor(tester, find.byKey(const Key('proposeClosureButton')));
      // Une tontine active n'a plus de bouton de suppression pour le créateur.
      expect(find.byIcon(Icons.delete_outline), findsNothing);

      await tester.tap(find.byKey(const Key('proposeClosureButton')));
      await settle(tester, seconds: 1);
      await tester.tap(find.byKey(const Key('closureVoteConfirm')));
      await waitFor(tester, find.byKey(const Key('voteYesClose')));
      expect(find.text('0 vote(s) · 2 voix nécessaires'), findsOneWidget);

      await tester.tap(find.byKey(const Key('voteYesClose')));
      await settle(tester, seconds: 1);
      await tester.tap(find.byKey(const Key('closureVoteConfirm')));
      await waitFor(tester, find.textContaining('Vous avez voté'));
      expect(find.text('1 vote(s) · 2 voix nécessaires'), findsOneWidget);
      expect(find.byKey(const Key('voteYesClose')), findsNothing);
      expectHealthyScreen(tester, 'après vote');
    },
  );
}
