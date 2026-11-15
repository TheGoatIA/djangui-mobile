// Boîte à outils des parcours utilisateur (integration_test/journeys/*).
//
// Le "robot" agit comme un vrai utilisateur : il cherche les champs par leur
// LIBELLÉ affiché, tape au doigt sur les textes visibles, attend les réponses
// réseau réelles, vérifie toasts (SnackBar) et popups (AlertDialog), et
// CHRONOMÈTRE chaque action (de l'appui jusqu'au résultat visible).
// Un rapport de performance (temps de réponse + fluidité des images) est
// imprimé à la fin de chaque fichier (lignes `PERF|…` et `FRAMES|…`).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kauri/core/config/env_config.dart';
import 'package:kauri/main.dart' as app;
import 'package:kauri/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const e2ePassword = 'E2e-Passw0rd!';

/// Budgets de temps de réponse (émulateur + API locale). Au-delà, l'action est
/// signalée LENTE dans le rapport ; au-delà de [hardLimit] le test échoue.
const Duration softBudget = Duration(milliseconds: 2500);
const Duration hardLimit = Duration(seconds: 12);

class PerfEntry {
  final String name;
  final int ms;
  PerfEntry(this.name, this.ms);
}

final List<PerfEntry> perfLog = [];
final List<FrameTiming> _frames = [];
bool _bootstrapped = false;
bool _surfaceConverted = false;

/// Initialise l'app UNE fois (Firebase, DI, …), sans télémétrie depuis les tests.
Future<void> bootstrapOnce() async {
  if (_bootstrapped) return;
  expect(
    EnvConfig.apiBaseUrl,
    contains(':5055'),
    reason: 'Parcours E2E : uniquement contre l\'API locale de test (seedée).',
  );
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.setBool('hasSeenOnboarding', true);
  // Les tutoriels sont testés à part ; ici on teste les fonctionnalités.
  // Clés réelles (grep startTutorial / hasSeenTutorial dans lib/).
  for (final k in const [
    'add_budget',
    'add_goal',
    'add_master_account',
    'add_transaction',
    'budgets',
    'challenges',
    'coach',
    'create_tontine',
    'dashboard_v2',
    'goal_detail',
    'goals',
    'insights',
    'investments',
    'profile',
    'real_money_welcome',
    'reseller_hub',
    'security',
    'subscription',
    'subscriptions',
    'tontine_details',
    'tontines_v2',
    'transactions',
    'wallet_recharge',
  ]) {
    await prefs.setBool('tutorial_seen_$k', true);
  }
  await app.bootstrap();
  SchedulerBinding.instance.addTimingsCallback(_frames.addAll);
  _bootstrapped = true;
}

/// Imprime le rapport de performance (temps de réponse + fluidité).
void printPerfReport(String suite) {
  debugPrint('================ PERF $suite ================');
  for (final e in perfLog) {
    final flag = e.ms > softBudget.inMilliseconds ? 'LENT' : 'ok';
    debugPrint('PERF|$suite|${e.name}|${e.ms}ms|$flag');
  }
  if (_frames.isNotEmpty) {
    final total = _frames.map((f) => f.totalSpan.inMicroseconds / 1000).toList()
      ..sort();
    final janky = total.where((ms) => ms > 16.7).length;
    final p90 = total[(total.length * 0.9).floor().clamp(0, total.length - 1)];
    final worst = total.last;
    debugPrint(
      'FRAMES|$suite|frames=${total.length}|>16ms=$janky '
      '(${(100 * janky / total.length).toStringAsFixed(1)}%)|p90=${p90.toStringAsFixed(1)}ms|'
      'max=${worst.toStringAsFixed(1)}ms',
    );
  }
  perfLog.clear();
  _frames.clear();
}

class Robot {
  final WidgetTester tester;
  Robot(this.tester);

