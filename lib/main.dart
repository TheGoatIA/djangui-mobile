import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For PlatformDispatcher
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:freerasp/freerasp.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'core/services/telemetry_service.dart';
import 'core/services/log_service.dart';
import 'core/services/tutorial_service.dart';

import 'di/injection.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_type.dart';
import 'core/services/notification_service.dart';
import 'core/services/sync_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/goals/presentation/bloc/goals_bloc.dart';
import 'features/goals/presentation/bloc/goals_event.dart';
import 'features/transactions/presentation/bloc/transactions_bloc.dart';
import 'features/budgets/presentation/bloc/budgets_bloc.dart';
import 'features/budgets/presentation/bloc/budgets_event.dart';
import 'features/challenges/presentation/bloc/challenges_bloc.dart';
import 'features/challenges/presentation/bloc/challenges_event.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/support/presentation/bloc/support_bloc.dart';
import 'features/system/presentation/bloc/system_bloc.dart';
import 'features/tontine/presentation/bloc/tontine_bloc.dart';
import 'features/tontine/presentation/bloc/tontine_event.dart';
import 'features/user_subscriptions/presentation/bloc/subscription_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_bloc.dart';
import 'package:kauri/features/payments/presentation/bloc/fintech_event.dart';
import 'package:kauri/features/payments/presentation/bloc/payment_bloc.dart';
import 'features/analytics/presentation/manager/analytics_manager.dart';
import 'package:showcaseview/showcaseview.dart';

/// Point d'entrée principal de l'application Kauri.
///
/// Initialise les services critiques :
/// - Firebase (Analytique, Crashlytics, Messaging)
/// - Injection de dépendances (GetIt)
/// - Services de notifications, analytique et synchronisation offline
void main() async {
  final startTime = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase avec les options par défaut générées
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Capture automatique des erreurs fatales Flutter par Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Chargement des variables d'environnement (API keys, etc.)
  await dotenv.load(fileName: ".env");

  // Configuration du conteneur d'injection de dépendances
  await configureDependencies();

  // Initialisation des services globaux via GetIt
  await getIt<NotificationService>().initialize();
  await getIt<AnalyticsManager>().initialize();
  getIt<SyncService>()
      .initialize(); // Démarre l'écouteur de synchronisation au réseau
  final telemetry = getIt<TelemetryService>();
  await telemetry.initialize();
  await telemetry.recordDatabaseSize();

  // Telemetry: Startup Time
  final startupDuration = DateTime.now().difference(startTime).inMilliseconds;
  telemetry.recordEvent('app.startup', {
    'duration_ms': startupDuration,
    'type': 'cold_start',
  });

  // 1. Global Flutter Error Handling (Red Screen)
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);

    // Telemetry Record
    telemetry.recordEvent('app.error.flutter', {
      'exception': details.exception.toString(),
      'library': details.library ?? 'unknown',
      'context': details.context.toString(),
    });

    // Graylog: Crash reporting
    getIt<LogService>().error(
      'Flutter Error: ${details.exception}',
      error: details.exception,
      stackTrace: details.stack,
      component: 'Application',
      metadata: {
        'library': details.library,
        'context': details.context.toString(),
      },
    );
  };

  // 2. Async Platform Errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

    telemetry.recordEvent('app.error.platform', {
      'exception': error.toString(),
    });

    // Graylog: Platform crash reporting
    getIt<LogService>().error(
      'Platform Error: $error',
      error: error,
      stackTrace: stack,
      component: 'Application',
    );
    return true;
  };

  // 3. Initialize Security (RASP for Root/Jailbreak detection)
  _initSecurity();

  runApp(const MyApp());
}

