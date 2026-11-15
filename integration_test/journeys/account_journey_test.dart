// PARCOURS COMPTE — comme un vrai utilisateur : inscription (avec erreurs de
// saisie), mot de passe oublié, connexion ratée puis réussie, édition du profil,
// changement de mot de passe, sessions, déconnexion.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../support/robot.dart';

final _stamp = DateTime.now().millisecondsSinceEpoch;
final _newEmail = 'nouveau$_stamp@kauri-e2e.com';
const _newPassword = 'Nouv3au-Passw0rd!';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  setUpAll(bootstrapOnce);
  tearDownAll(() => printPerfReport('compte'));

  testWidgets(
    'inscription : chaque erreur de saisie est expliquée, puis compte créé → vérification e-mail',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.waitFor(
        find.text('Se connecter'),
        why: 'écran de connexion au démarrage',
      );

      await r.measure(
        'ouvrir inscription',
        () => r.tapText("S'inscrire", last: true),
        find.text('Créer un compte'),
      );

      // Envoi à vide → champs requis signalés, aucune requête.
      await r.tapText("S'inscrire", last: true);
      await r.settle(0.5);
      expect(find.text('Champ requis'), findsWidgets);
      await r.expectFieldError('Veuillez entrer votre e-mail');

      await r.fill('Prénom', 'Nadia');
      await r.fill('Nom', 'Test');
      await r.fill('E-mail', 'pas-un-email');
      await r.fill('Mot de passe', 'faible');
      await r.fill('Confirmer le mot de passe', 'autre');
      await r.hideKeyboard();
      await r.tapText("S'inscrire", last: true);
      await r.settle(0.5);
      await r.expectFieldError('Veuillez entrer un e-mail valide');
      expect(
        find.textContaining('au moins 8 caractères'),
        findsWidgets,
        reason: 'règle de complexité affichée',
      );
      expect(
        find.text('Les mots de passe ne correspondent pas'),
        findsOneWidget,
      );

      // Corrige tout → compte créé.
      await r.fill('E-mail', _newEmail);
      await r.fill('Mot de passe', e2ePassword);
      await r.fill('Confirmer le mot de passe', e2ePassword);
      await r.hideKeyboard();
      await r.measure(
        'inscription (API)',
        () => r.tapText("S'inscrire", last: true),
        find.text('Vérifiez votre E-mail'),
        timeout: const Duration(seconds: 20),
      );
      r.healthy('page vérification e-mail');

      await r.tapText('Retour à la connexion');
      await r.waitFor(find.text('Se connecter'));

      // Même e-mail une 2e fois → refus clair (pas de doublon).
      await r.tapText("S'inscrire", last: true);
      await r.fill('Prénom', 'Nadia');
      await r.fill('Nom', 'Bis');
      await r.fill('E-mail', _newEmail);
      await r.fill('Mot de passe', e2ePassword);
      await r.fill('Confirmer le mot de passe', e2ePassword);
      await r.hideKeyboard();
      await r.tapText("S'inscrire", last: true);
      await r.waitFor(find.byType(SnackBar), why: 'toast e-mail déjà utilisé');
      final msg = tester
          .widget<Text>(
            find
                .descendant(
                  of: find.byType(SnackBar),
                  matching: find.byType(Text),
                )
                .first,
          )
          .data;
      debugPrint('Toast doublon : $msg');
      expect(
        msg,
        isNot(contains('Exception')),
        reason: 'aucun détail technique montré',
      );
      r.healthy('doublon inscription');
    },
  );

  testWidgets('mot de passe oublié : validation puis confirmation d\'envoi', (
    tester,
  ) async {
    final r = Robot(tester);
    await r.launch();
    await r.go('/login', until: find.text('Se connecter'));
    await r.tapText('Mot de passe oublié ?');
    await r.waitFor(find.text('Envoyer le lien'));
    await r.tapText('Envoyer le lien');
    await r.expectFieldError('Veuillez entrer votre e-mail');
    await r.fill('E-mail', 'mobile@kauri-e2e.com');
    await r.hideKeyboard();
    await r.measure(
      'mot de passe oublié (API)',
      () => r.tapText('Envoyer le lien'),
      find.byType(SnackBar),
    );
    await r.expectToast('E-mail envoyé avec succès');
    r.healthy('mot de passe oublié');
  });

  testWidgets('connexion : erreurs compréhensibles en français, puis succès', (
    tester,
  ) async {
    final r = Robot(tester);
    await r.launch();
    await r.go('/login', until: find.text('Se connecter'));

    await r.tapText('Se connecter', last: true);
    await r.expectFieldError('Veuillez entrer votre e-mail');
    await r.expectFieldError('Veuillez entrer votre mot de passe');

    await r.fill('E-mail', 'mobile@kauri-e2e.com');
    await r.fill('Mot de passe', 'Mauvais-Passw0rd!');
    await r.hideKeyboard();
    await r.measure(
      'connexion refusée (API)',
      () => r.tapText('Se connecter', last: true),
      find.byType(SnackBar),
    );
    final msg =
        tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byType(SnackBar),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data ??
        '';
    debugPrint('Toast mauvais mot de passe : $msg');
    expect(
      msg.toLowerCase(),
      isNot(contains('incorrect email')),
      reason: 'message en anglais dans une app en français',
    );
    expect(
      find.byType(NavigationBar),
      findsNothing,
      reason: 'reste sur l\'écran de connexion',
    );
    await r.clearToasts();

    await r.fill('Mot de passe', e2ePassword);
    await r.hideKeyboard();
    await r.measure(
      'connexion (API + tableau de bord)',
      () => r.tapText('Se connecter', last: true),
      find.byType(NavigationBar),
      timeout: const Duration(seconds: 25),
    );
    await r.settle(2);
    await r.dismissTutorial();
    await r.waitFor(
      find.textContaining('Mia'),
      why: 'prénom de l\'utilisateur sur le tableau de bord',
    );
    r.healthy('tableau de bord');
  });

  testWidgets('profil : modifier prénom et revenu → visible immédiatement', (
    tester,
  ) async {
    final r = Robot(tester);
    await r.launch();
    await r.go('/profile', until: find.text('Langue'));
    await r.tap(find.byIcon(Icons.edit_outlined));
    await r.expectDialog('Prénom');
    await r.fill('Prénom', '');
    await r.dialogTap('Enregistrer');
    await r.expectFieldError('Champ requis');
    await r.fill('Prénom', 'Miala');
    await r.fill('Revenu Mensuel', '350000');
    await r.measure(
      'mise à jour profil (API)',
      () => r.dialogTap('Enregistrer'),
      find.textContaining('Miala'),
    );
    await r.waitGone(r.dialog());
    r.healthy('profil');
    // Rechargement depuis le serveur : la modification est bien persistée.
    await r.go('/dashboard', until: find.byType(NavigationBar));
    await r.go('/profile', until: find.textContaining('Miala'));
  });

  testWidgets(
    'sécurité : changer le mot de passe (erreurs, puis succès) et se reconnecter avec',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.go('/change-password', until: find.text('Mettre à jour'));
      await r.tapText('Mettre à jour');
      await r.expectFieldError('Champ requis');

      await r.fill('Mot de passe actuel', 'Pas-Le-B0n-mdp!');
      await r.fill('Nouveau mot de passe', 'court');
      await r.fill('Confirmer nouveau mot de passe', 'different');
      await r.hideKeyboard();
      await r.tapText('Mettre à jour');
      await r.settle(0.5);
      expect(find.textContaining('au moins 8 caractères'), findsWidgets);
      await r.expectFieldError('Les mots de passe ne correspondent pas');

      // Mot de passe actuel faux → refus serveur expliqué.
      await r.fill('Nouveau mot de passe', _newPassword);
      await r.fill('Confirmer nouveau mot de passe', _newPassword);
      await r.hideKeyboard();
      await r.measure(
        'changement mdp refusé (API)',
        () => r.tapText('Mettre à jour'),
        find.byType(SnackBar),
      );
      debugPrint(
        'Toast mdp actuel faux : '
        '${tester.widget<Text>(find.descendant(of: find.byType(SnackBar), matching: find.byType(Text)).first).data}',
      );
      await r.clearToasts();

      await r.fill('Mot de passe actuel', e2ePassword);
      await r.hideKeyboard();
      await r.measure(
        'changement mdp (API)',
        () => r.tapText('Mettre à jour'),
        r.toast('Mot de passe mis à jour avec succès'),
      );
      r.healthy('changement mdp');
    },
  );

  testWidgets(
    'sessions puis déconnexion (annuler / confirmer) et reconnexion avec le nouveau mot de passe',
    (tester) async {
      final r = Robot(tester);
      await r.launch();
      await r.go('/sessions', until: find.text('Sessions Actives'));
      await r.waitFor(
        find.text('Session Actuelle'),
        why: 'session courante listée',
      );
      r.healthy('sessions');

      // Déconnexion : « Annuler » ne déconnecte pas.
      await r.go('/profile', until: find.text('Déconnexion'));
      await r.tapText('Déconnexion');
      await r.expectDialog('Êtes-vous sûr de vouloir vous déconnecter ?');
      await r.dialogTap('Annuler');
      await r.waitGone(r.dialog());
      expect(find.text('Langue'), findsOneWidget);

      await r.logoutUi();

      // L'ancien mot de passe ne marche plus ; le nouveau oui.
      await r.fill('E-mail', 'mobile@kauri-e2e.com');
      await r.fill('Mot de passe', e2ePassword);
      await r.hideKeyboard();
      await r.tapText('Se connecter', last: true);
      await r.waitFor(find.byType(SnackBar), why: 'ancien mot de passe refusé');
      expect(find.byType(NavigationBar), findsNothing);
      await r.clearToasts();
      await r.loginUi('mobile@kauri-e2e.com', password: _newPassword);
      await r.waitFor(find.textContaining('Miala'));
    },
  );
}
