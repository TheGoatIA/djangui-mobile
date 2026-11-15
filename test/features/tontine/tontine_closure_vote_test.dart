import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/features/tontine/data/models/tontine_vote_model.dart';
import 'package:kauri/features/tontine/domain/repositories/tontine_repository.dart';
import 'package:kauri/features/tontine/presentation/widgets/tontine_closure_vote_card.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements TontineRepository {}

TontineVoteModel _vote({
  String status = 'open',
  String? outcome,
  bool hasVoted = false,
  int yes = 0,
  int no = 0,
  int voters = 0,
  DateTime? expiresAt,
}) => TontineVoteModel(
  id: 'v1',
  kind: 'closure',
  question: 'Clôturer la tontine "T" avant la fin du cycle ?',
  options: [
    TontineVoteOption(text: 'Oui, clôturer la tontine', count: yes),
    TontineVoteOption(text: 'Non, continuer', count: no),
  ],
  expiresAt: expiresAt ?? DateTime.now().add(const Duration(hours: 24)),
  status: status,
  outcome: outcome,
  hasVoted: hasVoted,
  votersCount: voters,
  majority: 2,
);

Future<void> _pump(
  WidgetTester tester,
  TontineRepository repo, {
  VoidCallback? onClosed,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: TontineClosureVoteCard(
            tontineId: 't1',
            repository: repo,
            onTontineClosed: onClosed,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('TontineVoteModel.fromJson', () {
    test(
      'lit la réponse API (hasVoted, votersCount, majority) sans liste de votants',
      () {
        final v = TontineVoteModel.fromJson({
          '_id': 'abc',
          'kind': 'closure',
          'question': 'q',
          'options': [
            {'text': 'Oui', 'count': 2},
            {'text': 'Non', 'count': 1},
          ],
          'expiresAt': DateTime.now()
              .add(const Duration(hours: 1))
              .toIso8601String(),
          'status': 'open',
          'hasVoted': true,
          'votersCount': 3,
          'majority': 2,
        });
        expect(v.id, 'abc');
        expect(v.isClosure, isTrue);
        expect(v.isOpen, isTrue);
        expect(v.yesCount, 2);
        expect(v.noCount, 1);
        expect(v.hasVoted, isTrue);
        expect(v.votersCount, 3);
        expect(v.majority, 2);
      },
    );

    test('données malformées → valeurs sûres, jamais d\'exception', () {
      final v = TontineVoteModel.fromJson({
        'options': 'x',
        'expiresAt': 'pas une date',
        'count': null,
      });
      expect(v.options, isEmpty);
      expect(v.yesCount, 0);
      expect(v.expiresAt, isNull);
      expect(v.kind, 'general');
      expect(v.hasVoted, isFalse);
    });

    test(
      'vote expiré = fermé même si le serveur ne l\'a pas encore marqué clos',
      () {
        final v = _vote(
          expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        );
        expect(v.isOpen, isFalse);
      },
    );
  });

  group('TontineClosureVoteCard', () {
    testWidgets(
      'aucun vote → explication + bouton « Proposer la clôture » ; propose après confirmation',
      (tester) async {
        when(
          () => repo.getVotes('t1'),
        ).thenAnswer((_) async => const Right([]));
        when(
          () => repo.proposeClosure('t1'),
        ).thenAnswer((_) async => Right(_vote()));
        await _pump(tester, repo);

        expect(find.textContaining('majorité des membres'), findsOneWidget);
        await tester.tap(find.byKey(const Key('proposeClosureButton')));
        await tester.pumpAndSettle();
        // Annuler → rien n'est envoyé
        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();
        verifyNever(() => repo.proposeClosure(any()));

        await tester.tap(find.byKey(const Key('proposeClosureButton')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('closureVoteConfirm')));
        await tester.pumpAndSettle();
        verify(() => repo.proposeClosure('t1')).called(1);
        expect(find.text('Vote de clôture en cours'), findsOneWidget);
        expect(find.byKey(const Key('voteYesClose')), findsOneWidget);
        expect(find.text('0 vote(s) · 2 voix nécessaires'), findsOneWidget);
      },
    );

    testWidgets(
      'vote ouvert : voter « Oui » qui atteint la majorité → tontine rechargée',
      (tester) async {
        var closed = 0;
        when(
          () => repo.getVotes('t1'),
        ).thenAnswer((_) async => Right([_vote(voters: 1, yes: 1)]));
        when(() => repo.castVote('t1', 'v1', 0)).thenAnswer(
          (_) async => Right(
            _vote(
              status: 'closed',
              outcome: 'approved',
              hasVoted: true,
              yes: 2,
              voters: 2,
            ),
          ),
        );
        await _pump(tester, repo, onClosed: () => closed++);

        await tester.tap(find.byKey(const Key('voteYesClose')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('closureVoteConfirm')));
        await tester.pumpAndSettle();

        verify(() => repo.castVote('t1', 'v1', 0)).called(1);
        expect(closed, 1);
        expect(find.text('Vote enregistré'), findsOneWidget);
        expect(
          find.text('Clôture approuvée : la tontine est terminée.'),
          findsOneWidget,
        );
        // Tontine clôturée : on ne propose plus de nouveau vote
        expect(find.byKey(const Key('proposeClosureButton')), findsNothing);
      },
    );

    testWidgets('voter « Non » ne déclenche pas de rechargement', (
      tester,
    ) async {
      var closed = 0;
      when(() => repo.getVotes('t1')).thenAnswer((_) async => Right([_vote()]));
      when(
        () => repo.castVote('t1', 'v1', 1),
      ).thenAnswer((_) async => Right(_vote(hasVoted: true, no: 1, voters: 1)));
      await _pump(tester, repo, onClosed: () => closed++);

      await tester.tap(find.byKey(const Key('voteNoContinue')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('closureVoteConfirm')));
      await tester.pumpAndSettle();
      expect(closed, 0);
      expect(
        find.text('Vous avez voté. Votre choix reste secret.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('voteYesClose')), findsNothing);
    });

    testWidgets('déjà voté → plus de boutons de vote', (tester) async {
      when(
        () => repo.getVotes('t1'),
      ).thenAnswer((_) async => Right([_vote(hasVoted: true, voters: 1)]));
      await _pump(tester, repo);
      expect(find.byKey(const Key('voteYesClose')), findsNothing);
      expect(find.byKey(const Key('voteNoContinue')), findsNothing);
      expect(find.textContaining('Vous avez voté'), findsOneWidget);
    });

    testWidgets(
      'erreur serveur au vote → message + rechargement de l\'état réel',
      (tester) async {
        when(
          () => repo.getVotes('t1'),
        ).thenAnswer((_) async => Right([_vote()]));
        when(
          () => repo.castVote('t1', 'v1', 0),
        ).thenAnswer((_) async => const Left(ServerFailure('Déjà voté')));
        await _pump(tester, repo);

        await tester.tap(find.byKey(const Key('voteYesClose')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('closureVoteConfirm')));
        await tester.pumpAndSettle();
        expect(find.text('Déjà voté'), findsOneWidget);
        verify(() => repo.getVotes('t1')).called(2);
      },
    );

    testWidgets(
      'dernier vote rejeté → résultat affiché et nouvelle proposition possible',
      (tester) async {
        when(() => repo.getVotes('t1')).thenAnswer(
          (_) async => Right([
            _vote(status: 'closed', outcome: 'rejected', no: 2, voters: 2),
          ]),
        );
        await _pump(tester, repo);
        expect(
          find.text('Clôture rejetée : la tontine continue.'),
          findsOneWidget,
        );
        expect(find.byKey(const Key('proposeClosureButton')), findsOneWidget);
      },
    );

    testWidgets('échec du chargement (hors-ligne) → message + réessayer', (
      tester,
    ) async {
      var calls = 0;
      when(() => repo.getVotes('t1')).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Left(NetworkFailure())
            : const Right(<TontineVoteModel>[]);
      });
      await _pump(tester, repo);
      expect(find.text('Erreur de connexion réseau'), findsOneWidget);
      await tester.tap(find.byKey(const Key('closureVoteRetry')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('proposeClosureButton')), findsOneWidget);
    });
  });
}