/// Initialise FreeRASP pour la protection contre le Root, Jailbreak, et reverse engineering.
void _initSecurity() {
  final config = TalsecConfig(
    androidConfig: AndroidConfig(
      packageName: 'cm.tbg.kauri',
      signingCertHashes: [
        'KP80SjUrE0o/lnpaTdCsOx08tU6FiqYs1wzpYAmq7kI=',
        '3E+Ve5dRvcI0bBFPyES/rAWihY26wtv+GA+n1kde27g=',
        'N20fULlCwExrbzhjXOh7WoLcg6r748TTfm2PFCMKUBk=',
        'muX3GfLwAWSuz6plV7sgYwKlaB1kK3pGqavGKdc4/uM=',
      ],
      supportedStores: [],
    ),
    iosConfig: IOSConfig(
      bundleIds: ['cm.tbg.kauri'],
      teamId: '738JXF4C4C', // Replace with actual Apple Team ID
    ),
    watcherMail: 'me@borisgauty.com',
    isProd: kReleaseMode,
  );

  final callback = ThreatCallback(
    onAppIntegrity: () => _handleThreat('App Integrity Compromised'),
    onObfuscationIssues: () => _handleThreat('Obfuscation Issues'),
    onDebug: () => _handleThreat('Debugging Detected'),
    onDeviceBinding: () => _handleThreat('Device Binding Failed'),
    onDeviceID: () => _handleThreat('Device ID Spoofing'),
    onHooks: () => _handleThreat('Hooks Detected'),
    onPrivilegedAccess: () => _handleThreat('Root/Jailbreak Detected'),
    onSecureHardwareNotAvailable: () =>
        _handleThreat('Secure Hardware Not Available'),
    onSimulator: () => _handleThreat('Simulator/Emulator Detected'),
    onUnofficialStore: () => _handleThreat('Unofficial Store Install'),
  );

  Talsec.instance.attachListener(callback);
  try {
    Talsec.instance.start(config);
  } catch (e) {
    getIt<LogService>().error(
      'FreeRASP initialization failed',
      error: e,
      component: 'Security',
    );
  }
}

void _handleThreat(String threat) {
  final logger = getIt<LogService>();
  logger.warning('SECURITY THREAT DETECTED: $threat', component: 'Security');
  if (kReleaseMode) {
    // In production, force close the app to protect financial data
    exit(0);
  }
}

