// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kauri';

  @override
  String get dashboard => 'Home';

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
  String get optional => 'Optional';

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
  String get close => 'Close';

  @override
  String get edit => 'Edit';

  @override
  String get editTontine => 'Edit Tontine';

  @override
  String get none => 'None';

  @override
  String get manageTransactions => 'Manage Transactions';

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
  String get onboardingTitle1 => 'Welcome to Kauri';

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
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get noAccountQuestion => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get registerSubtitle => 'Join Kauri and start saving smartly.';

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
  String get subcategoryLabel => 'Subcategory';

  @override
  String get subcategoryHint => 'e.g. Restaurant, Fuel...';

  @override
  String get merchantLabel => 'Merchant';

  @override
  String get merchantHint => 'e.g. Casino, Shell...';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHint => 'e.g. Douala, Cameroun';

  @override
  String get linkToGoalLabel => 'Link to Goal';

  @override
  String get selectGoalHint => 'Select a goal (optional)';

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
  String get successBudgetUpdate => 'Budget updated successfully';

  @override
  String get editBudgetTitle => 'Edit Budget';

  @override
  String get updateBudgetAction => 'Update';

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
  String get appleSignIn => 'Continue with Apple';

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
  String get phoneHint => 'xxxxxxxxx';

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
  String get greetingMorning => 'Good morning,';

  @override
  String get greetingAfternoon => 'Good afternoon,';

  @override
  String get greetingEvening => 'Good evening,';

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
  String get featureNotAvailableOnIos => 'Feature not available on iOS';

  @override
  String get scanningSms => 'Scanning for SMS transactions...';

  @override
  String get automatic => 'Automatic';

  @override
  String transactionsImported(int count) {
    return '$count transactions imported successfully';
  }

  @override
  String get deleteBudget => 'Delete Budget';

  @override
  String get deleteBudgetConfirmation =>
      'Are you sure you want to delete this budget?';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this transaction?';

  @override
  String get manualTransactionBadge => 'Manual';

  @override
  String get manualTransactionInfo =>
      'This transaction is manual and does not affect your real balance.';

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
  String get aboutKauri => 'About Kauri';

  @override
  String versionInfo(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get aboutDescription =>
      'Kauri is a modern solution to manage your savings and tontines autonomously. Our mission is to democratize financial management through technology.';

  @override
  String get developedBy => 'Developed with ❤️ by the Kauri Team';

  @override
  String get contact => 'Contact';

  @override
  String get website => 'Website';

  @override
  String get copyrightInfo => '© 2024 Kauri. All rights reserved.';

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

  @override
  String get unjoinChallenge => 'Quit Challenge';

  @override
  String get unjoinConfirmationTitle => 'Quit Challenge';

  @override
  String get unjoinConfirmationMessage =>
      'Are you sure you want to quit this challenge? Your progress will be lost.';

  @override
  String get unjoinAction => 'Quit';

  @override
  String get join => 'JOIN';

  @override
  String get easyDifficulty => 'Easy';

  @override
  String get mediumDifficulty => 'Medium';

  @override
  String get hardDifficulty => 'Hard';

  @override
  String get savingType => 'Saving';

  @override
  String get spendingType => 'Spending';

  @override
  String get deleteInvestmentConfirmation =>
      'Are you sure you want to delete this investment?';

  @override
  String get budgetDetails => 'Budget Details';

  @override
  String get allocated => 'Allocated';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get categories => 'Categories';

  @override
  String get goalDescriptionLabel => 'Description';

  @override
  String get goalDescriptionHint => 'e.g. Save for a rainy day';

  @override
  String get goalTypeLabel => 'Goal Type';

  @override
  String get goalPriorityLabel => 'Priority';

  @override
  String get goalEmojiLabel => 'Emoji';

  @override
  String get autoSaveRulesTitle => 'Auto-Save Rules';

  @override
  String get enableSurplusLabel => 'Save Surplus';

  @override
  String get enableRoundupLabel => 'Round up Transactions';

  @override
  String get percentageIncomeLabel => '% of Income';

  @override
  String get emergencyType => 'Emergency';

  @override
  String get savingsType => 'Savings';

  @override
  String get investmentType => 'Investment';

  @override
  String get highPriority => 'High';

  @override
  String get mediumPriority => 'Medium';

  @override
  String get lowPriority => 'Low';

  @override
  String get deleteGoalConfirmation =>
      'Are you sure you want to delete this goal?';

  @override
  String get strategyLabel => 'Saving Strategy';

  @override
  String get strategy_50_30_20 => '50-30-20 Rule';

  @override
  String get strategy_50_30_20_desc =>
      'Allocate 20% of income to savings (50% for needs, 30% for wants).';

  @override
  String get strategy_progressive => 'Progressive';

  @override
  String get strategy_progressive_desc =>
      'Start small and increase contributions over time.';

  @override
  String get strategy_roundup => 'Roundup';

  @override
  String get strategy_roundup_desc =>
      'Automatically save the difference when rounding up your spending.';

  @override
  String get strategy_pay_yourself_first => 'Pay Yourself First';

  @override
  String get strategy_pay_yourself_first_desc =>
      'Automated transfer to savings as soon as income is received.';

  @override
  String get strategy_envelope => 'Envelope';

  @override
  String get strategy_envelope_desc =>
      'Allocate a fixed amount and stop spending once the envelope is empty.';

  @override
  String get strategy_custom => 'Custom';

  @override
  String get strategy_custom_desc =>
      'Flexible contributions without predefined rules.';

  @override
  String get addSavingsAction => 'Add Savings';

  @override
  String get redeemAction => 'Redeem Money';

  @override
  String get redeemSuccess => 'Funds redeemed successfully';

  @override
  String get redeemDialogTitle => 'Redeem Funds';

  @override
  String get redeemAmountHint =>
      'How much would you like to transfer back to your wallet?';

  @override
  String get redeemAmountLabel => 'Enter amount';

  @override
  String redeemAvailableAmount(String amount) {
    return 'Available: $amount';
  }

  @override
  String get redeemConfirmAction => 'Confirm Redemption';

  @override
  String get redeemAmountExceedsError => 'Amount exceeds current savings.';

  @override
  String earlyRedemptionWarning(String date) {
    return 'Warning: an early withdrawal (before $date) will result in a 0.5% penalty on the amount withdrawn for lack of discipline. Are you sure?';
  }

  @override
  String get earlyRedemptionTitle => 'Early Withdrawal';

  @override
  String get currentAmountLabel => 'Saved';

  @override
  String get monthAndYear => 'Month & Year';

  @override
  String get add => 'Add';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get updateRequiredMessage =>
      'A new version of Kauri is available. Please update to continue using the app.';

  @override
  String get updateNow => 'Update Now';

  @override
  String get maintenanceMode => 'Maintenance Mode';

  @override
  String get maintenanceMessage =>
      'The app is currently under maintenance. Please try again later.';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get deleteAccountDescription =>
      'Are you sure you want to delete your account? This action is permanent and all your data will be lost.';

  @override
  String get deleteAccountWarning =>
      'This will permanently remove your account and all associated data.';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get activeSessions => 'Active Sessions';

  @override
  String get biometrics => 'Biometrics';

  @override
  String get enableBiometrics => 'Enable Biometrics';

  @override
  String get biometricsDescription =>
      'Use FaceID or Fingerprint to unlock the app';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get currentSession => 'Current Session';

  @override
  String get lastActive => 'Last Active';

  @override
  String get location => 'Location';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordDescription =>
      'Enter your current password and a new one to update it.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get noSessionsFound => 'No active sessions found';

  @override
  String get passwordChanged => 'Password updated successfully';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get uploadingImage => 'Uploading image...';

  @override
  String get investmentsPremiumRestriction =>
      'Access to the investment portfolio is reserved for Premium members.';

  @override
  String get ocrPremiumRestriction =>
      'Receipt scanning is reserved for Premium members.';

  @override
  String get seeOffers => 'See Offers';

  @override
  String get smsImportPremiumRestriction =>
      'Automatic import is reserved for Premium members.';

  @override
  String get aiAnalysisPremiumRestriction =>
      'Get detailed analysis with the Premium plan.';

  @override
  String get confirmDowngradeTitle => 'Confirm Downgrade';

  @override
  String get confirmDowngradeMessage =>
      'Are you sure you want to revert to the free plan? Premium features will no longer be accessible.';

  @override
  String get freeFeatureLimits => 'Limit 100,000 FCFA / day';

  @override
  String get freeFeatureInput => 'Manual transaction entry';

  @override
  String get freeFeatureTontine => 'Max 1 tontine created, 3 participations';

  @override
  String get freeFeatureAI => 'AI Assistant (20 tx memory)';

  @override
  String get freeFeatureTracker => 'Standard budget tracking';

  @override
  String get freeFeatureFees => 'Mobile Money withdrawal fees: 3%';

  @override
  String get premiumFeatureLimits => 'Limit 300,000 FCFA / day';

  @override
  String get premiumFeatureInput => 'Express entry (Import, OCR, Voice)';

  @override
  String get premiumFeatureTontine => 'Unlimited tontines';

  @override
  String get premiumFeatureAI => 'VIP AI (100 tx, Auto-Budget, Reports)';

  @override
  String get premiumFeatureInvest => 'Simulator, Forecasts & Assets';

  @override
  String get premiumFeatureFees => 'Reduced withdrawal fees: 1.5%';

  @override
  String get premiumFeaturePrevention => 'Proactive AI Overdraft Alert';

  @override
  String get revertToFree => 'Revert to free plan';

  @override
  String get downgradeRequestSuccess =>
      'Your downgrade request has been processed.';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get noPaymentFound => 'No payment found';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get bankCard => 'Bank Card';

  @override
  String mobileMoneyPlatforms(Object price) {
    return 'Orange, MTN, Moov... ($price)';
  }

  @override
  String bankCardPlatforms(Object price) {
    return 'Visa, Mastercard... ($price)';
  }

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get unknownRenewalDate => 'Unknown renewal date';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String expiresOn(Object date) {
    return 'Expires on: $date';
  }

  @override
  String get activeSubscription => 'Active subscription';

  @override
  String get subscriptionCancelled => 'Subscription cancelled';

  @override
  String pricePerMonth(Object price) {
    return '$price / month';
  }

  @override
  String get revokeAllSessions => 'Revoke All Other Sessions';

  @override
  String get revokeSession => 'Revoke';

  @override
  String get confirmRevokeSession =>
      'Are you sure you want to revoke this session?';

  @override
  String get confirmRevokeAllSessions =>
      'Are you sure you want to revoke all other sessions?';

  @override
  String get sessionRevoked => 'Session revoked successfully';

  @override
  String get allSessionsRevoked => 'All other sessions revoked successfully';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get legalSection => 'Legal';

  @override
  String get supportTicketList => 'Support Tickets';

  @override
  String get createTicket => 'New Support Ticket';

  @override
  String get ticketSubject => 'Subject';

  @override
  String get ticketMessage => 'Message';

  @override
  String get ticketCategory => 'Category';

  @override
  String get sendTicket => 'Send Ticket';

  @override
  String get reply => 'Reply';

  @override
  String get status => 'Status';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get answered => 'Answered';

  @override
  String get categoryBug => 'Bug';

  @override
  String get categoryPayment => 'Payment';

  @override
  String get categoryAccount => 'Account';

  @override
  String get categoryOther => 'Other';

  @override
  String get ticketCreatedSuccess => 'Ticket created successfully';

  @override
  String get aboutApp => 'About App';

  @override
  String get tutorialGamificationTitle => 'Welcome to your Dashboard';

  @override
  String get tutorialGamificationDesc =>
      'Here you can track your progress, points, and badges.';

  @override
  String get tutorialBalanceCardTitle => 'Your Total Balance';

  @override
  String get tutorialBalanceCardDesc =>
      'Quickly view all your assets and monthly income.';

  @override
  String get tutorialQuickActionsTitle => 'Quick Actions';

  @override
  String get tutorialQuickActionsDesc =>
      'Add a transaction, invest, or check your reports in one click.';

  @override
  String get tutorialInsightsTitle => 'Detailed Analysis';

  @override
  String get tutorialInsightsDesc =>
      'Filter by period to see your financial evolution.';

  @override
  String get resetTutorials => 'Reset Tutorials';

  @override
  String get resetTutorialsDesc =>
      'Restart all guided tours to review how to use the application.';

  @override
  String get resetTutorialsConfirm =>
      'Do you want to reset all tutorials? They will be shown again during your next visits.';

  @override
  String get resetTutorialsSuccess => 'Tutorials reset successfully';

  @override
  String get tutorialChallengesTitle => 'Challenges & Goals';

  @override
  String get tutorialChallengesDesc =>
      'Take on challenges to improve your financial health.';

  @override
  String get tutorialBudgetsTitle => 'Budget Management';

  @override
  String get tutorialBudgetsDesc =>
      'Create and track your spending limits by category.';

  @override
  String get tutorialGoalsTitle => 'Savings Goals';

  @override
  String get tutorialGoalsDesc =>
      'Set projects and track your progress to achieve them.';

  @override
  String get tutorialTransactionsTitle => 'Transaction History';

  @override
  String get tutorialTransactionsDesc =>
      'View the details of all your money inflows and outflows.';

  @override
  String get tutorialInvestmentsTitle => 'Your Investments';

  @override
  String get tutorialInvestmentsDesc =>
      'Track the performance of your investments and grow your money.';

  @override
  String get tutorialProfileTitle => 'Your Profile';

  @override
  String get tutorialProfileDesc =>
      'Manage your personal information, subscription, and settings.';

  @override
  String get tutorialAddTransactionTitle => 'Add a Transaction';

  @override
  String get tutorialAddTransactionDesc =>
      'Enter details to keep an eye on your budget.';

  @override
  String get tutorialAddGoalTitle => 'New Goal';

  @override
  String get tutorialAddGoalDesc =>
      'Give your project a name and set a target amount.';

  @override
  String get tutorialAddBudgetTitle => 'New Budget';

  @override
  String get tutorialAddBudgetDesc =>
      'Allocate a precise amount to a category for this month.';

  @override
  String get tutorialAddInvestmentTitle => 'New Investment';

  @override
  String get tutorialAddInvestmentDesc =>
      'Diversify your portfolio by adding a new investment.';

  @override
  String get tutorialAddTontineTitle => 'Digital Tontine';

  @override
  String get tutorialAddTontineDesc =>
      'Save together, manage turns, and track contributions with AI.';

  @override
  String get tutorialOCRTitle => 'Receipt Scan';

  @override
  String get tutorialOCRDesc =>
      'Use AI to automatically capture your transactions from your photos.';

  @override
  String get tutorialSubscriptionTitle => 'Kauri Premium';

  @override
  String get tutorialSubscriptionDesc =>
      'Discover all the exclusive benefits to boost your finances.';

  @override
  String get confirmCountryChange => 'Confirm Country Change';

  @override
  String get countryChangeWarning =>
      'Changing your country will convert your wallet balance and require admin approval. Are you sure you want to proceed?';

  @override
  String get completeProfile => 'Complete Profile';

  @override
  String get completeProfileTitle => 'One Last Step';

  @override
  String get completeProfileSubtitle =>
      'Please tell us your name to personalize your experience.';

  @override
  String get updateIncomeTitle => 'Update Income';

  @override
  String get incomeLabel => 'Monthly Amount';

  @override
  String get countryChangeRequestSubmitted =>
      'Country change request submitted successfully.';

  @override
  String get confirmTransaction => 'Confirm Transaction';

  @override
  String get recordingInProgress => 'Recording in progress...';

  @override
  String get releaseToFinish => 'Release to finish';

  @override
  String voiceExtractionAccuracy(Object percent) {
    return 'Accurate extraction at $percent%';
  }

  @override
  String targetGoalLabel(Object goal) {
    return 'Target goal: $goal';
  }

  @override
  String get previewRecording => 'Preview recording';

  @override
  String get discardRecording => 'Discard';

  @override
  String get sendAudio => 'Send audio';

  @override
  String get tontine => 'Tontine';

  @override
  String get createTontine => 'Create a Tontine';

  @override
  String get noTontineJoined => 'No tontine joined';

  @override
  String get startTontineDescription =>
      'Start saving with your friends or family today.';

  @override
  String get createMyFirstTontine => 'Create my first tontine';

  @override
  String get premiumRequired => 'Premium Required';

  @override
  String get tontinePremiumRestrictionDesc =>
      'Creating multiple tontines is reserved for Premium members.';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get tontineName => 'Tontine Name';

  @override
  String get contributionAmount => 'Contribution Amount';

  @override
  String get frequency => 'Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get rules => 'Rules & Governance';

  @override
  String get totalParts => 'Total Parts';

  @override
  String get rotationMode => 'Rotation Mode';

  @override
  String get manualRotation => 'Manual';

  @override
  String get randomRotation => 'Random';

  @override
  String get trustScoreRotation => 'Based on Trust Score';

  @override
  String get validationMode => 'Validation Mode';

  @override
  String get aiOnlyValidation => 'AI Only';

  @override
  String get creatorOnlyValidation => 'Creator Only';

  @override
  String get democraticValidation => 'Democratic (Vote)';

  @override
  String get summary => 'Summary';

  @override
  String get confirmAndCreate => 'Confirm and Create';

  @override
  String get successJoinTontine => 'Tontine joined successfully';

  @override
  String get joinTontine => 'Join a Tontine';

  @override
  String get enterInviteCode => 'Enter Invite Code';

  @override
  String get enterInviteCodeDescription =>
      'Enter the code provided by the tontine organizer.';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get joinNow => 'Join Now';

  @override
  String get members => 'Members';

  @override
  String get chat => 'Chat';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get collectedAmount => 'Collected';

  @override
  String get expectedAmount => 'Expected';

  @override
  String get contributors => 'Contributors';

  @override
  String get noMembersFound => 'No members found';

  @override
  String get contribute => 'Contribute';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get successContribution => 'Contribution sent successfully';

  @override
  String get pendingContributions => 'Pending Contributions';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get validation => 'Validation';

  @override
  String get noPendingContributions => 'No pending contributions';

  @override
  String get turn => 'Turn';

  @override
  String get displayName => 'Display Name';

  @override
  String get numberOfParts => 'Number of Parts';

  @override
  String get startTontine => 'Start Tontine';

  @override
  String get confirmStartTontine =>
      'Are you sure you want to start this Tontine?';

  @override
  String get confirmDeleteTontine =>
      'Are you sure you want to delete this tontine?';

  @override
  String get confirmStopTontine =>
      'Do you really want to stop this tontine? It will be marked as completed.';

  @override
  String get stopTontine => 'Stop Tontine';

  @override
  String get stop => 'Stop';

  @override
  String get tontineGuideTitle => 'Kauri Master Guide';

  @override
  String get tontineGuideDesc =>
      'Learn how to optimize your community savings.';

  @override
  String get whatIsTontineTitle => 'The Kauri Concept (Real Money)';

  @override
  String get whatIsTontineDesc =>
      'Kauri tontine is a secure collective savings system. To participate, you must be in Cameroon 🇨🇲 and have a verified KYC profile. Everything goes through your Kauri Wallet.';

  @override
  String get tontineLifecycleTitle => 'Understanding Statuses';

  @override
  String get guidePendingTitle => '1. Recruitment (Pending)';

  @override
  String get guidePendingDesc =>
      'The tontine is created but not yet launched. Invite your friends via the code. The creator can still modify the rules (amount, frequency, etc.).';

  @override
  String get guideActiveTitle => '2. Action & Contribution';

  @override
  String get guideActiveDesc =>
      'The cycle has started. Each turn, contribute via your Wallet. Collected funds are paid out to the beneficiary transparently and securely.';

  @override
  String get guideCompletedTitle => '3. Archive (Completed)';

  @override
  String get guideCompletedDesc =>
      'All turns are finished. The tontine remains viewable for payment history.';

  @override
  String get guideRotationTitle => 'Rotation Modes';

  @override
  String get guideRotationDesc =>
      '• Fixed: The order is predefined.\n• Random: Luck decides the winner.\n• Auction/Score: Members who are most consistent or in need of funds have priority.';

  @override
  String get guideValidationTitle => 'AI & Receipts';

  @override
  String get guideValidationDesc =>
      'Send a screenshot of your NotchPay/Mobile Money receipt in the chat. Our AI validates the proof in real-time to confirm your contribution.';

  @override
  String get guideSocialFundTitle => 'Solidarity: Social Fund';

  @override
  String get guideSocialFundDesc =>
      'A mutual aid fund for tough times (health, family events). These funds are not redistributed automatically.';

  @override
  String get guideSanctionsTitle => 'Discipline & Sanctions';

  @override
  String get guideSanctionsDesc =>
      'To ensure success, late or absence fees can be applied. A grace period (e.g., 24h) is often granted.';

  @override
  String get guideTrustScoreTitle => 'Your Trust Score';

  @override
  String get guideTrustScoreDesc =>
      'This is your financial reputation. Pay on time to increase your score and unlock benefits in future tontines.';

  @override
  String get guideFinancialSafetyTitle => 'Financial Safety & KYC';

  @override
  String get guideFinancialSafetyDesc =>
      'Identity verification is mandatory for real money flows. Funds are held in secure accounts to ensure payment to every winner.';

  @override
  String get biWeekly => 'Bi-weekly';

  @override
  String get payoutDetails => 'Payout Details';

  @override
  String get payoutDetailsHint => 'Mobile Money Number or RIB';

  @override
  String get tontineRestrictionCM =>
      'Creating and joining tontines is restricted to users in Cameroon 🇨🇲.';

  @override
  String get tontineStarted => 'Tontine started successfully';

  @override
  String get invalidAmountError => 'Invalid Amount';

  @override
  String get startDate => 'Start Date';

  @override
  String get socialFund => 'Social Fund';

  @override
  String get enableSocialFund => 'Enable Social Fund';

  @override
  String get sanctions => 'Sanctions';

  @override
  String get lateFee => 'Late Fee';

  @override
  String get absenceFee => 'Absence Fee';

  @override
  String get gracePeriod => 'Grace Period (hours)';

  @override
  String get paymentAccounts => 'Payment Accounts';

  @override
  String get addAccount => 'Add Account';

  @override
  String get accountType => 'Account Type';

  @override
  String get provider => 'Provider';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get accountName => 'Account Name';

  @override
  String get noAccountsAdded => 'No accounts added';

  @override
  String get mySubscriptions => 'My Subscriptions';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get detectSubscriptions => 'Detect Subscriptions';

  @override
  String get noSubscriptionsFound => 'No subscriptions found';

  @override
  String get addSubscription => 'Add Subscription';

  @override
  String get editSubscription => 'Edit Subscription';

  @override
  String get paymentLabel => 'Payment:';

  @override
  String get providerLabel => 'Provider';

  @override
  String get nextBillingDateLabel => 'Next Billing';

  @override
  String get trialEndDateLabel => 'Free Trial End (Optional)';

  @override
  String get remindMeLabel => 'Remind me before due date';

  @override
  String get remindMeSubtitle => 'Receive a notification 48h before';

  @override
  String get subscriptionNameLabel => 'Subscription Name';

  @override
  String get subscriptionNameHint => 'e.g. Netflix, Spotify...';

  @override
  String get nextInvoices => 'Next Subscriptions';

  @override
  String get today => 'Today';

  @override
  String inDays(int count) {
    return 'In $count days';
  }

  @override
  String get statusActive => 'Active';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusExpired => 'Expired';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get frequencyYearly => 'Yearly';

  @override
  String get operationSuccess => 'Operation successful';

  @override
  String get alreadyContributed => 'You have already contributed for this turn';

  @override
  String get removeMember => 'Remove Member';

  @override
  String get howKauriWorks => 'How Kauri works ?';

  @override
  String removeMemberConfirmation(String name) {
    return 'Are you sure you want to remove $name from this tontine?';
  }

  @override
  String get pending => 'Pending';

  @override
  String get history => 'History';

  @override
  String get noContributions => 'No contributions';

  @override
  String get remove => 'Remove';

  @override
  String get tutorialSubscriptionListTitle => 'Your Subscriptions';

  @override
  String get tutorialSubscriptionListDesc =>
      'View and manage all your recurring payments here.';

  @override
  String get tutorialDetectSubscriptionTitle => 'Auto-Detection';

  @override
  String get tutorialDetectSubscriptionDesc =>
      'Let AI find your subscriptions from your SMS.';

  @override
  String get tutorialAddSubscriptionTitle => 'Manual Add';

  @override
  String get tutorialAddSubscriptionDesc =>
      'Add a subscription manually if it wasn\'t detected.';

  @override
  String get tutorialTontineListTitle => 'Your Tontines';

  @override
  String get tutorialTontineListDesc =>
      'Track all your tontine groups and contributions.';

  @override
  String get tutorialJoinTontineTitle => 'Join a Tontine';

  @override
  String get tutorialJoinTontineDesc => 'Use a code to join an existing group.';

  @override
  String get tutorialCreateTontineButtonTitle => 'Create a Tontine';

  @override
  String get tutorialCreateTontineButtonDesc =>
      'Start a new tontine and invite your friends.';

  @override
  String get tutorialIncomeTitle => 'Monthly Income';

  @override
  String get tutorialIncomeDesc =>
      'Add your income to get personalized budget advice.';

  @override
  String get verifyYourEmail => 'Verify your Email';

  @override
  String get verifyEmailDescription =>
      'A verification link has been sent to your email address. Please check your inbox and click on the link to activate your account.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get premiumThemes => 'Elite Themes (Premium)';

  @override
  String get obsidianGoldThemeLabel => 'Obsidian & Gold';

  @override
  String get polarNightThemeLabel => 'Polar Night';

  @override
  String get sunsetGlowThemeLabel => 'Sunset Glow';

  @override
  String get emeraldForestThemeLabel => 'Emerald Forest';

  @override
  String get midnightRoyalThemeLabel => 'Midnight Royal';

  @override
  String get fontFamily => 'Font Family';

  @override
  String get elegantFont => 'Elegant (Playfair)';

  @override
  String get modernFont => 'Modern (Poppins)';

  @override
  String get technicalFont => 'Technical (Roboto Mono)';

  @override
  String get classicFont => 'Classic (Outfit)';

  @override
  String get sectionAccount => 'My Account';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get sectionLegal => 'Help & Legal';

  @override
  String get sectionDanger => 'Danger Zone';

  @override
  String get coachTone => 'Coach Tone';

  @override
  String get toneBalanced => 'Balanced (Recommended)';

  @override
  String get toneEncouraging => 'Encouraging';

  @override
  String get toneFirm => 'Firm';

  @override
  String get toneBillionaire => 'Billionaire Mentor';

  @override
  String get toneAccountant => 'Strict Accountant';

  @override
  String get toneAuntie => 'Kind Auntie';

  @override
  String get notificationFrequency => 'Notification Frequency';

  @override
  String get freqHigh => 'High (All updates)';

  @override
  String get freqMedium => 'Medium (Essential)';

  @override
  String get freqLow => 'Low (Critical only)';

  @override
  String get generateViaAnne => 'Generate via Anne';

  @override
  String get anneAnalyzing => 'Anne is analyzing your finances...';

  @override
  String get applyBudgets => 'Apply';

  @override
  String get anneAnalysisTitle => 'Anne\'s Analysis';

  @override
  String get autoBudgetSuccess => 'Budgets applied successfully!';

  @override
  String get tutorialAnneTitle => 'Auto Generation';

  @override
  String get tutorialAnneDesc =>
      'Anne analyzes your income and expenses to suggest an optimized budget for the coming month.';

  @override
  String get budgetExistsTitle => 'Budget Already Exists';

  @override
  String get budgetExistsMessage =>
      'A budget for this period already exists. Do you want to replace it with Anne\'s analysis?';

  @override
  String get replaceBudget => 'Replace';

  @override
  String get success => 'Success';

  @override
  String get debtType => 'Debt';

  @override
  String get strategy_snowball => 'Snowball';

  @override
  String get strategy_snowball_desc =>
      'Pay off smallest debts first to gain momentum.';

  @override
  String get strategy_avalanche => 'Avalanche';

  @override
  String get strategy_avalanche_desc =>
      'Pay off highest interest rates first to save money.';

  @override
  String get repaymentAction => 'Add Repayment';

  @override
  String get repaymentSuccess => 'Repayment recorded successfully';

  @override
  String get repaymentDialogTitle => 'Record Repayment';

  @override
  String get repaymentAmountHint => 'Enter amount to repay';

  @override
  String get noteLabel => 'Note';

  @override
  String get noteHint => 'e.g. January installment';

  @override
  String get historyLabel => 'Contribution History';

  @override
  String get contributionLabel => 'Contribution';

  @override
  String get goalForcedExpenseHint =>
      'Saving for a goal is recorded as an expense from your wallet.';

  @override
  String get enableSurplusDesc =>
      'Automatically saves what remains of your budget at the end of the month.';

  @override
  String get enableRoundupDesc =>
      'Rounds up your expenses to the nearest currency unit and saves the difference.';

  @override
  String get percentageIncomeDesc =>
      'Percentage of each income automatically set aside.';

  @override
  String get featureDisabledTitle => 'Feature Unavailable';

  @override
  String get featureDisabledMessage =>
      'This feature is currently disabled. Please contact support or check back later.';

  @override
  String get featureUpdateRequiredMessage =>
      'This feature requires a newer version of Kauri. Please update your application to enjoy it.';

  @override
  String get fintechOnlyCameroon =>
      'Financial services (Wallet, Top-ups, Withdrawals) are currently reserved for users residing in Cameroon 🇨🇲.';

  @override
  String get featureRestrictedCountry =>
      'This feature is not available in your country.';

  @override
  String get back => 'Back';

  @override
  String get search => 'Search';

  @override
  String get addCustomCategory => 'Add custom category';

  @override
  String get kycStatus => 'KYC Status';

  @override
  String get kycVerified => 'Verified';

  @override
  String get kycPending => 'Pending';

  @override
  String get kycPendingDesc => 'Your documents are being analyzed by our team.';

  @override
  String get kycRejected => 'Rejected';

  @override
  String get kycNotSubmitted => 'Not submitted';

  @override
  String get kycAction => 'Verify my identity';

  @override
  String get autoBudgetTitle => 'AI Automated Budget';

  @override
  String get autoBudgetDesc =>
      'Let Kauri optimize your limits based on your income.';

  @override
  String get premiumReportTitle => 'Premium Financial Report';

  @override
  String get premiumReportDesc =>
      'In-depth analysis of your financial health this month.';

  @override
  String get challengeTypeSaving => 'Saving';

  @override
  String get challengeTypeSpending => 'Spending cut';

  @override
  String get challengeTypeHabit => 'Habit';

  @override
  String get challengeSkipAction => 'Skip week';

  @override
  String get challengePostponeAction => 'Postpone';

  @override
  String challengeSkipsRemaining(int count) {
    return '$count skips remaining';
  }

  @override
  String get trustScore => 'Trust Score';

  @override
  String get trustScoreDesc => 'Your Kauri financial reputation.';

  @override
  String xpEarned(int points) {
    return '+$points XP';
  }

  @override
  String get challengeSkipConfirm => 'Are you sure you want to skip this week?';

  @override
  String get challengePostponeConfirm =>
      'Do you want to postpone the deadline by 48h?';

  @override
  String get challengeProofRequired => 'Please add an image proof';

  @override
  String get transactionProof => 'Transaction Proof';

  @override
  String get photo => 'Photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get walletTitle => 'My Wallet';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get incomes => 'Incomes';

  @override
  String get outcomes => 'Outcomes';

  @override
  String get recharge => 'Recharge';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get transferLimitInfo =>
      'This limit includes all your outgoing transfers for the current month.';

  @override
  String get tutorialWalletTitle => 'Your Wallet';

  @override
  String get tutorialWalletDesc =>
      'Click here to access your wallet details, make deposits, or withdrawals.';

  @override
  String get realMoneyWelcomeTitle => 'Real Money Management';

  @override
  String get realMoneySlide1Title => 'Real Money is here on Kauri!';

  @override
  String get realMoneySlide1Desc =>
      'Kauri is leveling up! You can now manage your real money directly from the app.';

  @override
  String get realMoneySlide2Title => 'Wallet';

  @override
  String get realMoneySlide2Desc =>
      'Easy and secure deposits and withdrawals using Mobile Money.';

  @override
  String get realMoneySlide3Title => 'Goals';

  @override
  String get realMoneySlide3Desc =>
      'Your savings are now real and secure. No more simulating your finances!';

  @override
  String get realMoneySlide4Title => 'Tontines';

  @override
  String get realMoneySlide4Desc =>
      'Automate your deductions and payouts for your tontines hassle-free.';

  @override
  String get gotItButton => 'Got it!';

  @override
  String get nextButton => 'Next';

  @override
  String get noTransactions => 'No transactions for now';

  @override
  String get autoDebit => 'Auto-Debit';

  @override
  String get rotateTurn => 'Rotate Turn';

  @override
  String get deadlineLabelTontine => 'Deadline';

  @override
  String get confirmRotateTurn => 'Are you sure you want to rotate the turn?';

  @override
  String get kycTitle => 'Identity Verification';

  @override
  String get kycStepTitle => 'Crucial Step for Kauri';

  @override
  String get kycStepDesc =>
      'For security and financial compliance, we need to verify your identity.';

  @override
  String get kycFullNameLabel => 'Full Name (as on document)';

  @override
  String get kycDocTypeLabel => 'Document Type';

  @override
  String get kycDocNumberLabel => 'Document Number';

  @override
  String get kycDocPhotoLabel => 'Document Photo';

  @override
  String get kycSelfieLabel => 'Your Selfie';

  @override
  String get kycSubmitAction => 'Submit for Verification';

  @override
  String get kycUploadClick => 'Click to upload';

  @override
  String get kycMissingPhotos => 'Please provide both photos';

  @override
  String get required => 'Required';

  @override
  String get rechargeMethod => 'Recharge Method';

  @override
  String get notchpayLabel => 'Mobile Money (Local)';

  @override
  String get stripeLabel => 'Credit Card (International)';

  @override
  String get withdrawOperator => 'Operator';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get phoneNumberHint => '6XXXXXXXX';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get rechargeSuccess => 'Recharge initiated! Redirecting...';

  @override
  String get withdrawSuccess => 'Withdrawal request submitted successfully';

  @override
  String get tutorialWalletRechargeTitle => 'Recharge your account';

  @override
  String get tutorialWalletRechargeDesc =>
      'Click here to fund your balance via Mobile Money or Bank Card.';

  @override
  String get rechargeLimitError =>
      'The recharge amount is limited to 50,000 FCFA per transaction.';
}
