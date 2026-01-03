import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/transactions/presentation/pages/transaction_list_page.dart';
import '../features/transactions/presentation/pages/add_transaction_page.dart';
import '../features/budgets/presentation/pages/budget_list_page.dart';
import '../features/budgets/presentation/pages/add_budget_page.dart';
import '../features/goals/presentation/pages/goal_list_page.dart';
import '../features/goals/presentation/pages/add_goal_page.dart';
import '../features/investments/presentation/pages/investments_page.dart';
import '../features/investments/presentation/pages/add_investment_page.dart';
import '../features/challenges/presentation/pages/challenges_page.dart';
import '../features/coach/presentation/pages/coach_chat_page.dart';
import '../features/insights/presentation/pages/insights_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/subscription/presentation/pages/subscription_page.dart';

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
    GoRoute(
      path: RouteConstants.transactions,
      builder: (context, state) => const TransactionListPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddTransactionPage(),
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.budgets,
      builder: (context, state) => const BudgetListPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddBudgetPage(),
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.goals,
      builder: (context, state) => const GoalListPage(),
      routes: [
        GoRoute(path: 'add', builder: (context, state) => const AddGoalPage()),
      ],
    ),
    GoRoute(
      path: RouteConstants.investments,
      builder: (context, state) => const InvestmentsPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddInvestmentPage(),
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.challenges,
      builder: (context, state) => const ChallengesPage(),
    ),
    GoRoute(
      path: RouteConstants.coach,
      builder: (context, state) => const CoachChatPage(),
    ),
    GoRoute(
      path: RouteConstants.insights,
      builder: (context, state) => const InsightsPage(),
    ),
    GoRoute(
      path: RouteConstants.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: RouteConstants.subscription,
      builder: (context, state) => const SubscriptionPage(),
    ),
  ],
);
