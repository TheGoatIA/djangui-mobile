// PARCOURS SOCIAL — deux vrais utilisateurs : Mia crée une tontine (formulaire
// en 3 étapes), Fred la rejoint avec le code d'invitation (erreur puis succès)
// et écrit dans le chat ; Mia lit, répond, démarre la tontine, cotise avec un
// reçu (photo), puis valide la cotisation. Enfin : ticket support complet.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/tontine/domain/repositories/tontine_repository.dart';

import '../support/robot.dart';

/// Galerie simulée : renvoie une vraie image PNG (reçu de transfert).
class _FakeGallery extends ImagePickerPlatform {
  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    // PNG 1×1 valide.
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
    );
    final f = File(
      '${Directory.systemTemp.path}/recu_e2e_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await f.writeAsBytes(png);
    return XFile(f.path);
  }
}

final _name = 'Tontine Amis ${DateTime.now().millisecondsSinceEpoch % 100000}';

Future<void> tapContinue(Robot r) async {
  final f = find.byWidgetPredicate(
    (w) =>
        w is Text &&
        RegExp(r'^continuer$', caseSensitive: false).hasMatch(w.data ?? ''),
  );
  // Le Stepper garde les boutons des étapes repliées : seul le bouton visible compte.
  await r.tap(f.hitTestable().first);
  await r.settle(0.8);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  setUpAll(() async {
    await bootstrapOnce();
    ImagePickerPlatform.instance = _FakeGallery();
  });
  tearDownAll(() => printPerfReport('social'));

  testWidgets('Mia crée une tontine (formulaire en 3 étapes, validation)', (
    tester,
  ) async {
    final r = Robot(tester);
    await r.launch();
    await r.loginUi('mobile@kauri-e2e.com');
    await r.go('/tontines/create', until: find.text('Informations de base'));

    // Étape 1 vide → refus.
    await tapContinue(r);
    expect(find.text('Champ requis'), findsWidgets);

    await r.fill('Nom de la tontine', _name);
    await r.fill('Montant de la cotisation', '5000');
    await r.hideKeyboard();
    await tapContinue(r);
    await r.waitFor(
      find
          .byWidgetPredicate(
            (w) =>
                w is TextField &&
                w.decoration?.labelText == 'Nombre total de parts',
          )
          .hitTestable(),
      why: 'étape 2',
    );
    await r.fill('Nombre total de parts', '2');
    await r.hideKeyboard();
    await tapContinue(r);
    // Le titre « Résumé » est toujours affiché : on attend le CONTENU du résumé.
    await r.waitFor(find.text(_name).hitTestable(), why: 'étape 3 (résumé)');
    await r.measure(
      'créer la tontine (API)',
      () => tapContinue(r),
      r.toast('Tontine créée avec succès'),
    );
    r.healthy('création tontine');
    await r.go('/tontines', until: find.text(_name));
  });

  testWidgets(
    'Fred rejoint avec le code (code faux refusé), écrit dans le chat',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      // Le code est envoyé par Mia via WhatsApp (feuille de partage système) :
      // on le lit comme Fred l'aurait reçu.
      final tontines = (await getIt<TontineRepository>().getTontines())
          .getOrElse((_) => []);
      final code = tontines.firstWhere((t) => t.name == _name).inviteCode;
      expect(code, isNotEmpty);

      await r.logoutUi();
      await r.loginUi('friend@kauri-e2e.com');
      await r.go('/tontines/join', until: find.text('Rejoindre maintenant'));

      await r.tapText('Rejoindre maintenant');
      await r.expectFieldError('Champ requis');

      await r.fill("Code d'invitation", 'FAUX-000');
      await r.fill('Pseudonyme', 'Fred');
      await r.hideKeyboard();
      await r.measure(
        'rejoindre avec un code faux (API)',
        () => r.tapText('Rejoindre maintenant'),
        find.byType(SnackBar),
      );
      debugPrint(
        'Toast code faux : ${tester.widget<Text>(find.descendant(of: find.byType(SnackBar), matching: find.byType(Text)).first).data}',
      );
      expect(r.toast('Tontine rejointe avec succès'), findsNothing);
      await r.clearToasts();

      await r.fill("Code d'invitation", code);
      await r.hideKeyboard();
      await r.measure(
        'rejoindre la tontine (API)',
        () => r.tapText('Rejoindre maintenant'),
        r.toast('Tontine rejointe avec succès'),
      );

      await r.go('/tontines', until: find.text(_name));
      await r.measure(
        'ouvrir la tontine',
        () => r.tapText(_name),
        find.text('Chat'),
      );
      await r.dismissTutorial();
      await r.tapText('Chat');
      await r.settle(1.5);
      await r.fill('Tapez un message...', 'Salut Mia, je suis dedans !');
      await r.measure(
        'envoyer un message (API)',
        () => r.tap(find.byIcon(Icons.send)),
        find.text('Salut Mia, je suis dedans !'),
      );
      r.healthy('chat');
    },
  );

  testWidgets(
    'Mia lit et répond, démarre la tontine, cotise avec un reçu, valide',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.logoutUi();
      await r.loginUi('mobile@kauri-e2e.com');
      await r.go('/tontines', until: find.text(_name));
      await r.tapText(_name);
      await r.waitFor(find.text('Chat'));
      await r.dismissTutorial();

      // Membres : Fred est là.
      await r.tapText('Membres');
      await r.waitFor(
        find.textContaining('Fred'),
        why: 'Fred dans les membres',
      );

      // Chat : message de Fred, réponse.
      await r.tapText('Chat');
      await r.waitFor(
        find.text('Salut Mia, je suis dedans !'),
        why: 'message de Fred reçu',
      );
      await r.fill('Tapez un message...', 'Bienvenue Fred !');
      await r.tap(find.byIcon(Icons.send));
      await r.waitFor(find.text('Bienvenue Fred !'));

      // Démarrer : popup de confirmation.
      await r.tapText('Accueil');
      await r.settle(1);
      await r.tapText('Démarrer la tontine');
      await r.expectDialog('Êtes-vous sûr de vouloir démarrer cette Tontine ?');
      await r.measure(
        'démarrer la tontine (API)',
        () => r.dialogTap('Commencer'),
        find.byKey(const Key('tontineClosureVoteCard')),
      );
      r.healthy('tontine démarrée');

      // Cotiser : reçu obligatoire.
      await r.tap(find.text('Cotiser'));
      await r.expectDialog('Cotiser');
      await r.tap(
        find.descendant(
          of: r.dialog(),
          matching: find.byIcon(Icons.add_a_photo_outlined),
        ),
      );
      await r.settle(1.5);
      await r.measure(
        'envoyer la cotisation avec reçu (API + upload)',
        () => r.dialogTap('Enregistrer'),
        r.toast('Cotisation envoyée'),
        timeout: const Duration(seconds: 20),
      );
      debugPrint(
        'Toast cotisation : ${tester.widget<Text>(find.descendant(of: find.byType(SnackBar), matching: find.byType(Text)).first).data}',
      );
      await r.clearToasts();

      // Validation par la créatrice.
      await r.tapText('Validation');
      await r.waitFor(
        find.text('Approuver'),
        why: 'cotisation en attente de validation',
      );
      await r.measure(
        'approuver la cotisation (API)',
        () => r.tapText('Approuver'),
        find.text('Aucune cotisation en attente'),
      );
      r.healthy('validation');
    },
  );

  testWidgets('support : ticket (validation, envoi), ouverture, réponse', (
    tester,
  ) async {
    final r = Robot(tester);
    await r.launch();
    await r.go('/support/tickets/create', until: find.text('Envoyer Ticket'));
    await r.tapText('Envoyer Ticket');
    await r.expectFieldError('Champ requis');
    await r.choose('Catégorie', 'Paiement');
    await r.fill('Sujet', 'Recharge non reçue');
    await r.fill(
      'Message',
      "J'ai rechargé 5 000 FCFA hier mais mon solde n'a pas bougé.",
    );
    await r.hideKeyboard();
    await r.measure(
      'créer un ticket (API)',
      () => r.tapText('Envoyer Ticket'),
      r.toast('Ticket créé avec succès'),
    );
    await r.go('/support/tickets', until: find.text('Recharge non reçue'));
    expect(
      find.text('Paiement'),
      findsWidgets,
      reason: 'catégorie traduite, pas le code brut "payment"',
    );
    await r.measure(
      'ouvrir le ticket',
      () => r.tapText('Recharge non reçue'),
      find.textContaining("J'ai rechargé"),
    );
    await r.fill('Répondre', 'Référence de la recharge : NTP-1234');
    await r.measure(
      'répondre au ticket (API)',
      () => r.tap(find.byIcon(Icons.send)),
      find.text('Référence de la recharge : NTP-1234'),
    );
    r.healthy('ticket');
  });
}
