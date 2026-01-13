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
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await dotenv.load(fileName: ".env");
  await configureDependencies();
  await getIt<NotificationService>().initialize();
  getIt<SyncService>().initialize(); // Start sync listener
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return BlocListener<AuthBloc, AuthState>(
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
                  builder: (context, child) =>
                      ShowCaseWidget(builder: (context) => child!),
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
