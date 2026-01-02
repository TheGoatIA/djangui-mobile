import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteConstants.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteConstants.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteConstants.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteConstants.onBoarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: RouteConstants.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
