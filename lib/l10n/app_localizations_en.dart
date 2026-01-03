// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Djangui';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'No account yet? Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get goals => 'Goals';

  @override
  String get challenges => 'Challenges';

  @override
  String get coach => 'AI Coach';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get recentActivities => 'Recent Activities';

  @override
  String get noRecentActivities => 'No recent activities';

  @override
  String get seeAll => 'See All';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get category => 'Category';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get save => 'Save';

  @override
  String get onboardingTitle1 => 'Welcome to Djangui';

  @override
  String get onboardingDesc1 =>
      'The modern solution to manage your tontines and save together securely.';

  @override
  String get onboardingTitle2 => 'Collective Savings';

  @override
  String get onboardingDesc2 =>
      'Create or join tontines with your loved ones and track contributions in real-time.';

  @override
  String get onboardingTitle3 => 'Maximum Security';

  @override
  String get onboardingDesc3 =>
      'Your funds are protected and every transaction is transparent for all members.';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get next => 'Next';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Login to manage your digitized tontine.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get enterEmailError => 'Please enter your email';

  @override
  String get invalidEmailError => 'Please enter a valid email';

  @override
  String get enterPasswordError => 'Please enter your password';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get genericError => 'An error occurred';

  @override
  String get noAccountQuestion => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get registerSubtitle => 'Join Djangui and start saving smartly.';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'John';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Doe';

  @override
  String get requiredField => 'Field required';

  @override
  String get alreadyHaveAccountQuestion => 'Already have an account?';

  @override
  String get loginAction => 'Login';

  @override
  String get appSlogan => 'Your digitized tontine';

  @override
  String get myBudgets => 'My Budgets';

  @override
  String get noBudgetDefined => 'No budget defined';

  @override
  String get spentLabel => 'Spent';

  @override
  String get limitLabel => 'Limit';

  @override
  String get myGoals => 'My Goals';

  @override
  String get noGoalDefined => 'No goal defined';

  @override
  String daysRemaining(int count) {
    return '$count days remaining';
  }

  @override
  String get deadlinePassed => 'Deadline passed';

  @override
  String get addTransactionTitle => 'Add Transaction';

  @override
  String get addBudgetTitle => 'Set Budget';

  @override
  String get addGoalTitle => 'New Goal';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountHint => '0.00';

  @override
  String get categoryLabel => 'Category';

  @override
  String get categoryHint => 'e.g. Food, Salary...';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'e.g. Monthly groceries';

  @override
  String get monthlyLimitLabel => 'Monthly Limit';

  @override
  String get goalNameLabel => 'Goal Name';

  @override
  String get goalNameHint => 'e.g. New Phone, Trip...';

  @override
  String get targetAmountLabel => 'Target Amount';

  @override
  String get deadlineLabel => 'Deadline';

  @override
  String get saveAction => 'Save';

  @override
  String get createBudgetAction => 'Create Budget';

  @override
  String get saveGoalAction => 'Save';

  @override
  String get successTransaction => 'Transaction added successfully';

  @override
  String get errorTransaction => 'Error adding transaction';

  @override
  String get successBudget => 'Budget created successfully';

  @override
  String get errorBudget => 'Error creating budget';

  @override
  String get successGoal => 'Goal created successfully';

  @override
  String get errorGoal => 'Error creating goal';

  @override
  String get selectDateError => 'Please select a date';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Security';

  @override
  String get language => 'Language';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get challengesTitle => 'Challenges & Rewards';

  @override
  String get noChallenges => 'No challenges available at this time';

  @override
  String points(int count) {
    return '$count pts';
  }

  @override
  String get progress => 'Progress';

  @override
  String get finished => 'Finished';

  @override
  String get acceptChallenge => 'Accept Challenge';

  @override
  String get completed => 'Completed';

  @override
  String get coachTitle => 'AI Coach';

  @override
  String get online => 'Online';

  @override
  String get coachWelcomeMessage => 'How can I help you today?';

  @override
  String get coachThinking => 'AI is thinking...';

  @override
  String get typeQuestionHint => 'Ask a question...';

  @override
  String get insightsTitle => 'Insights & Reports';

  @override
  String get spendingDistribution => 'Spending Distribution';

  @override
  String get spendingTrends => 'Spending Trends';

  @override
  String get categoryDetails => 'Category Details';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get noDataAvailable => 'No data available';
}
