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
  String get forgotPasswordSubtitle =>
      'Enter your email to receive a reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailSent => 'Email sent successfully';

  @override
  String get share => 'Share';

  @override
  String get comingSoon => 'Coming Soon';

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
  String get retry => 'Retry';

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
  String daysCount(int count) {
    return '$count days';
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
  String get difficulty => 'Difficulty';

  @override
  String get duration => 'Duration';

  @override
  String get reward => 'Reward';

  @override
  String get startChallenge => 'Start Challenge';

  @override
  String get validateWeek => 'Validate Week';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String percentCompleted(String percent) {
    return '$percent% Completed';
  }

  @override
  String get week => 'Week';

  @override
  String get validateWeekTitle => 'Validate Week';

  @override
  String get enterAmountSaved => 'Enter the amount saved this week:';

  @override
  String get amountToContribute => 'Amount to contribute:';

  @override
  String get confirmValidationTitle => 'Confirm Validation';

  @override
  String confirmValidationMessage(Object amount) {
    return 'Are you sure you want to validate this week for $amount XAF?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get active => 'Active';

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
  String get yearly => 'Annual';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get phoneLogin => 'Phone Login';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get verify => 'Verify';

  @override
  String get enterOtp => 'Enter verification code';

  @override
  String get otpCode => 'SMS Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get phoneLinkedSuccess => 'Phone linked successfully';

  @override
  String get validationSuccess => 'Week validated successfully';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get country => 'Country';

  @override
  String get selectCountry => 'Select your country';

  @override
  String get selectCountryError => 'Please select a country';

  @override
  String get phoneHint => '+237 6xx xxx xxx';

  @override
  String get resetSuccess => 'Password reset successfully';

  @override
  String get resetError => 'Error resetting password';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordSubtitle =>
      'Create a strong password to secure your account.';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get resetPasswordAction => 'Reset Password';

  @override
  String get greeting => 'Hello,';

  @override
  String get user => 'User';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get invest => 'Invest';

  @override
  String get insights => 'Insights';

  @override
  String get importSms => 'Import SMS';

  @override
  String get scanningSms => 'Scanning for SMS transactions...';

  @override
  String get automatic => 'Automatic';

  @override
  String transactionsImported(int count) {
    return '$count transactions imported!';
  }

  @override
  String get smsPermissionRequired =>
      'SMS permission required for this feature';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String xpToNextLevel(int xp) {
    return '$xp XP to next level';
  }

  @override
  String get myInvestments => 'My Investments';

  @override
  String get addInvestment => 'Add Investment';

  @override
  String get noInvestments => 'No Investments';

  @override
  String get startBuildingPortfolio => 'Start building your portfolio';

  @override
  String get newInvestment => 'New Investment';

  @override
  String get investmentDetails => 'Investment Details';

  @override
  String get assetNameHint => 'Asset name (e.g. Bitcoin, Tesla)';

  @override
  String get assetType => 'Asset Type';

  @override
  String get investedAmount => 'Invested Amount';

  @override
  String get estimatedROI => 'Estimated ROI (%)';

  @override
  String get cryptoCurrency => 'Cryptocurrency';

  @override
  String get stockMarket => 'Stock Market';

  @override
  String get realEstate => 'Real Estate';

  @override
  String get other => 'Other';

  @override
  String get fieldRequired => 'Field required';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get importGoal => 'Import Goal';

  @override
  String get goalImportedSuccess => 'Goal imported successfully!';

  @override
  String get sharedGoal => 'Shared Goal';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get deadline => 'Deadline';

  @override
  String get addGoalToListPrompt =>
      'Do you want to add this goal to your list?';

  @override
  String get acceptGoal => 'Accept Goal';

  @override
  String get aiAnalysisTitle => 'AI Financial Analysis';

  @override
  String get aiAnalysisUnavailable => 'AI analysis is currently unavailable';

  @override
  String get countryLabel => 'Country';

  @override
  String get notSet => 'Not set';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get premiumBannerDescription =>
      'Unlock advanced insights, unlimited goals, and priority support.';

  @override
  String get discoverOffers => 'Discover Offers';

  @override
  String get aboutDjangui => 'About Djangui';

  @override
  String versionInfo(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get aboutDescription =>
      'Djangui is a modern solution to manage your savings and tontines autonomously. Our mission is to democratize financial management through technology.';

  @override
  String get developedBy => 'Developed with ❤️ by the Djangui Team';

  @override
  String get contact => 'Contact';

  @override
  String get website => 'Website';

  @override
  String get copyrightInfo => '© 2024 Djangui. All rights reserved.';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get receiptScannedSuccess => 'Receipt scanned successfully';

  @override
  String get receiptScannedError => 'Error scanning receipt';

  @override
  String get scanReceiptTooltip => 'Scan receipt';

  @override
  String get upgradeToPremiumTitle => 'Upgrade to Premium';

  @override
  String get premiumWelcomeTitle => 'Welcome to Premium';

  @override
  String get premiumWelcomeSubtitle => 'Enjoy all advanced features';

  @override
  String get freePlan => 'Free';

  @override
  String get freePrice => '0 FCFA';

  @override
  String get freeFeature1 => '3 Budgets max';

  @override
  String get freeFeature2 => '1 Goal max';

  @override
  String get freeFeature3 => 'Basic insights';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get premiumPrice => '2000 FCFA/mo';

  @override
  String get premiumFeature1 => 'Unlimited Budgets';

  @override
  String get premiumFeature2 => 'Unlimited Goals';

  @override
  String get premiumFeature3 => 'Advanced AI Insights';

  @override
  String get premiumFeature4 => 'Priority Support';

  @override
  String get bestValue => 'Best Value';

  @override
  String get upgradeAction => 'Upgrade Now';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get choosePaymentMethodTitle => 'Choose Payment Method';

  @override
  String get paymentInitError => 'Error initializing payment';

  @override
  String get cameroon => 'Cameroon';

  @override
  String get france => 'France';

  @override
  String get usa => 'USA';

  @override
  String get belgium => 'Belgium';

  @override
  String get canada => 'Canada';
}