/// Widget racine de l'application.
///
/// Responsable de :
/// - La gestion globale de l'état (MultiBlocProvider)
/// - La configuration du thème (Clair/Sombre) via SettingsBloc
/// - La navigation (GoRouter) via appRouter
/// - La localisation (Internationalisation)
/// - L'observation du cycle de vie pour l'analytique
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DateTime? _sessionStartTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionStartTime = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Observe les changements d'état de l'application pour gérer les sessions analytiques.
  @override
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final telemetry = getIt<TelemetryService>();

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      getIt<AnalyticsManager>().endCurrentSession();

      // Telemetry: Session Duration (Prometheus Gauge)
      if (_sessionStartTime != null) {
        final duration = DateTime.now()
            .difference(_sessionStartTime!)
            .inSeconds;
        telemetry.recordGauge(
          'app.session.duration_seconds',
          duration.toDouble(),
        );

        // Also keep the event for detailed trace analysis
        telemetry.recordEvent('app.session', {
          'state': 'ended',
          'duration_seconds': duration,
        });
      }
      _sessionStartTime = null;
    } else if (state == AppLifecycleState.resumed) {
      getIt<AnalyticsManager>().startNewSession();
      _sessionStartTime = DateTime.now();

      // Refresh financial data when returning to the app (e.g., after a payment)
      if (mounted) {
        context.read<FintechBloc>().add(FetchWalletBalance());
        context.read<DashboardBloc>().add(GetDashboardDataRequested());
      }

      // Telemetry: Session Start (Prometheus Count)
      telemetry.recordCount('app.session.total', 1);
      telemetry.recordGauge(
        'app.user.active',
        1.0,
      ); // Marks the user as active now

      // Also keep the event
      telemetry.recordEvent('app.session', {'state': 'started'});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Injection des Blocs globaux nécessaires dès le lancement
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SettingsBloc>()..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<GoalsBloc>()..add(const GetGoalsRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<TransactionsBloc>()..add(const GetTransactionsRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<BudgetsBloc>()..add(const GetBudgetsRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<ChallengesBloc>()..add(const GetChallengesRequested()),
        ),
        BlocProvider(create: (context) => getIt<SupportBloc>()),
        BlocProvider(
          create: (context) => getIt<SystemBloc>()
            ..add(GetPublicSettingsRequested())
            ..add(GetCountriesRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<TontineBloc>()..add(TontinesLoadRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<SubscriptionBloc>()..add(GetSubscriptionsRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<NotificationsBloc>()..add(FetchUnreadCountRequested()),
        ),
        BlocProvider(
          create: (context) => getIt<FintechBloc>()..add(FetchWalletBalance()),
        ),
        BlocProvider(create: (context) => getIt<PaymentBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return BlocListener<AuthBloc, AuthState>(
            // Actualise les données si le pays de l'utilisateur change (devise, frais, etc.)
            // OU si l'utilisateur se déconnecte pour vider le cache en mémoire
            listenWhen: (previous, current) {
              final prevCountry = previous.authResponse?.user.country;
              final currCountry = current.authResponse?.user.country;
              final isCountryChanged =
                  prevCountry != currCountry && currCountry != null;
              final isLoggedOut =
                  previous.status == AuthStatus.authenticated &&
                  current.status == AuthStatus.unauthenticated;
              return isCountryChanged || isLoggedOut;
            },
            listener: (context, authState) {
              if (authState.status == AuthStatus.unauthenticated) {
                // Vider les données utilisateur en mémoire lors de la déconnexion
                context.read<FintechBloc>().add(ClearFintechData());
                // Ideallement, chaque bloc de données devrait avoir un event 'ClearData' ou on relance Fetch sans compte
              } else {
                // Rafraîchir les données pour le nouveau compte / pays
                context.read<TransactionsBloc>().add(
                  const GetTransactionsRequested(forceRefresh: true),
                );
                context.read<GoalsBloc>().add(
                  const GetGoalsRequested(forceRefresh: true),
                );
                context.read<BudgetsBloc>().add(
                  const GetBudgetsRequested(forceRefresh: true),
                );
                context.read<ChallengesBloc>().add(
                  const GetChallengesRequested(forceRefresh: true),
                );
                context.read<ChallengesBloc>().add(
                  GetUserChallengesRequested(),
                );
                context.read<FintechBloc>().add(FetchWalletBalance());
              }
            },
            child: ChangeNotifierProvider.value(
              value: getIt<TutorialService>(),
              child: ShowCaseWidget(
                builder: (context) {
                  final authState = context.watch<AuthBloc>().state;
                  final isPremium =
                      authState.authResponse?.user.isPremium ?? false;

                  // Fallback pour le thème si l'utilisateur n'est plus Premium
                  final effectiveThemeType =
                      (isPremium || !state.themeType.isPremiumOnly)
                      ? state.themeType
                      : AppThemeType.system;

                  // Fallback pour la police si l'utilisateur n'est plus Premium
                  final effectiveFontFamily =
                      (isPremium || state.fontFamily == 'Outfit')
                      ? state.fontFamily
                      : 'Outfit';

                  return MaterialApp.router(
                    title: 'Kauri',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme(effectiveFontFamily),
                    darkTheme: switch (effectiveThemeType) {
                      AppThemeType.obsidianGold => AppTheme.obsidianGoldTheme(
                        effectiveFontFamily,
                      ),
                      AppThemeType.polarNight => AppTheme.polarNightTheme(
                        effectiveFontFamily,
                      ),
                      AppThemeType.sunsetGlow => AppTheme.sunsetGlowTheme(
                        effectiveFontFamily,
                      ),
                      AppThemeType.emeraldForest => AppTheme.emeraldForestTheme(
                        effectiveFontFamily,
                      ),
                      AppThemeType.midnightRoyal => AppTheme.midnightRoyalTheme(
                        effectiveFontFamily,
                      ),
                      _ => AppTheme.darkTheme(effectiveFontFamily),
                    },
                    themeMode: effectiveThemeType.toThemeMode,
                    locale: state.locale,
                    routerConfig: appRouter,
                    builder: (context, child) => child!,
                    // Configuration de l'internationalisation
                    localizationsDelegates: [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
