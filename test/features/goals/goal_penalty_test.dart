import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/features/goals/data/models/goal_model.dart';
import 'package:kauri/features/goals/presentation/widgets/goal_delete_message.dart';
import 'package:kauri/l10n/app_localizations.dart';

GoalModel _goal({
  double current = 2000,
  double target = 50000,
  int daysLeft = 90,
  String status = 'active',
}) {
  final now = DateTime(2026, 11, 11, 12);
  return GoalModel(
    id: 'g',
    name: 'Voyage',
    targetAmount: target,
    currentAmount: current,
    deadline: now.add(Duration(days: daysLeft)),
    createdAt: now,
    status: status,
  );
}

final _now = DateTime(2026, 11, 11, 12);

void main() {
  group(
    'GoalModel.earlyExitPenalty (même règle que GoalService.deleteGoal)',
    () {
      test('avant échéance, non atteint → 0,5 % du montant', () {
        expect(_goal().earlyExitPenalty(_now), 10);
        expect(_goal(current: 1234).earlyExitPenalty(_now), 6.17);
      });
      test('aucune pénalité : vide, atteint, complété ou échéance passée', () {
        expect(_goal(current: 0).earlyExitPenalty(_now), 0);
        expect(_goal(current: 50000).earlyExitPenalty(_now), 0);
        expect(_goal(status: 'completed').earlyExitPenalty(_now), 0);
        expect(_goal(daysLeft: -1).earlyExitPenalty(_now), 0);
      });
    },
  );

  testWidgets(
    'message de suppression : annonce la retenue exacte, sinon message simple',
    (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (c) {
              l10n = AppLocalizations.of(c)!;
              return const SizedBox();
            },
          ),
        ),
      );
      final withPenalty = goalDeleteMessage(l10n, _goal(), now: _now);
      expect(withPenalty, contains('0,5 %'));
      expect(withPenalty, contains('10 XAF'));
      expect(withPenalty, contains('2\u202f000'));
      expect(
        goalDeleteMessage(l10n, _goal(current: 0), now: _now),
        l10n.deleteGoalConfirmation,
      );
    },
  );
}
