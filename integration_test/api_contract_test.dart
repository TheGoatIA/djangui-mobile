// Tests d'intégration "contrat" : la VRAIE couche données de l'app (DI, Chopper,
// convertisseurs JSON, intercepteurs d'auth, stockage sécurisé) contre la VRAIE
// API Kauri, sur émulateur/appareil.
//
// Prérequis (dépôt API) :
//   npm run test:infra:up
//   E2E_PUBLIC_HOST=10.0.2.2 node scripts/e2e-server.js     (seed kauri_e2e, effets externes coupés)
// Lancement (dépôt mobile) :
//   flutter test integration_test/api_contract_test.dart -d emulator-5554 \
//     --dart-define=API_BASE_URL=http://10.0.2.2:5055/api/v1
//
// Ce que ça attrape : un champ renommé/nullable côté API qui ferait planter un
// `fromJson`, un endpoint déplacé, un décodeur non enregistré, une erreur d'auth.
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kauri/core/config/env_config.dart';
import 'package:kauri/core/errors/failures.dart';
import 'package:kauri/di/injection.dart';
import 'package:kauri/features/auth/data/models/login_request.dart';
import 'package:kauri/features/auth/domain/repositories/auth_repository.dart';
import 'package:kauri/features/budgets/data/models/budget_model.dart';
import 'package:kauri/features/budgets/domain/repositories/budget_repository.dart';
import 'package:kauri/features/challenges/domain/repositories/challenge_repository.dart';
import 'package:kauri/features/goals/data/models/goal_model.dart';
import 'package:kauri/features/goals/domain/repositories/goal_repository.dart';
import 'package:kauri/features/notifications/domain/repositories/notification_repository.dart';
import 'package:kauri/features/payments/domain/repositories/fintech_repository.dart';
import 'package:kauri/features/reports/domain/repositories/reports_repository.dart';
import 'package:kauri/features/support/domain/repositories/support_repository.dart';
import 'package:kauri/features/tontine/domain/repositories/tontine_repository.dart';
import 'package:kauri/features/transactions/data/models/transaction_model.dart';
import 'package:kauri/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kauri/features/user_subscriptions/domain/repositories/subscription_repository.dart';

const _password = 'E2e-Passw0rd!';

/// Déroule un Either : échoue le test avec le message serveur si c'est un Left.
T ok<T>(Either<Failure, T> r, String what) =>
    r.match((f) => fail('$what → ${f.runtimeType}: ${f.message}'), (v) => v);

String failureOf<T>(Either<Failure, T> r, String what) =>
    r.match((f) => f.message, (_) => fail('$what aurait dû échouer'));

