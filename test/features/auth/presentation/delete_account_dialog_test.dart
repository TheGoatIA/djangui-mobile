import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/features/auth/presentation/widgets/delete_account_dialog.dart';
import 'package:kauri/l10n/app_localizations.dart';

/// Ouvre la boîte de dialogue depuis un bouton et expose la valeur retournée.
Future<void> _open(WidgetTester tester, void Function(String?) onResult) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              key: const Key('open'),
              onPressed: () async {
                final r = await showDialog<String>(
                  context: context,
                  builder: (_) => const DeleteAccountDialog(),
                );
                onResult(r);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('open')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('affiche un champ mot de passe masqué (ré-authentification)', (
    tester,
  ) async {
    await _open(tester, (_) {});

    final field = tester.widget<TextField>(
      find.byKey(const Key('delete_account_password')),
    );
    expect(field.obscureText, isTrue);
    expect(field.autocorrect, isFalse);
    expect(find.byKey(const Key('delete_account_confirm')), findsOneWidget);
  });

  testWidgets('confirmer retourne le mot de passe saisi', (tester) async {
    String? result = 'unset';
    await _open(tester, (r) => result = r);

    await tester.enterText(
      find.byKey(const Key('delete_account_password')),
      'S3cret!pass',
    );
    await tester.tap(find.byKey(const Key('delete_account_confirm')));
    await tester.pumpAndSettle();

    expect(result, 'S3cret!pass');
    expect(find.byType(DeleteAccountDialog), findsNothing);
  });

  testWidgets('annuler retourne null et ne soumet rien', (tester) async {
    String? result = 'unset';
    await _open(tester, (r) => result = r);

    await tester.enterText(
      find.byKey(const Key('delete_account_password')),
      'ne-doit-pas-sortir',
    );
    await tester.tap(find.byKey(const Key('delete_account_cancel')));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });

  testWidgets(
    'confirmer avec un champ vide retourne une chaîne vide (comptes Firebase)',
    (tester) async {
      String? result;
      await _open(tester, (r) => result = r);
      await tester.tap(find.byKey(const Key('delete_account_confirm')));
      await tester.pumpAndSettle();
      expect(result, '');
    },
  );
}
