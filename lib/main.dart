import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'core/services/tutorial_service.dart';

import 'di/injection.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';
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
import 'features/support/presentation/bloc/support_bloc.dart';
import 'features/system/presentation/bloc/system_bloc.dart';
import 'features/tontine/presentation/bloc/tontine_bloc.dart';
import 'features/tontine/presentation/bloc/tontine_event.dart';
import 'features/user_subscriptions/presentation/bloc/subscription_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/analytics/presentation/manager/analytics_manager.dart';
import 'package:showcaseview/showcaseview.dart';

/// Point d'entrée principal de l'application Kauri.
///
/// Initialise les services critiques :
/// - Firebase (Analytique, Crashlytics, Messaging)
/// - Injection de dépendances (GetIt)
/// - Services de notifications, analytique et synchronisation offline
void main() async {
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

  runApp(const MyApp());
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Observe les changements d'état de l'application pour gérer les sessions analytiques.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      getIt<AnalyticsManager>().endCurrentSession();
    } else if (state == AppLifecycleState.resumed) {
      getIt<AnalyticsManager>().startNewSession();
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
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return BlocListener<AuthBloc, AuthState>(
            // Actualise les données si le pays de l'utilisateur change (devise, frais, etc.)
            listenWhen: (previous, current) {
              final prevCountry = previous.authResponse?.user.country;
              final currCountry = current.authResponse?.user.country;
              return prevCountry != currCountry && currCountry != null;
            },
            listener: (context, authState) {
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
              context.read<ChallengesBloc>().add(GetUserChallengesRequested());
            },
            child: ChangeNotifierProvider.value(
              value: getIt<TutorialService>(),
              child: ShowCaseWidget(
                builder: (context) => MaterialApp.router(
                  title: 'Kauri',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: state.themeMode,
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
