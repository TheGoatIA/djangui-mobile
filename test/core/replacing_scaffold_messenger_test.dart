import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/widgets/replacing_scaffold_messenger.dart';

void main() {
  testWidgets(
    'un nouveau message remplace immédiatement le précédent (pas de file d\'attente)',
    (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) =>
              ReplacingScaffoldMessenger(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (c) {
                ctx = c;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Objectif créé'),
          duration: Duration(seconds: 4),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(const SnackBar(content: Text('Épargne ajoutée')));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Épargne ajoutée'), findsOneWidget);
      expect(find.text('Objectif créé'), findsNothing);
    },
  );
}
