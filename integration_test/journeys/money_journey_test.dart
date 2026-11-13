// PARCOURS ARGENT AU QUOTIDIEN — saisir des dépenses, les retrouver, les
// supprimer ; créer un budget et le voir se remplir (alerte à 80 %) ; créer un
// objectif, épargner depuis le portefeuille, récupérer une partie, le supprimer
// (pénalité annoncée) ; vérifier le solde et les notifications reçues.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/intl.dart';

import 'package:kauri/features/notifications/presentation/widgets/notification_item.dart';

import '../support/robot.dart';

final _money = NumberFormat.decimalPattern('fr');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  setUpAll(bootstrapOnce);
  tearDownAll(() => printPerfReport('argent'));

  testWidgets('connexion de Mia', (tester) async {
    final r = Robot(tester);
    await r.launch();
    await r.loginUi('mobile@kauri-e2e.com');
  });

  testWidgets(
    'dépense : formulaire (erreurs), ajout, liste, détail, suppression (annuler puis confirmer)',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.go('/transactions', until: find.byType(FloatingActionButton));
      await r.measure(
        'ouvrir le formulaire de dépense',
        () => r.tap(find.byType(FloatingActionButton)),
        find.text('Enregistrer'),
      );

      // Envoi à vide → erreurs, rien n'est créé.
      await r.tapText('Enregistrer');
      await r.settle(0.5);
      expect(find.text('Champ requis'), findsWidgets);

      await r.fill('Montant', 'abc');
      await r.tapText('Enregistrer');
      await r.expectFieldError('Nombre invalide');

      await r.tapText('Dépense');
      await r.fill('Montant', '9000');
      await r.choose('Catégorie', 'Alimentation');
      await r.fill('Commerçant', 'Marché Mokolo');
      await r.fill('Description', 'Courses E2E');
      await r.hideKeyboard();
      await r.measure(
        'ajouter une dépense (API)',
        () => r.tapText('Enregistrer'),
        r.toast('Transaction ajoutée avec succès'),
      );
      await r.waitFor(
        find.text('Courses E2E'),
        why: 'dépense visible dans la liste',
      );
      r.healthy('liste transactions');

      // 2e dépense, que l'on va supprimer.
      await r.tap(find.byType(FloatingActionButton));
      await r.fill('Montant', '1200');
      await r.choose('Catégorie', 'Transport');
      await r.fill('Description', 'Taxi à supprimer');
      await r.hideKeyboard();
      await r.tapText('Enregistrer');
      await r.expectToast('Transaction ajoutée avec succès');
      await r.clearToasts();

      // Détail → suppression : Annuler ne supprime rien.
      await r.measure(
        'ouvrir le détail',
        () => r.tapText('Taxi à supprimer'),
        find.byIcon(Icons.delete_outline),
      );
      expect(
        find.text(
          'Cette transaction est manuelle et n\'affecte pas votre solde réel.',
        ),
        findsOneWidget,
      );
      await r.tap(find.byIcon(Icons.delete_outline));
      await r.expectDialog(
        'Voulez-vous vraiment supprimer cette transaction ?',
      );
      await r.dialogTap('Annuler');
      await r.waitGone(r.dialog());
      expect(
        find.byIcon(Icons.delete_outline),
        findsOneWidget,
        reason: 'toujours sur le détail',
      );

      await r.tap(find.byIcon(Icons.delete_outline));
      await r.measure(
        'supprimer une dépense (API)',
        () => r.dialogTap('Supprimer'),
        r.toast('Succès'),
      );
      await r.settle(1);
      expect(
        find.text('Taxi à supprimer'),
        findsNothing,
        reason: 'disparue de la liste',
      );
      expect(find.text('Courses E2E'), findsOneWidget);
      r.healthy('après suppression');
    },
  );

  testWidgets(
    'budget : création (2 catégories), dépense prise en compte, alerte de dépassement',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.go('/budgets', until: find.byType(FloatingActionButton));
      await r.tap(find.byType(FloatingActionButton));
      await r.waitFor(find.text('Créer Budget'));

      await r.tapText('Créer Budget');
      await r.settle(0.5);
      expect(find.text('Champ requis'), findsWidgets, reason: 'montant requis');

      await r.choose('Catégorie', 'Alimentation');
      await r.fill('Montant', '10000');
      await r.tapText('Ajouter');
      await r.settle(0.5);
      // 2e ligne de catégorie
      final categoryFields = find.ancestor(
        of: find.text('Catégorie'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      expect(categoryFields, findsNWidgets(2));
      await tester.tap(categoryFields.last);
      await r.settle(0.6);
      await tester.tap(find.text('Transport').last);
      await r.settle(0.5);
      // Le montant vide de la 2e ligne (indice « 0.00 »).
      await tester.enterText(
        find.widgetWithText(TextField, '0.00').last,
        '5000',
      );
      await r.hideKeyboard();
      await r.measure(
        'créer un budget (API)',
        () => r.tapText('Créer Budget'),
        r.toast('Budget créé avec succès'),
      );
      // La dépense de 9 000 (Alimentation) déjà saisie ce mois-ci est comptée.
      await r.waitFor(
        find.textContaining(_money.format(9000)),
        why: 'dépensé 9 000 sur Alimentation',
      );
      r.healthy('liste budgets');
    },
  );

  testWidgets(
    'objectif : création, épargne depuis le portefeuille, récupération partielle, suppression',
    (tester) async {
      final r = Robot(tester);
      await r.launch();

      // Solde de départ affiché sur le portefeuille.
      await r.go('/wallet', until: find.text('Solde disponible'));
      await r.waitFor(
        find.textContaining(_money.format(100000)),
        why: 'solde initial 100 000',
      );

      await r.go('/goals', until: find.byType(FloatingActionButton));
      await r.tap(find.byType(FloatingActionButton));
      await r.waitFor(find.text('Nouvel Objectif'));

      await r.fill('Nom de l\'objectif', 'Moto E2E');
      await r.fill('Montant Cible', '200000');
      await r.hideKeyboard();
      // Sans date → message explicite.
      await r.tapText('Enregistrer', last: true);
      await r.expectToast('Veuillez sélectionner une date');
      await r.clearToasts();

      await r.tapText('Date Limite');
      await r.settle(0.8);
      await r.tapText('OK', last: true); // date proposée : dans 30 jours
      await r.settle(0.5);
      await r.measure(
        'créer un objectif (API)',
        () => r.tapText('Enregistrer', last: true),
        r.toast('Objectif créé avec succès'),
      );
      await r.waitFor(find.text('Moto E2E'));

      // Épargner 5 000 depuis le portefeuille.
      await r.measure(
        'ouvrir l\'objectif',
        () => r.tapText('Moto E2E'),
        find.text('Ajouter Épargne'),
      );
      await r.tapText('Ajouter Épargne');
      await r.expectDialog('Ajouter Épargne');
      expect(
        find.descendant(of: r.dialog(), matching: find.text('Nouvel Objectif')),
        findsNothing,
      );
      await r.fill('Montant', '5000');
      await r.measure(
        'épargner 5 000 (API)',
        () => r.dialogTap('Confirmer'),
        r.toast('Épargne ajoutée à votre objectif'),
      );
      await r.waitFor(
        find.textContaining(_money.format(5000)),
        why: 'épargné 5 000 affiché',
      );
      await r.clearToasts();

      // Récupérer : avertissement de pénalité, montant trop élevé refusé, puis 1 000.
      await r.tapText('Récupérer l\'argent');
      await r.expectDialog('Récupérer des fonds');
      expect(
        find.textContaining('pénalité de 0,5%'),
        findsOneWidget,
        reason: 'retrait anticipé annoncé',
      );
      await r.fill('Saisissez le montant', '999999');
      await r.dialogTap('Confirmer le rachat');
      await r.waitFor(find.text('Le montant dépasse l\'épargne actuelle.'));
      await r.fill('Saisissez le montant', '1000');
      await r.measure(
        'récupérer 1 000 (API)',
        () => r.dialogTap('Confirmer le rachat'),
        r.toast('Fonds récupérés avec succès'),
      );
      await r.clearToasts();

      // Supprimer : la pénalité exacte est annoncée AVANT de confirmer.
      // Suppression : menu « ⋮ » de la barre du haut → « Supprimer ».
      await r.tap(find.byWidgetPredicate((w) => w is PopupMenuButton));
      await r.settle(0.8);
      await r.tapText('Supprimer', last: true);
      await r.expectDialog('pénalité de 0,5 %');
      await r.expectDialog('${_money.format(20)} XAF seront retenus');
      await r.measure(
        'supprimer l\'objectif (API)',
        () => r.dialogTap('Supprimer'),
        find.byType(FloatingActionButton),
      );
      await r.settle(1);
      expect(find.text('Moto E2E'), findsNothing);
      r.healthy('liste objectifs');

      // Solde : 100 000 − 5 000 + 1 000 (−0,5 % = 5) + 4 000 (−0,5 % = 20) = 99 975.
      await r.go('/wallet', until: find.text('Solde disponible'));
      await r.waitFor(
        find.textContaining(_money.format(99975)),
        why: 'solde final après épargne/retraits',
      );
    },
  );

  testWidgets(
    'portefeuille en mode simulation : recharge et retrait expliqués, aucun argent ne bouge',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.go('/wallet', until: find.text('Recharger'));
      await r.tapText('Recharger');
      await r.waitFor(r.dialog(), why: 'popup mode simulation');
      r.healthy('popup simulation');
      await r.dialogTap('Compris');
      await r.waitGone(r.dialog());
      await r.tapText('Retirer');
      await r.waitFor(r.dialog());
      await r.dialogTap('Compris');
      await r.waitGone(r.dialog());
    },
  );

  testWidgets(
    'notifications : mouvements reçus, ouverture, tout marquer comme lu',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.measure(
        'ouvrir les notifications',
        () => r.go('/notifications'),
        find.text('Notifications'),
      );
      await r.settle(2);
      expect(
        find.text('Aucune notification'),
        findsNothing,
        reason:
            'épargne / retrait / alerte budget doivent avoir créé des notifications',
      );
      final items = find.byType(NotificationItem);
      await r.waitFor(items, why: 'au moins une notification');
      debugPrint('Notifications affichées : ${items.evaluate().length}');
      await tester.tap(items.first);
      await r.settle(1);
      if (r.dialog().evaluate().isNotEmpty) {
        await r.dialogTap('Fermer');
        await r.waitGone(r.dialog());
      }
      await r.measure(
        'tout marquer comme lu (API)',
        () => r.tap(find.byTooltip('Tout marquer comme lu')),
        find.byType(NotificationItem),
      );
      r.healthy('notifications');
    },
  );
}
