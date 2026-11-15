// PARCOURS ARGENT RÉEL (API lancée avec E2E_REAL_MONEY=1) — recharge Mobile
// Money de bout en bout et retrait, comme un vrai utilisateur :
//  * recharge : plafond 50 000 refusé, puis 5 000 → la page de paiement
//    NotchPay (sandbox) s'ouvre ; on simule le paiement côté NotchPay en
//    envoyant le WEBHOOK SIGNÉ que NotchPay enverrait, puis le retour dans
//    l'app → le solde est crédité ;
//  * retrait : minimum / maximum refusés, frais affichés, confirmation, solde débité.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/payments/presentation/bloc/payment_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/payment_state.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../support/robot.dart';

/// Navigateur simulé : on garde l'URL de paiement au lieu de quitter l'app.
class _FakeBrowser extends UrlLauncherPlatform {
  final List<String> opened = [];
  @override
  LinkDelegate? get linkDelegate => null;
  @override
  Future<bool> canLaunch(String url) async => true;
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    opened.add(url);
    return true;
  }
}

final _money = NumberFormat.decimalPattern('fr');
const _webhookSecret =
    'e2e_notchpay_webhook_secret'; // cf. scripts/e2e-server.js (API)

/// Ce que NotchPay enverrait une fois le paiement Mobile Money validé.
Future<int> sendSignedNotchPayWebhook(String ourReference, int amount) async {
  final body = jsonEncode({
    'event': 'payment.complete',
    'data': {
      'reference': 'trx.e2e_${DateTime.now().millisecondsSinceEpoch}',
      'merchant_reference': ourReference,
      'amount': amount,
      'currency': 'XAF',
      'status': 'complete',
    },
  });
  final signature = Hmac(
    sha256,
    utf8.encode(_webhookSecret),
  ).convert(utf8.encode(body)).toString();
  final client = HttpClient();
  final req = await client.post('10.0.2.2', 5055, '/api/v1/webhooks/notchpay');
  req.headers.contentType = ContentType.json;
  req.headers.set('x-notchpay-signature', signature);
  req.add(utf8.encode(body));
  final res = await req.close();
  await res.drain<void>();
  client.close();
  return res.statusCode;
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  final browser = _FakeBrowser();
  setUpAll(() async {
    await bootstrapOnce();
    UrlLauncherPlatform.instance = browser;
  });
  tearDownAll(() => printPerfReport('argent réel'));

  testWidgets(
    'recharge Mobile Money : plafond, paiement NotchPay, webhook, solde crédité',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.loginUi('mobile@kauri-e2e.com');
      await r.go('/wallet', until: find.text('Solde disponible'));
      await r.waitFor(
        find.textContaining(_money.format(100000)),
        why: 'solde initial 100 000',
      );
      expect(
        find.textContaining('Mode portefeuille virtuel'),
        findsNothing,
        reason: 'argent réel activé',
      );

      await r.tapText('Recharger');
      await r.expectDialog('Recharger');
      await r.fill('Montant', '60000');
      await r.dialogTap('Mobile Money (Local)');
      await r.expectToast('limité à 50 000 FCFA');
      await r.clearToasts();

      await r.fill('Montant', '5000');
      expect(
        tester
            .widget<TextField>(r.field('Numéro de téléphone').first)
            .controller
            ?.text,
        isNotEmpty,
        reason: 'numéro pré-rempli depuis le profil',
      );
      await r.measure(
        'initier la recharge NotchPay (API + NotchPay sandbox)',
        () => r.dialogTap('Mobile Money (Local)'),
        find.byWidgetPredicate((_) => browser.opened.isNotEmpty),
        timeout: const Duration(seconds: 25),
      );
      debugPrint('Page de paiement ouverte : ${browser.opened.last}');
      expect(
        browser.opened.last,
        contains('notchpay'),
        reason: 'redirection vers NotchPay',
      );

      final state = getIt<PaymentBloc>().state;
      expect(state, isA<PaymentSuccess>());
      final reference = (state as PaymentSuccess).response.reference;
      expect(reference, isNotEmpty);

      // L'utilisateur paie sur NotchPay → NotchPay prévient Kauri (webhook signé).
      expect(await sendSignedNotchPayWebhook(reference, 5000), 200);
      // Un webhook rejoué ne crédite pas deux fois.
      expect(await sendSignedNotchPayWebhook(reference, 5000), 200);

      // Retour dans l'app (le navigateur se ferme).
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      // Pas de pump pendant la pause : Flutter ne produit plus d'images, le test
      // attendrait indéfiniment. Retour immédiat au premier plan.
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await r.expectToast('Vérification de votre paiement');
      await r.measure(
        'solde crédité après paiement',
        () async {},
        find.textContaining(_money.format(105000)),
        timeout: const Duration(seconds: 15),
      );
      r.healthy('portefeuille après recharge');
    },
  );

  testWidgets(
    'retrait : minimum, maximum, frais affichés, confirmation, solde débité',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.go('/wallet', until: find.text('Retirer'));
      await r.tapText('Retirer');
      await r.waitFor(r.dialog(), why: 'popup de retrait');

      await r.fill('Montant', '100');
      await r.settle(0.5);
      expect(
        find.text('Le montant minimum de retrait est de 500 FCFA'),
        findsOneWidget,
      );
      await r.fill('Montant', '60000');
      await r.settle(0.5);
      expect(
        find.text('Le montant maximum par retrait est de 50 000 FCFA'),
        findsOneWidget,
      );

      await r.fill('Montant', '2000');
      await r.settle(0.5);
      // Compte gratuit : 3 % (min 100 FCFA) → 100 FCFA de frais, 2 100 débités.
      expect(find.textContaining('Frais standards de 3%'), findsOneWidget);
      await r.waitFor(
        find.textContaining(_money.format(2100)),
        why: 'total débité 2 100 affiché',
      );
      r.healthy('popup retrait');

      // Numéro Orange (pré-rempli) : le retrait est TENTÉ. Le bac à sable NotchPay
      // refuse les versements Orange → remboursement immédiat + message clair.
      await r.measure(
        'retrait Orange refusé par l\x27opérateur sandbox (API + NotchPay)',
        () => r.dialogTap('Confirmer'),
        find.textContaining('a été refusé par l\x27opérateur'),
        timeout: const Duration(seconds: 30),
      );
      expect(
        find.textContaining('channel'),
        findsNothing,
        reason: 'pas de texte technique anglais',
      );
      await r.settle(1);
      if (r.dialog().evaluate().isNotEmpty &&
          find.text('Compris').evaluate().isNotEmpty) {
        await r.dialogTap('Compris');
        await r.settle(0.5);
      }
      await r.clearToasts();
      await r.go('/wallet', until: find.text('Retirer'));
      await r.waitFor(
        find.textContaining(_money.format(105000)),
        why: 'solde intact après refus',
      );

      // Numéro MTN → retrait accepté.
      await r.tapText('Retirer');
      await r.waitFor(r.dialog());
      await r.fill('Montant', '2000');
      await r.fill('Numéro de téléphone', '670000001');
      await r.choose('Opérateur', 'MTN MoMo Cameroun');
      await r.settle(0.5);
      await r.measure(
        'demander un retrait MTN (API + NotchPay sandbox)',
        () => r.dialogTap('Confirmer'),
        find.textContaining('Demande de retrait soumise avec succès'),
        timeout: const Duration(seconds: 30),
      );
      await r.settle(1);
      if (r.dialog().evaluate().isNotEmpty &&
          find.text('Compris').evaluate().isNotEmpty) {
        await r.dialogTap('Compris');
      }
      await r.waitFor(
        find.textContaining(_money.format(105000 - 2100)),
        why: 'solde débité (montant + frais)',
      );
    },
  );
}
