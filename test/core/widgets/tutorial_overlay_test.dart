import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/widgets/tutorial/tutorial_overlay.dart';
import 'package:kauri/core/widgets/tutorial/tutorial_step.dart';
import 'package:kauri/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('TutorialOverlayController shows steps, advances, and finishes', (
    tester,
  ) async {
    final targetA = GlobalKey();
    final targetB = GlobalKey();
    bool finished = false;
    bool skipped = false;

    late BuildContext capturedContext;

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) {
            capturedContext = context;
            return Column(
              children: [
                SizedBox(key: targetA, height: 40, width: 40),
                const SizedBox(height: 200),
                SizedBox(key: targetB, height: 40, width: 40),
              ],
            );
          },
        ),
      ),
    );

    TutorialOverlayController.show(
      capturedContext,
      steps: [
        TutorialStep(
          targetKey: targetA,
          title: 'Étape 1',
          description: 'Description de la première étape',
        ),
        TutorialStep(
          targetKey: targetB,
          title: 'Étape 2',
          description: 'Description de la seconde étape',
        ),
      ],
      onFinish: () => finished = true,
      onSkip: () => skipped = true,
    );

    // pumpAndSettle ne convient pas ici : le halo autour de la cible pulse
    // en boucle indéfiniment par conception, donc l'arbre ne "se stabilise"
    // jamais tant que l'overlay est affiché — on avance de durées fixes.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Étape 1'), findsOneWidget);
    expect(find.text('Description de la première étape'), findsOneWidget);
    expect(TutorialOverlayController.isShowing, isTrue);

    await tester.tap(find.text('Suivant'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Étape 2'), findsOneWidget);
    expect(finished, isFalse);

    await tester.tap(find.text('Compris'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(finished, isTrue);
    expect(skipped, isFalse);
    expect(TutorialOverlayController.isShowing, isFalse);
  });

  testWidgets('TutorialOverlayController skip calls onSkip and hides', (
    tester,
  ) async {
    final target = GlobalKey();
    bool skipped = false;
    late BuildContext capturedContext;

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) {
            capturedContext = context;
            return SizedBox(key: target, height: 40, width: 40);
          },
        ),
      ),
    );

    TutorialOverlayController.show(
      capturedContext,
      steps: [
        TutorialStep(
          targetKey: target,
          title: 'Étape unique',
          description: 'Description',
        ),
      ],
      onFinish: () {},
      onSkip: () => skipped = true,
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Passer'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(skipped, isTrue);
    expect(TutorialOverlayController.isShowing, isFalse);
  });

  testWidgets(
    'keeps the tooltip and its buttons on-screen when the target is taller than the viewport',
    (tester) async {
      // Reproduit le bug signalé : une cible qui dépasse largement la
      // hauteur de l'écran (ex: toute une section de réglages avec
      // plusieurs groupes) ne doit jamais pousser la carte — et donc ses
      // boutons Passer/Suivant — hors de la zone visible.
      final hugeTarget = GlobalKey();
      late BuildContext capturedContext;

      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              capturedContext = context;
              // Bien plus haut que la taille de test par défaut (~600px).
              return SizedBox(key: hugeTarget, height: 2000, width: 300);
            },
          ),
        ),
      );

      TutorialOverlayController.show(
        capturedContext,
        steps: [
          TutorialStep(
            targetKey: hugeTarget,
            title: 'Réglages',
            description: 'Une description assez longue pour ce groupe.',
          ),
        ],
        onFinish: () {},
        onSkip: () {},
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;

      // Le bouton doit exister ET se trouver dans les limites verticales de
      // l'écran de test — c'est précisément ce qui échouait avant le correctif
      // (la carte pouvait être positionnée avec des coordonnées négatives ou
      // au-delà de la hauteur de l'écran).
      // Étape unique -> le bouton affiche "Compris" (dernière étape).
      final buttonFinder = find.text('Compris');
      expect(buttonFinder, findsOneWidget);
      final buttonCenter = tester.getCenter(buttonFinder);
      expect(buttonCenter.dy, greaterThanOrEqualTo(0));
      expect(buttonCenter.dy, lessThanOrEqualTo(screenSize.height));

      // Et il doit rester exploitable : le tap doit effectivement déclencher
      // la fin de la séquence.
      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    },
  );
}