Future<void> loginAs(String email) async {
  final auth = getIt<AuthRepository>();
  await auth
      .logout(); // repart d'une session propre (tokens, cache utilisateur)
  ok(
    await auth.login(LoginRequest(email: email, password: _password)),
    'login $email',
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    expect(
      EnvConfig.apiBaseUrl,
      contains(':5055'),
      reason:
          'Ces tests écrivent des données : uniquement contre l\'API E2E locale '
          '(--dart-define=API_BASE_URL=http://10.0.2.2:5055/api/v1)',
    );
    await configureDependencies();
  });

  group('Authentification', () {
    testWidgets('mauvais mot de passe → échec propre, aucun jeton gardé', (
      _,
    ) async {
      final auth = getIt<AuthRepository>();
      await auth.logout();
      final r = await auth.login(
        LoginRequest(email: 'client@kauri-e2e.com', password: 'faux-Passw0rd!'),
      );
      expect(failureOf(r, 'login mauvais mdp'), isNotEmpty);
      expect(await auth.isAuthenticated(), isFalse);
    });

    testWidgets('connexion → profil courant décodé, sessions listées', (
      _,
    ) async {
      await loginAs('client@kauri-e2e.com');
      final auth = getIt<AuthRepository>();
      final me = ok(await auth.getCurrentUser(), 'getCurrentUser');
      expect(me.email, 'client@kauri-e2e.com');
      expect(me.firstName, 'Awa');
      final sessions = ok(await auth.getSessions(), 'getSessions');
      expect(sessions, isNotEmpty);
    });
  });

  group('Lecture de chaque module (décodage des vraies réponses)', () {
    setUpAll(() => loginAs('client@kauri-e2e.com'));

    testWidgets('portefeuille : solde seedé 25 000 XAF', (_) async {
      expect(
        ok(await getIt<FintechRepository>().getWalletBalance(), 'balance'),
        25000,
      );
    });

    testWidgets('transactions', (_) async {
      final txs = ok(
        await getIt<TransactionRepository>().getTransactions(
          forceRefresh: true,
        ),
        'transactions',
      );
      expect(txs, isA<List<TransactionModel>>());
    });

    testWidgets('objectifs : objectif seedé présent', (_) async {
      final goals = ok(
        await getIt<GoalRepository>().getGoals(forceRefresh: true),
        'goals',
      );
      expect(goals.map((g) => g.name), contains('Objectif E2E'));
    });

    testWidgets('budgets, défis, notifications, abonnements, support', (
      _,
    ) async {
      ok(
        await getIt<BudgetRepository>().getBudgets(forceRefresh: true),
        'budgets',
      );
      ok(
        await getIt<ChallengeRepository>().getChallenges(forceRefresh: true),
        'challenges',
      );
      ok(
        await getIt<ChallengeRepository>().getUserChallenges(),
        'userChallenges',
      );
      ok(
        await getIt<NotificationRepository>().getNotifications(),
        'notifications',
      );
      ok(await getIt<NotificationRepository>().getUnreadCount(), 'unreadCount');
      ok(
        await getIt<SubscriptionRepository>().getSubscriptions(),
        'subscriptions',
      );
      ok(await getIt<SupportRepository>().getTickets(), 'tickets');
    });

    testWidgets('rapports', (_) async {
      final reports = getIt<ReportsRepository>();
      ok(await reports.getDashboardReport(), 'dashboardReport');
      ok(await reports.getSpendingAnalysis(), 'spendingAnalysis');
      ok(await reports.getSavingsTrend(), 'savingsTrend');
      // Prévision de solde = fonctionnalité premium : refus explicite pour un compte gratuit.
      expect(
        failureOf(await reports.getBalanceForecast(), 'forecast (gratuit)'),
        contains(RegExp('premium', caseSensitive: false)),
      );
      expect(
        failureOf(
          await reports.getHealthScoreHistory(),
          'healthScore (gratuit)',
        ),
        contains(RegExp('premium', caseSensitive: false)),
      );
    });

    testWidgets('tontines : liste, détail, membres, contributions, votes', (
      _,
    ) async {
      final repo = getIt<TontineRepository>();
      final list = ok(await repo.getTontines(), 'tontines');
      final t = list.firstWhere((t) => t.name == 'Tontine E2E');
      final details = ok(await repo.getTontineDetails(t.id), 'tontineDetails');
      expect(details.status.toLowerCase(), 'active');
      expect(ok(await repo.getTontineMembers(t.id), 'members'), isNotEmpty);
      ok(await repo.getContributions(t.id), 'contributions');
      ok(await repo.getTontineMessages(t.id), 'messages');
      ok(await repo.getVotes(t.id), 'votes');
    });
  });

  group('Écritures (aller-retour complet app → API → app)', () {
    setUpAll(() => loginAs('client@kauri-e2e.com'));

    testWidgets('transaction manuelle : créer puis supprimer', (_) async {
      final repo = getIt<TransactionRepository>();
      final created = ok(
        await repo.createTransaction(
          TransactionModel(
            id: '',
            amount: 1500,
            type: 'expense',
            category: 'food',
            description: 'Déjeuner test E2E',
            date: DateTime.now(),
          ),
        ),
        'createTransaction',
      );
      expect(created.id, isNotEmpty);
      expect(created.amount, 1500);
      ok(await repo.deleteTransaction(created.id), 'deleteTransaction');
    });

    testWidgets(
      'objectif : créer, épargner depuis le portefeuille, supprimer (remboursé)',
      (_) async {
        final goals = getIt<GoalRepository>();
        final wallet = getIt<FintechRepository>();
        final before = ok(await wallet.getWalletBalance(), 'balance');
        final goal = ok(
          await goals.createGoal(
            GoalModel(
              id: '',
              name: 'Voyage E2E',
              // comme add_goal_page : type API + règles d'épargne toujours envoyées
              type: 'regular',
              autoSaveRules: const AutoSaveRulesModel(),
              targetAmount: 50000,
              deadline: DateTime.now().add(const Duration(days: 90)),
              createdAt: DateTime.now(),
            ),
          ),
          'createGoal',
        );
        expect(goal.id, isNotEmpty);
        final updated = ok(
          await goals.updateGoalAmount(goal.id, 2000, note: 'e2e'),
          'updateGoalAmount',
        );
        expect(updated.currentAmount, 2000);
        // Suppression avant l'échéance : remboursement MOINS la pénalité de 0,5 %
        // — exactement le montant que l'app annonce dans la boîte de confirmation.
        final penalty = updated.earlyExitPenalty();
        expect(penalty, 10);
        ok(await goals.deleteGoal(goal.id), 'deleteGoal');
        expect(
          ok(await wallet.getWalletBalance(), 'balance'),
          before - penalty,
        );
      },
    );

    testWidgets('budget : créer puis supprimer', (_) async {
      final repo = getIt<BudgetRepository>();
      final now = DateTime.now();
      final created = ok(
        await repo.createBudget(
          BudgetModel(
            id: '',
            period: BudgetPeriodModel(
              type: 'monthly',
              month: now.month,
              year: now.year,
            ),
            categories: const [
              BudgetCategoryModel(
                name: 'food',
                allocated: 30000,
                spent: 0,
                percentage: 0,
              ),
              BudgetCategoryModel(
                name: 'transport',
                allocated: 20000,
                spent: 0,
                percentage: 0,
              ),
            ],
            totalAllocated: 50000,
            totalSpent: 0,
            status: 'active',
          ),
        ),
        'createBudget',
      );
      expect(created.id, isNotEmpty);
      expect(created.categories.length, 2);
      ok(await repo.deleteBudget(created.id), 'deleteBudget');
    });

    testWidgets('support : ouvrir un ticket puis le retrouver', (_) async {
      final repo = getIt<SupportRepository>();
      ok(
        await repo.createTicket(
          subject: 'Ticket mobile E2E',
          message: 'Message envoyé par le test d\'intégration mobile.',
          category: 'other',
        ),
        'createTicket',
      );
      final tickets = ok(await repo.getTickets(), 'tickets');
      expect(tickets.map((t) => t.subject), contains('Ticket mobile E2E'));
    });

    testWidgets(
      'retrait refusé (mode simulation / solde) → message clair, aucun argent ne sort',
      (_) async {
        final wallet = getIt<FintechRepository>();
        final before = ok(await wallet.getWalletBalance(), 'balance');
        final r = await wallet.requestPayout(
          amount: 40000,
          phoneNumber: '+237670000000',
          provider: 'CM_MOMO',
        );
        expect(failureOf(r, 'payout > solde'), isNotEmpty);
        expect(ok(await wallet.getWalletBalance(), 'balance'), before);
      },
    );
  });

  group('Tontine : vote de clôture de bout en bout (2 membres réels)', () {
    testWidgets(
      'Awa propose et vote oui, Ban vote oui → majorité (2/2) → tontine terminée',
      (_) async {
        // Seed : "Tontine E2E" active, 2 membres acceptés (client@ = Awa, banme@ = Ban)
        // → majorité absolue = 2.
        await loginAs('client@kauri-e2e.com');
        final repo = getIt<TontineRepository>();
        final t = ok(
          await repo.getTontines(),
          'tontines',
        ).firstWhere((t) => t.name == 'Tontine E2E');

        // Le créateur ne peut plus arrêter seul une tontine active.
        expect(
          failureOf(
            await repo.deleteTontine(t.id),
            'suppression tontine active',
          ),
          isNotEmpty,
        );

        final vote = ok(
          await repo.proposeClosure(t.id, durationHours: 24),
          'proposeClosure',
        );
        expect(vote.isClosure && vote.isOpen, isTrue);
        expect(vote.majority, 2);
        expect(
          failureOf(await repo.proposeClosure(t.id), 'double proposition'),
          isNotEmpty,
        );

        final first = ok(await repo.castVote(t.id, vote.id, 0), 'vote Awa');
        expect(first.hasVoted, isTrue);
        expect(first.votersCount, 1);
        expect(first.status, 'open'); // 1 voix < majorité
        expect(
          failureOf(await repo.castVote(t.id, vote.id, 0), 're-vote'),
          isNotEmpty,
        );
        expect(
          ok(
            await repo.getTontineDetails(t.id),
            'details',
          ).status.toLowerCase(),
          'active',
        );

        await loginAs('banme@kauri-e2e.com');
        final listed = ok(await repo.getVotes(t.id), 'votes Ban');
        expect(
          listed.first.hasVoted,
          isFalse,
        ); // "déjà voté" est propre à chaque membre
        final second = ok(await repo.castVote(t.id, vote.id, 0), 'vote Ban');
        expect(second.outcome, 'approved');
        expect(
          ok(
            await repo.getTontineDetails(t.id),
            'details',
          ).status.toLowerCase(),
          'completed',
        );
      },
    );
  });
}
