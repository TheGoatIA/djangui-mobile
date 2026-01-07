import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../core/widgets/scaffold_with_navbar.dart';
import '../core/widgets/custom_page_transition.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/reset_password_page.dart';
import '../features/auth/presentation/pages/phone_login_page.dart';
import '../features/auth/presentation/pages/otp_verification_page.dart';
import '../features/goals/presentation/pages/goal_import_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/transactions/presentation/pages/transaction_list_page.dart';
import '../features/transactions/presentation/pages/add_transaction_page.dart';
import '../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../features/transactions/data/models/transaction_model.dart';
import '../features/budgets/presentation/pages/budget_list_page.dart';
import '../features/budgets/presentation/pages/add_budget_page.dart';
import '../features/goals/presentation/pages/goal_list_page.dart';
import '../features/goals/presentation/pages/add_goal_page.dart';
import '../features/goals/presentation/pages/goal_detail_page.dart';
import '../features/investments/presentation/pages/investments_page.dart';
import '../features/investments/presentation/pages/add_investment_page.dart';
import '../features/challenges/presentation/pages/challenges_page.dart';
import '../features/coach/presentation/pages/coach_chat_page.dart';
import '../features/insights/presentation/pages/insights_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/subscription/presentation/pages/subscription_page.dart';
import '../features/settings/presentation/pages/about_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/auth/presentation/pages/security_page.dart';
import '../features/auth/presentation/pages/change_password_page.dart';
import '../features/auth/presentation/pages/sessions_page.dart';
import '../features/subscription/presentation/pages/payment_success_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteConstants.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    // Handle djangui scheme deep links
    if (state.uri.scheme == 'djangui') {
      // If the link is djangui://payment/success, GoRouter might see:
      // host: payment, path: /success
      if (state.uri.host == 'payment' && state.uri.path == '/success') {
        return '${RouteConstants.paymentSuccess}?${state.uri.query}';
      }
      // If the link is djangui://somehost/payment/success
      // path: /payment/success
      if (state.uri.path == '/payment/success') {
        return '${RouteConstants.paymentSuccess}?${state.uri.query}';
      }
    }
    return null;
  },
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
      path: RouteConstants.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: RouteConstants.resetPassword,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return ResetPasswordPage(token: token);
      },
    ),
    GoRoute(
      path: RouteConstants.shareGoal,
      builder: (context, state) {
        final data = state.uri.queryParameters['data'] ?? '';
        return GoalImportPage(dataToken: data);
      },
    ),
    GoRoute(
      path: RouteConstants.phoneLogin,
      builder: (context, state) => const PhoneLoginPage(),
    ),
    GoRoute(
      path: RouteConstants.otpVerification,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return OtpVerificationPage(
          phoneNumber: extras['phoneNumber'] as String,
          verificationId: extras['verificationId'] as String,
          isLinking: extras['isLinking'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: RouteConstants.onBoarding,
      builder: (context, state) => const OnboardingPage(),
    ),

    // StatefulShellRoute for Main Tab Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),

        // Branch 1: Challenges
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.challenges,
              builder: (context, state) => const ChallengesPage(),
            ),
          ],
        ),

        // Branch 2: Budgets
        StatefulShellBranch(
          routes: [
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
          ],
        ),

        // Branch 3: Goals
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.goals,
              name: 'goals',
              builder: (context, state) => const GoalListPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'goal-add',
                  builder: (context, state) => const AddGoalPage(),
                ),
                GoRoute(
                  path: ':id',
                  name: 'goal-details',
                  builder: (context, state) {
                    final goalId = state.pathParameters['id']!;
                    return GoalDetailPage(goalId: goalId);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteConstants.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // Independent Routes (Full Screen)
    GoRoute(
      path: RouteConstants.transactions,
      name: 'transactions',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const TransactionListPage(),
      ),
      routes: [
        GoRoute(
          path: 'add',
          pageBuilder: (context, state) {
            final goalId = state.extra as String?;
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: AddTransactionPage(initialGoalId: goalId),
            );
          },
        ),
        GoRoute(
          path: ':id',
          name: RouteConstants.transactionDetails,
          pageBuilder: (context, state) {
            final transaction = state.extra as TransactionModel;
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: TransactionDetailPage(transaction: transaction),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.investments,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const InvestmentsPage(),
      ),
      routes: [
        GoRoute(
          path: 'add',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AddInvestmentPage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RouteConstants.coach,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const CoachChatPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.insights,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const InsightsPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.subscription,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SubscriptionPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.about,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const AboutPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.notifications,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const NotificationsPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.security,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SecurityPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.changePassword,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const ChangePasswordPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.sessions,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SessionsPage(),
      ),
    ),
    GoRoute(
      path: RouteConstants.paymentSuccess,
      pageBuilder: (context, state) {
        final ref = state.uri.queryParameters['ref'];
        final status = state.uri.queryParameters['status'];
        return buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: PaymentSuccessPage(ref: ref, status: status),
        );
      },
    ),
  ],
);
