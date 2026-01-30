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
import '../features/auth/presentation/pages/email_verification_pending_page.dart';
import '../features/auth/presentation/pages/complete_profile_page.dart';
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
import '../features/support/presentation/pages/support_tickets_page.dart';
import '../features/support/presentation/pages/create_ticket_page.dart';
import '../features/support/presentation/pages/ticket_details_page.dart';
import '../features/tontine/presentation/pages/tontine_list_page.dart';
import '../features/tontine/presentation/pages/create_tontine_page.dart';
import '../features/tontine/presentation/pages/tontine_details_page.dart';
import '../features/tontine/presentation/pages/join_tontine_page.dart';
import '../features/tontine/presentation/pages/tontine_guide_page.dart';
import '../features/user_subscriptions/presentation/pages/subscription_list_page.dart';
import '../features/user_subscriptions/presentation/pages/add_subscription_page.dart';
import '../features/user_subscriptions/data/models/subscription_model.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteConstants.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    // Handle kauri scheme deep links
    if (state.uri.scheme == 'kauri') {
      // If the link is kauri://payment/success, GoRouter might see:
      // host: payment, path: /success
      if (state.uri.host == 'payment' && state.uri.path == '/success') {
        return '${RouteConstants.paymentSuccess}?${state.uri.query}';
      }
      // If the link is kauri://tontines/join?code=XYZ
      if ((state.uri.host == 'tontines' && state.uri.path == '/join') ||
          state.uri.path == '/tontines/join') {
        return '${RouteConstants.joinTontine}?${state.uri.query}';
      }
      // If the link is kauri://reset-password?token=XYZ
      if (state.uri.host == 'reset-password') {
        return '${RouteConstants.resetPassword}?${state.uri.query}';
      }
      // If the link is kauri://share/goal?data=XYZ
      if (state.uri.host == 'share' && state.uri.path == '/goal') {
        return '${RouteConstants.shareGoal}?${state.uri.query}';
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
      path: RouteConstants.emailVerificationPending,
      builder: (context, state) => const EmailVerificationPendingPage(),
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
      builder: (context, state) {
        final isLinking = state.extra as bool? ?? false;
        return PhoneLoginPage(isLinking: isLinking);
      },
    ),
    GoRoute(
      path: RouteConstants.otpVerification,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return OtpVerificationPage(
          phoneNumber: extras['phoneNumber'] as String,
          countryCode: extras['countryCode'] as String?,
          verificationId: extras['verificationId'] as String,
          isLinking: extras['isLinking'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: RouteConstants.onBoarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: RouteConstants.completeProfile,
      builder: (context, state) => const CompleteProfilePage(),
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
    GoRoute(
      path: RouteConstants.supportTickets,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SupportTicketsPage(),
      ),
      routes: [
        GoRoute(
          path: 'create',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const CreateTicketPage(),
          ),
        ),
        GoRoute(
          path: ':id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: TicketDetailsPage(ticketId: id),
            );
          },
        ),
      ],
    ),

    // Tontine Routes
    GoRoute(
      path: RouteConstants.tontines,
      name: RouteConstants.tontineListNamed,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const TontineListPage(),
      ),
      routes: [
        GoRoute(
          path: 'create',
          name: RouteConstants.tontineCreateNamed,
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const CreateTontinePage(),
          ),
        ),
        GoRoute(
          path: 'join',
          name: RouteConstants.tontineJoinNamed,
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const JoinTontinePage(),
          ),
        ),
        GoRoute(
          path: 'guide',
          name: RouteConstants.tontineGuideNamed,
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const TontineGuidePage(),
          ),
        ),
        GoRoute(
          path: ':id([a-fA-F0-9]{24})',
          name: RouteConstants.tontineDetailsNamed,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: TontineDetailsPage(tontineId: id),
            );
          },
        ),
      ],
    ),
    // User Subscriptions
    GoRoute(
      path: RouteConstants.userSubscriptions,
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
        context: context,
        state: state,
        child: const SubscriptionListPage(),
      ),
      routes: [
        GoRoute(
          path: 'add',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AddSubscriptionPage(),
          ),
        ),
        GoRoute(
          path: ':id',
          pageBuilder: (context, state) {
            final subscription = state.extra as SubscriptionModel?;
            return buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: AddSubscriptionPage(subscription: subscription),
            );
          },
        ),
      ],
    ),
  ],
);
