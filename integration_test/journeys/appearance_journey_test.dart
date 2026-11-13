// PARCOURS APPARENCE — l'app entière en MODE SOMBRE et en ANGLAIS : chaque écran
// et les principaux popups sont capturés (PNG envoyés à l'hôte, voir
// scratchpad/shot-server.js sur :5099) pour une revue visuelle : zones restées
// claires, texte illisible, textes non traduits.
//
//   SHOTS_TAG=dark_en → nom des captures  (défaut : dark_en)
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kauri/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

import '../support/robot.dart';

const _tag = String.fromEnvironment('SHOTS_TAG', defaultValue: 'dark_en');
const _themeIndex = int.fromEnvironment(
  'SHOTS_THEME',
  defaultValue: 1,
); // 0 clair, 1 sombre
const _lang = String.fromEnvironment('SHOTS_LANG', defaultValue: 'en');

late IntegrationTestWidgetsFlutterBinding _binding;
bool _surfaceConverted = false;
int _n = 0;

Future<void> shot(WidgetTester tester, String name) async {
  if (!_surfaceConverted) {
    await _binding.convertFlutterSurfaceToImage();
    _surfaceConverted = true;
  }
  await tester.pump(const Duration(milliseconds: 300));
  final bytes = await _binding.takeScreenshot('${_tag}_$name');
  _n++;
  final file = '${_tag}_${_n.toString().padLeft(2, '0')}_$name';
  try {
    final client = HttpClient();
    final req = await client.post('10.0.2.2', 5099, '/$file');
    req.add(bytes);
    await (await req.close()).drain<void>();
    client.close();
  } catch (e) {
    debugPrint('capture non envoyée ($file) : $e');
  }
}

void main() {
  _binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  _binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('captures de tous les écrans ($_tag)', (tester) async {
    await bootstrapOnce();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', _themeIndex);
    await prefs.setString('language_code', _lang);
    final r = Robot(tester);
    await tester.pumpWidget(const app.MyApp());
    await r.settle(3);
    await shot(tester, 'login');

    // Connexion (libellés selon la langue).
    final emailLabel = _lang == 'en' ? 'Email' : 'E-mail';
    final loginLabel = _lang == 'en' ? 'Login' : 'Se connecter';
    await r.waitFor(find.byType(TextFormField));
    final emailField = r.field(emailLabel).evaluate().isNotEmpty
        ? r.field(emailLabel)
        : find.byType(TextFormField).at(0);
    await tester.enterText(emailField.first, 'client@kauri-e2e.com');
    await tester.enterText(find.byType(TextFormField).at(1), e2ePassword);
    await r.hideKeyboard();
    final loginButton = find.text(loginLabel).evaluate().isNotEmpty
        ? find.text(loginLabel).last
        : find.byType(ElevatedButton).first;
    await tester.tap(loginButton, warnIfMissed: false);
    await r.waitFor(
      find.byType(NavigationBar),
      timeout: const Duration(seconds: 25),
    );
    await r.settle(3);
    await r.dismissTutorial();
    await shot(tester, 'dashboard');

    const routes = <String, String>{
      '/wallet': 'wallet',
      '/transactions': 'transactions',
      '/transactions/add': 'transaction_add',
      '/budgets': 'budgets',
      '/goals': 'goals',
      '/goals/add': 'goal_add',
      '/challenges': 'challenges',
      '/insights': 'insights',
      '/notifications': 'notifications',
      '/profile': 'profile',
      '/security': 'security',
      '/sessions': 'sessions',
      '/change-password': 'change_password',
      '/subscription': 'subscription',
      '/user-subscriptions': 'user_subscriptions',
      '/support/tickets': 'support',
      '/support/tickets/create': 'support_create',
      '/tontines': 'tontines',
      '/tontines/create': 'tontine_create',
      '/tontines/join': 'tontine_join',
      '/tontines/guide': 'tontine_guide',
      '/coach': 'coach',
      '/about': 'about',
      '/real-money-info': 'real_money_info',
      '/reseller': 'reseller',
    };
    for (final e in routes.entries) {
      await r.go(e.key);
      await r.settle(2.5);
      await r.dismissTutorial();
      r.healthy(e.key);
      await shot(tester, e.value);
      // Écrans longs : 2e capture plus bas.
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        try {
          await tester.drag(
            scrollable.first,
            const Offset(0, -700),
            warnIfMissed: false,
          );
          await r.settle(1);
          await shot(tester, '${e.value}_bas');
        } catch (_) {}
      }
    }

    // Détails : tontine (avec la carte de vote), objectif seedé, popups.
    await r.go('/tontines');
    await r.settle(2);
    if (find.text('Tontine E2E').evaluate().isNotEmpty) {
      await tester.tap(find.text('Tontine E2E').first);
      await r.settle(3);
      await shot(tester, 'tontine_detail');
      await tester.drag(
        find.byType(Scrollable).last,
        const Offset(0, -600),
        warnIfMissed: false,
      );
      await r.settle(1);
      await shot(tester, 'tontine_detail_vote');
    }
    await r.go('/goals');
    await r.settle(2);
    if (find.text('Objectif E2E').evaluate().isNotEmpty) {
      await tester.tap(find.text('Objectif E2E').first);
      await r.settle(3);
      await shot(tester, 'goal_detail');
    }
    await r.go('/wallet');
    await r.settle(2);
    final recharge = find.text(_lang == 'en' ? 'Recharge' : 'Recharger');
    if (recharge.evaluate().isNotEmpty) {
      await tester.tap(recharge.first);
      await r.settle(1.5);
      await shot(tester, 'wallet_popup');
      if (r.dialog().evaluate().isNotEmpty) {
        await tester.tapAt(const Offset(10, 10));
        await r.settle(1);
      }
    }
    await r.go('/profile');
    await r.settle(2);
    await tester.tap(
      find.byIcon(Icons.edit_outlined).first,
      warnIfMissed: false,
    );
    await r.settle(1.5);
    await shot(tester, 'profile_edit_popup');
    debugPrint('CAPTURES: $_n');
  });
}