  // ---------------------------------------------------------------- temps
  Future<void> settle([double seconds = 1]) async {
    final steps = (seconds * 10).round();
    for (var i = 0; i < steps; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Attend [finder] ; renvoie le temps écoulé. Échoue après [timeout] — avec
  /// une capture de l'écran (envoyée à l'hôte, cf. shot-server) pour comprendre.
  Future<int> waitFor(
    Finder finder, {
    Duration timeout = hardLimit,
    String? why,
  }) async {
    final sw = Stopwatch()..start();
    while (sw.elapsed < timeout) {
      if (finder.evaluate().isNotEmpty) return sw.elapsedMilliseconds;
      await tester.pump(const Duration(milliseconds: 100));
    }
    await failureShot(why ?? 'attendu');
    fail(
      '${why ?? 'Attendu'} — introuvable après ${timeout.inSeconds}s : $finder',
    );
  }

  /// Capture d'écran d'échec → hôte (10.0.2.2:5099), sans jamais masquer l'échec.
  Future<void> failureShot(String label) async {
    try {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;
      if (!_surfaceConverted) {
        await binding.convertFlutterSurfaceToImage();
        _surfaceConverted = true;
      }
      await tester.pump(const Duration(milliseconds: 200));
      final bytes = await binding.takeScreenshot('echec');
      final name =
          'ECHEC_${DateTime.now().millisecondsSinceEpoch}_${label.replaceAll(RegExp(r'[^\w]+'), '_')}';
      final client = HttpClient();
      final req = await client.post('10.0.2.2', 5099, '/$name');
      req.add(bytes);
      await (await req.close()).drain<void>();
      client.close();
      debugPrint('📸 capture d\'échec : $name.png');
    } catch (e) {
      debugPrint('capture d\'échec impossible : $e');
    }
  }

  Future<void> waitGone(Finder finder, {Duration timeout = hardLimit}) async {
    final sw = Stopwatch()..start();
    while (sw.elapsed < timeout) {
      if (finder.evaluate().isEmpty) return;
      await tester.pump(const Duration(milliseconds: 100));
    }
    fail('Toujours affiché après ${timeout.inSeconds}s : $finder');
  }

  /// Exécute [action] puis attend [until] : enregistre le temps de réponse
  /// perçu par l'utilisateur sous [name].
  Future<int> measure(
    String name,
    Future<void> Function() action,
    Finder until, {
    Duration timeout = hardLimit,
  }) async {
    // Un toast précédent encore affiché fausserait la mesure du suivant.
    await clearToasts();
    final sw = Stopwatch()..start();
    await action();
    await waitFor(until, timeout: timeout, why: name);
    final ms = sw.elapsedMilliseconds;
    perfLog.add(PerfEntry(name, ms));
    debugPrint('⏱️ $name : ${ms}ms');
    return ms;
  }

  // ---------------------------------------------------------------- app
  Future<void> launch() async {
    await tester.pumpWidget(const app.MyApp());
    await settle(2);
  }

  Future<void> go(String route, {Finder? until}) async {
    appRouter.go(route);
    await settle(0.5);
    if (until != null) await waitFor(until, why: 'écran $route');
    await settle(0.5);
    await dismissTutorial();
    healthy(route);
  }

  Future<void> dismissTutorial() async {
    for (var i = 0; i < 4; i++) {
      final skip = find.byWidgetPredicate(
        (w) => w is Text && (w.data == 'Passer' || w.data == 'Skip'),
      );
      if (skip.evaluate().isEmpty) return;
      await tester.tap(skip.first, warnIfMissed: false);
      await settle(0.6);
    }
  }

  /// Aucun écran d'erreur Flutter, aucune exception non gérée (y compris les
  /// débordements de mise en page « RenderFlex overflowed »).
  void healthy(String where) {
    // Les exceptions ne sont PAS « avalées » ici : le framework de test les
    // signale à la fin du test avec leur pile d'appels complète (diagnostic).
    expect(
      find.byType(ErrorWidget),
      findsNothing,
      reason: '$where : écran d\'erreur affiché',
    );
    debugPrint('✅ $where');
  }

  // ---------------------------------------------------------------- gestes
  Future<void> tap(Finder f, {bool scroll = true}) async {
    await waitFor(f, why: 'élément à toucher');
    // Comme un humain : seulement ce qui est réellement visible et touchable
    // (un Stepper/IndexedStack garde des widgets cachés dans l'arbre).
    for (var attempt = 0; attempt < 5; attempt++) {
      // Éléments résolus UNE fois (un Finder `.first` réévalué plus tard peut
      // être vide si l'écran s'est reconstruit : micro → bouton envoyer…).
      final hits = f.hitTestable().evaluate().toList();
      final all = f.evaluate().toList();
      final element = hits.isNotEmpty
          ? hits.first
          : (all.isNotEmpty ? all.first : null);
      if (element == null) {
        await tester.pump(const Duration(milliseconds: 200));
        continue;
      }
      if (scroll && hits.isEmpty) {
        try {
          await Scrollable.ensureVisible(element);
          await tester.pump(const Duration(milliseconds: 150));
        } catch (_) {}
      }
      final box = element.renderObject;
      if (box is! RenderBox || !box.attached || !box.hasSize) {
        await tester.pump(const Duration(milliseconds: 200));
        continue;
      }
      await tester.tapAt(box.localToGlobal(box.size.center(Offset.zero)));
      await tester.pump(const Duration(milliseconds: 100));
      return;
    }
    await failureShot('element_disparu');
    fail('Élément disparu avant l\'appui : $f');
  }

  Future<void> tapText(String text, {bool last = false}) async {
    final f = find.text(text);
    await waitFor(f, why: 'texte "$text"');
    final visible = f.hitTestable();
    final pool = visible.evaluate().isNotEmpty ? visible : f;
    final target = last ? pool.last : pool.first;
    await ensureVisible(target);
    await tester.tap(target, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> ensureVisible(Finder f) async {
    try {
      await tester.ensureVisible(f);
      await tester.pump(const Duration(milliseconds: 100));
    } catch (_) {
      /* pas dans un scrollable : déjà visible */
    }
  }

  /// Champ de saisie identifié par son libellé visible : AppTextField
  /// (libellé au-dessus) ou InputDecoration.labelText.
  Finder field(String label) {
    Finder search(Finder Function(Finder) within) {
      final byDecoration = within(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              (w.decoration?.labelText == label ||
                  w.decoration?.hintText == label),
        ),
      );
      if (byDecoration.evaluate().isNotEmpty) return byDecoration;
      // AppTextField : libellé (Text) au-dessus du champ, dans la même Column.
      // Pas de `.first` ici : un Finder vide doit rester vide (waitFor patiente).
      final labelText = within(find.text(label));
      final column = find.ancestor(
        of: labelText,
        matching: find.byType(Column),
      );
      return find.descendant(of: column, matching: find.byType(TextField));
    }

    // Un popup ouvert est prioritaire : la page derrière peut contenir le même
    // libellé (ex. section « Montant » d'un objectif + champ « Montant » du popup).
    if (dialog().evaluate().isNotEmpty) {
      final inDialog = search(
        (f) => find.descendant(of: dialog(), matching: f),
      );
      if (inDialog.evaluate().isNotEmpty) return inDialog;
    }
    return search((f) => f);
  }

  Future<void> fill(String label, String value) async {
    final f = field(label);
    await waitFor(f, why: 'champ "$label"');
    await ensureVisible(f.first);
    await tester.tap(f.first, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.enterText(f.first, value);
    await tester.pump(const Duration(milliseconds: 100));
    // En mode profile, la saisie simulée peut ne pas atteindre le champ :
    // on écrit alors directement dans son contrôleur.
    final tf = tester.widget<TextField>(f.first);
    if (tf.controller != null && tf.controller!.text != value) {
      tf.controller!.text = value;
      tf.onChanged?.call(value);
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> hideKeyboard() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await settle(0.4);
  }

  /// Ouvre une liste déroulante (par son libellé) et choisit [item].
  Future<void> choose(String label, String item) async {
    final dd = find.ancestor(
      of: find.text(label),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final target = dd.evaluate().isNotEmpty ? dd.first : find.text(label).first;
    await ensureVisible(target);
    await tester.tap(target, warnIfMissed: false);
    await settle(0.6);
    await tester.tap(find.text(item).last, warnIfMissed: false);
    await settle(0.6);
  }

  // ---------------------------------------------------------------- retours
  Finder toast(String textPart) => find.descendant(
    of: find.byType(SnackBar),
    matching: find.textContaining(textPart),
  );

  Future<void> expectToast(String textPart, {String? why}) =>
      waitFor(toast(textPart), why: why ?? 'toast "$textPart"');

  Future<void> clearToasts() async {
    final ctx = find.byType(Scaffold).evaluate();
    if (ctx.isNotEmpty) {
      ScaffoldMessenger.maybeOf(ctx.first)?.clearSnackBars();
    }
    await settle(0.4);
  }

  Finder dialog() =>
      find.byWidgetPredicate((w) => w is AlertDialog || w is Dialog);

  Future<void> expectDialog(String textPart) async {
    await waitFor(
      find.descendant(of: dialog(), matching: find.textContaining(textPart)),
      why: 'popup contenant "$textPart"',
    );
  }

  /// Touche un bouton DANS le popup ouvert.
  Future<void> dialogTap(String button) async {
    final b = find.descendant(of: dialog(), matching: find.text(button));
    await waitFor(b, why: 'bouton "$button" du popup');
    await tester.tap(b.last, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Texte d'erreur de validation de formulaire visible.
  Future<void> expectFieldError(String text) =>
      waitFor(find.text(text), why: 'erreur de champ "$text"');

  // ---------------------------------------------------------------- auth
  Future<void> loginUi(String email, {String password = e2ePassword}) async {
    await waitFor(find.byType(TextFormField), why: 'écran de connexion');
    await fill('E-mail', email);
    await fill('Mot de passe', password);
    await hideKeyboard();
    await measure(
      'connexion',
      () => tapText('Se connecter', last: true),
      find.byType(NavigationBar),
      timeout: const Duration(seconds: 25),
    );
    await settle(1.5);
    await dismissTutorial();
    healthy('après connexion');
  }

  /// Déconnexion par l'écran Profil (popup de confirmation compris).
  Future<void> logoutUi() async {
    await go('/profile', until: find.text('Déconnexion'));
    await tapText('Déconnexion');
    await expectDialog('Êtes-vous sûr de vouloir vous déconnecter ?');
    await measure(
      'déconnexion',
      () => dialogTap('Déconnexion'),
      find.text('Se connecter'),
    );
    await settle(1);
  }
}
