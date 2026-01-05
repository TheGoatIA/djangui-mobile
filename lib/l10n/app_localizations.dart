import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Djangui'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @register.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get register;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre email pour recevoir un lien de réinitialisation.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get sendResetLink;

  /// No description provided for @emailSent.
  ///
  /// In fr, this message translates to:
  /// **'Email envoyé avec succès'**
  String get emailSent;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? S\'inscrire'**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Se connecter'**
  String get alreadyHaveAccount;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @transactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @budgets.
  ///
  /// In fr, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @goals.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs'**
  String get goals;

  /// No description provided for @challenges.
  ///
  /// In fr, this message translates to:
  /// **'Défis'**
  String get challenges;

  /// No description provided for @coach.
  ///
  /// In fr, this message translates to:
  /// **'Coach IA'**
  String get coach;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get confirmLogout;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @totalBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde Total'**
  String get totalBalance;

  /// No description provided for @recentActivities.
  ///
  /// In fr, this message translates to:
  /// **'Activités Récentes'**
  String get recentActivities;

  /// No description provided for @noRecentActivities.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité récente'**
  String get noRecentActivities;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get seeAll;

  /// No description provided for @addTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une transaction'**
  String get addTransaction;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @onboardingTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Djangui'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In fr, this message translates to:
  /// **'La solution moderne pour gérer vos tontines et épargner en groupe en toute sécurité.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In fr, this message translates to:
  /// **'Épargne Collective'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In fr, this message translates to:
  /// **'Créez ou rejoignez des tontines avec vos proches et suivez les cotisations en temps réel.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité Maximale'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In fr, this message translates to:
  /// **'Vos fonds sont protégés et chaque transaction est transparente pour tous les membres.'**
  String get onboardingDesc3;

  /// No description provided for @skip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour gérer votre tontine digitalisée.'**
  String get loginSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'votre@email.com'**
  String get emailHint;

  /// No description provided for @enterEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre email'**
  String get enterEmailError;

  /// No description provided for @invalidEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un email valide'**
  String get invalidEmailError;

  /// No description provided for @enterPasswordError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get enterPasswordError;

  /// No description provided for @passwordLengthError.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get passwordLengthError;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get genericError;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @noAccountQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas de compte ?'**
  String get noAccountQuestion;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez Djangui et commencez à épargner intelligemment.'**
  String get registerSubtitle;

  /// No description provided for @firstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Jean'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Dupont'**
  String get lastNameHint;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get requiredField;

  /// No description provided for @alreadyHaveAccountQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà un compte ?'**
  String get alreadyHaveAccountQuestion;

  /// No description provided for @loginAction.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginAction;

  /// No description provided for @appSlogan.
  ///
  /// In fr, this message translates to:
  /// **'Votre tontine digitalisée'**
  String get appSlogan;

  /// No description provided for @myBudgets.
  ///
  /// In fr, this message translates to:
  /// **'Mes Budgets'**
  String get myBudgets;

  /// No description provided for @noBudgetDefined.
  ///
  /// In fr, this message translates to:
  /// **'Aucun budget défini'**
  String get noBudgetDefined;

  /// No description provided for @spentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dépensé'**
  String get spentLabel;

  /// No description provided for @limitLabel.
  ///
  /// In fr, this message translates to:
  /// **'Limite'**
  String get limitLabel;

  /// No description provided for @myGoals.
  ///
  /// In fr, this message translates to:
  /// **'Mes Objectifs'**
  String get myGoals;

  /// No description provided for @noGoalDefined.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objectif défini'**
  String get noGoalDefined;

  /// No description provided for @daysRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{count} jours restants'**
  String daysRemaining(int count);

  /// No description provided for @daysCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} jours'**
  String daysCount(int count);

  /// No description provided for @deadlinePassed.
  ///
  /// In fr, this message translates to:
  /// **'Echéance passée'**
  String get deadlinePassed;

  /// No description provided for @addTransactionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une transaction'**
  String get addTransactionTitle;

  /// No description provided for @addBudgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Définir un budget'**
  String get addBudgetTitle;

  /// No description provided for @addGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Objectif'**
  String get addGoalTitle;

  /// No description provided for @transactionType.
  ///
  /// In fr, this message translates to:
  /// **'Type de transaction'**
  String get transactionType;

  /// No description provided for @expense.
  ///
  /// In fr, this message translates to:
  /// **'Dépense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In fr, this message translates to:
  /// **'Revenu'**
  String get income;

  /// No description provided for @amountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amountLabel;

  /// No description provided for @amountHint.
  ///
  /// In fr, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @categoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get categoryLabel;

  /// No description provided for @categoryHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Alimentation, Salaire...'**
  String get categoryHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Courses du mois'**
  String get descriptionHint;

  /// No description provided for @monthlyLimitLabel.
  ///
  /// In fr, this message translates to:
  /// **'Limite mensuelle'**
  String get monthlyLimitLabel;

  /// No description provided for @goalNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'objectif'**
  String get goalNameLabel;

  /// No description provided for @goalNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Nouvel iPhone, Voyage...'**
  String get goalNameHint;

  /// No description provided for @targetAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant cible'**
  String get targetAmountLabel;

  /// No description provided for @deadlineLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'échéance'**
  String get deadlineLabel;

  /// No description provided for @saveAction.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveAction;

  /// No description provided for @createBudgetAction.
  ///
  /// In fr, this message translates to:
  /// **'Créer le budget'**
  String get createBudgetAction;

  /// No description provided for @saveGoalAction.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get saveGoalAction;

  /// No description provided for @successTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Transaction ajoutée avec succès'**
  String get successTransaction;

  /// No description provided for @errorTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'ajout'**
  String get errorTransaction;

  /// No description provided for @successBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget créé avec succès'**
  String get successBudget;

  /// No description provided for @errorBudget.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création'**
  String get errorBudget;

  /// No description provided for @successGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif créé avec succès'**
  String get successGoal;

  /// No description provided for @errorGoal.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création'**
  String get errorGoal;

  /// No description provided for @selectDateError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une date'**
  String get selectDateError;

  /// No description provided for @invalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get invalidNumber;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @security.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get security;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @helpSupport.
  ///
  /// In fr, this message translates to:
  /// **'Aide & Support'**
  String get helpSupport;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get systemTheme;

  /// No description provided for @challengesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Défis & Récompenses'**
  String get challengesTitle;

  /// No description provided for @noChallenges.
  ///
  /// In fr, this message translates to:
  /// **'Aucun défi disponible pour le moment'**
  String get noChallenges;

  /// No description provided for @points.
  ///
  /// In fr, this message translates to:
  /// **'{count} pts'**
  String points(int count);

  /// No description provided for @progress.
  ///
  /// In fr, this message translates to:
  /// **'Progression'**
  String get progress;

  /// No description provided for @finished.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get finished;

  /// No description provided for @acceptChallenge.
  ///
  /// In fr, this message translates to:
  /// **'Relever le défi'**
  String get acceptChallenge;

  /// No description provided for @completed.
  ///
  /// In fr, this message translates to:
  /// **'Complété'**
  String get completed;

  /// No description provided for @difficulty.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get difficulty;

  /// No description provided for @duration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get duration;

  /// No description provided for @reward.
  ///
  /// In fr, this message translates to:
  /// **'Récompense'**
  String get reward;

  /// No description provided for @startChallenge.
  ///
  /// In fr, this message translates to:
  /// **'Commencer le défi'**
  String get startChallenge;

  /// No description provided for @validateWeek.
  ///
  /// In fr, this message translates to:
  /// **'Valider ma semaine'**
  String get validateWeek;

  /// No description provided for @yourProgress.
  ///
  /// In fr, this message translates to:
  /// **'Votre Progression'**
  String get yourProgress;

  /// No description provided for @percentCompleted.
  ///
  /// In fr, this message translates to:
  /// **'{percent}% complété'**
  String percentCompleted(String percent);

  /// No description provided for @week.
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get week;

  /// No description provided for @validateWeekTitle.
  ///
  /// In fr, this message translates to:
  /// **'Valider la semaine'**
  String get validateWeekTitle;

  /// No description provided for @enterAmountSaved.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le montant épargné cette semaine :'**
  String get enterAmountSaved;

  /// No description provided for @amountToContribute.
  ///
  /// In fr, this message translates to:
  /// **'Montant à cotiser :'**
  String get amountToContribute;

  /// No description provided for @confirmValidationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la validation'**
  String get confirmValidationTitle;

  /// No description provided for @confirmValidationMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir valider cette semaine pour {amount} XAF ?'**
  String confirmValidationMessage(Object amount);

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @active.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get active;

  /// No description provided for @coachTitle.
  ///
  /// In fr, this message translates to:
  /// **'Coach IA'**
  String get coachTitle;

  /// No description provided for @online.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get online;

  /// No description provided for @coachWelcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Comment puis-je vous aider aujourd\'hui ?'**
  String get coachWelcomeMessage;

  /// No description provided for @coachThinking.
  ///
  /// In fr, this message translates to:
  /// **'IA réfléchit...'**
  String get coachThinking;

  /// No description provided for @typeQuestionHint.
  ///
  /// In fr, this message translates to:
  /// **'Posez votre question...'**
  String get typeQuestionHint;

  /// No description provided for @insightsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyses & Rapports'**
  String get insightsTitle;

  /// No description provided for @spendingDistribution.
  ///
  /// In fr, this message translates to:
  /// **'Répartition des Dépenses'**
  String get spendingDistribution;

  /// No description provided for @spendingTrends.
  ///
  /// In fr, this message translates to:
  /// **'Tendance des Dépenses'**
  String get spendingTrends;

  /// No description provided for @categoryDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détail par Catégorie'**
  String get categoryDetails;

  /// No description provided for @weekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In fr, this message translates to:
  /// **'Annuel'**
  String get yearly;

  /// No description provided for @noDataAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible'**
  String get noDataAvailable;

  /// No description provided for @orContinueWith.
  ///
  /// In fr, this message translates to:
  /// **'Ou continuer avec'**
  String get orContinueWith;

  /// No description provided for @googleSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get googleSignIn;

  /// No description provided for @phoneLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par numéro'**
  String get phoneLogin;

  /// No description provided for @phoneNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get phoneNumber;

  /// No description provided for @enterPhone.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre numéro'**
  String get enterPhone;

  /// No description provided for @verify.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get verify;

  /// No description provided for @enterOtp.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code reçu'**
  String get enterOtp;

  /// No description provided for @otpCode.
  ///
  /// In fr, this message translates to:
  /// **'Code SMS'**
  String get otpCode;

  /// No description provided for @resendCode.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get resendCode;

  /// No description provided for @phoneLinkedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Numéro lié avec succès'**
  String get phoneLinkedSuccess;

  /// No description provided for @validationSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Semaine validée avec succès'**
  String get validationSuccess;

  /// No description provided for @invalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro invalide'**
  String get invalidPhone;

  /// No description provided for @country.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get country;

  /// No description provided for @selectCountry.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez votre pays'**
  String get selectCountry;

  /// No description provided for @selectCountryError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un pays'**
  String get selectCountryError;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'+237 6xx xxx xxx'**
  String get phoneHint;

  /// No description provided for @resetSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe réinitialisé avec succès'**
  String get resetSuccess;

  /// No description provided for @resetError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la réinitialisation'**
  String get resetError;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialisation'**
  String get resetPasswordTitle;

  /// No description provided for @newPassword.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPassword;

  /// No description provided for @newPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un mot de passe fort pour sécuriser votre compte.'**
  String get newPasswordSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPasswordAction.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetPasswordAction;

  /// No description provided for @greeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,'**
  String get greeting;

  /// No description provided for @user.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get user;

  /// No description provided for @monthlyIncome.
  ///
  /// In fr, this message translates to:
  /// **'Revenu Mensuel'**
  String get monthlyIncome;

  /// No description provided for @totalExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses Totales'**
  String get totalExpenses;

  /// No description provided for @quickActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions Rapides'**
  String get quickActions;

  /// No description provided for @invest.
  ///
  /// In fr, this message translates to:
  /// **'Investir'**
  String get invest;

  /// No description provided for @insights.
  ///
  /// In fr, this message translates to:
  /// **'Analyses'**
  String get insights;

  /// No description provided for @importSms.
  ///
  /// In fr, this message translates to:
  /// **'Import SMS'**
  String get importSms;

  /// No description provided for @scanningSms.
  ///
  /// In fr, this message translates to:
  /// **'Recherche de transactions SMS...'**
  String get scanningSms;

  /// No description provided for @automatic.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get automatic;

  /// No description provided for @transactionsImported.
  ///
  /// In fr, this message translates to:
  /// **'{count} transactions importées !'**
  String transactionsImported(int count);

  /// No description provided for @smsPermissionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Permission SMS requise pour cette fonctionnalité'**
  String get smsPermissionRequired;

  /// No description provided for @levelLabel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level}'**
  String levelLabel(int level);

  /// No description provided for @xpToNextLevel.
  ///
  /// In fr, this message translates to:
  /// **'{xp} XP pour le prochain niveau'**
  String xpToNextLevel(int xp);

  /// No description provided for @myInvestments.
  ///
  /// In fr, this message translates to:
  /// **'Mes Investissements'**
  String get myInvestments;

  /// No description provided for @addInvestment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un investissement'**
  String get addInvestment;

  /// No description provided for @noInvestments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun investissement'**
  String get noInvestments;

  /// No description provided for @startBuildingPortfolio.
  ///
  /// In fr, this message translates to:
  /// **'Commencez à construire votre portefeuille'**
  String get startBuildingPortfolio;

  /// No description provided for @newInvestment.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Investissement'**
  String get newInvestment;

  /// No description provided for @investmentDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de l\'investissement'**
  String get investmentDetails;

  /// No description provided for @assetNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'actif (ex: Bitcoin, Tesla)'**
  String get assetNameHint;

  /// No description provided for @assetType.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'actif'**
  String get assetType;

  /// No description provided for @investedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant investi'**
  String get investedAmount;

  /// No description provided for @estimatedROI.
  ///
  /// In fr, this message translates to:
  /// **'ROI estimé (%)'**
  String get estimatedROI;

  /// No description provided for @cryptoCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Crypto-monnaie'**
  String get cryptoCurrency;

  /// No description provided for @stockMarket.
  ///
  /// In fr, this message translates to:
  /// **'Bourse'**
  String get stockMarket;

  /// No description provided for @realEstate.
  ///
  /// In fr, this message translates to:
  /// **'Immobilier'**
  String get realEstate;

  /// No description provided for @other.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get other;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get fieldRequired;

  /// No description provided for @errorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorOccurred;

  /// No description provided for @importGoal.
  ///
  /// In fr, this message translates to:
  /// **'Importer un objectif'**
  String get importGoal;

  /// No description provided for @goalImportedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Objectif importé avec succès !'**
  String get goalImportedSuccess;

  /// No description provided for @sharedGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif Partagé'**
  String get sharedGoal;

  /// No description provided for @targetAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant cible'**
  String get targetAmount;

  /// No description provided for @deadline.
  ///
  /// In fr, this message translates to:
  /// **'Date limite'**
  String get deadline;

  /// No description provided for @addGoalToListPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous ajouter cet objectif à votre liste ?'**
  String get addGoalToListPrompt;

  /// No description provided for @acceptGoal.
  ///
  /// In fr, this message translates to:
  /// **'Accepter l\'objectif'**
  String get acceptGoal;

  /// No description provided for @aiAnalysisTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse Financière par IA'**
  String get aiAnalysisTitle;

  /// No description provided for @aiAnalysisUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'L\'analyse par IA est actuellement indisponible'**
  String get aiAnalysisUnavailable;

  /// No description provided for @countryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get countryLabel;

  /// No description provided for @notSet.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get notSet;

  /// No description provided for @upgradeToPremium.
  ///
  /// In fr, this message translates to:
  /// **'Passer au Premium'**
  String get upgradeToPremium;

  /// No description provided for @premiumBannerDescription.
  ///
  /// In fr, this message translates to:
  /// **'Débloquez des analyses avancées, des objectifs illimités et un support prioritaire.'**
  String get premiumBannerDescription;

  /// No description provided for @discoverOffers.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir les offres'**
  String get discoverOffers;

  /// No description provided for @aboutDjangui.
  ///
  /// In fr, this message translates to:
  /// **'À propos de Djangui'**
  String get aboutDjangui;

  /// No description provided for @versionInfo.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} ({buildNumber})'**
  String versionInfo(String version, String buildNumber);

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Djangui est une solution moderne pour gérer votre épargne et vos tontines en toute autonomie. Notre mission est de démocratiser la gestion financière via la technologie.'**
  String get aboutDescription;

  /// No description provided for @developedBy.
  ///
  /// In fr, this message translates to:
  /// **'Développé avec ❤️ par l\'équipe Djangui'**
  String get developedBy;

  /// No description provided for @contact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @website.
  ///
  /// In fr, this message translates to:
  /// **'Site web'**
  String get website;

  /// No description provided for @copyrightInfo.
  ///
  /// In fr, this message translates to:
  /// **'© 2024 Djangui. Tous droits réservés.'**
  String get copyrightInfo;

  /// No description provided for @takePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In fr, this message translates to:
  /// **'Choisir depuis la galerie'**
  String get chooseFromGallery;

  /// No description provided for @receiptScannedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Reçu scanné avec succès'**
  String get receiptScannedSuccess;

  /// No description provided for @receiptScannedError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du scan du reçu'**
  String get receiptScannedError;

  /// No description provided for @scanReceiptTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un reçu'**
  String get scanReceiptTooltip;

  /// No description provided for @upgradeToPremiumTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passer au Premium'**
  String get upgradeToPremiumTitle;

  /// No description provided for @premiumWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue au Premium'**
  String get premiumWelcomeTitle;

  /// No description provided for @premiumWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Profitez de toutes les fonctionnalités avancées'**
  String get premiumWelcomeSubtitle;

  /// No description provided for @freePlan.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get freePlan;

  /// No description provided for @freePrice.
  ///
  /// In fr, this message translates to:
  /// **'0 FCFA'**
  String get freePrice;

  /// No description provided for @freeFeature1.
  ///
  /// In fr, this message translates to:
  /// **'3 Budgets max'**
  String get freeFeature1;

  /// No description provided for @freeFeature2.
  ///
  /// In fr, this message translates to:
  /// **'1 Objectif max'**
  String get freeFeature2;

  /// No description provided for @freeFeature3.
  ///
  /// In fr, this message translates to:
  /// **'Analyses basiques'**
  String get freeFeature3;

  /// No description provided for @premiumPlan.
  ///
  /// In fr, this message translates to:
  /// **'Premium'**
  String get premiumPlan;

  /// No description provided for @premiumPrice.
  ///
  /// In fr, this message translates to:
  /// **'2000 FCFA/mois'**
  String get premiumPrice;

  /// No description provided for @premiumFeature1.
  ///
  /// In fr, this message translates to:
  /// **'Budgets illimités'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs illimités'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In fr, this message translates to:
  /// **'Analyses IA avancées'**
  String get premiumFeature3;

  /// No description provided for @premiumFeature4.
  ///
  /// In fr, this message translates to:
  /// **'Support prioritaire'**
  String get premiumFeature4;

  /// No description provided for @bestValue.
  ///
  /// In fr, this message translates to:
  /// **'Meilleure offre'**
  String get bestValue;

  /// No description provided for @upgradeAction.
  ///
  /// In fr, this message translates to:
  /// **'S\'abonner maintenant'**
  String get upgradeAction;

  /// No description provided for @currentPlan.
  ///
  /// In fr, this message translates to:
  /// **'Plan actuel'**
  String get currentPlan;

  /// No description provided for @choosePaymentMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le mode de paiement'**
  String get choosePaymentMethodTitle;

  /// No description provided for @paymentInitError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'initialisation du paiement'**
  String get paymentInitError;

  /// No description provided for @cameroon.
  ///
  /// In fr, this message translates to:
  /// **'Cameroun'**
  String get cameroon;

  /// No description provided for @france.
  ///
  /// In fr, this message translates to:
  /// **'France'**
  String get france;

  /// No description provided for @usa.
  ///
  /// In fr, this message translates to:
  /// **'États-Unis'**
  String get usa;

  /// No description provided for @belgium.
  ///
  /// In fr, this message translates to:
  /// **'Belgique'**
  String get belgium;

  /// No description provided for @canada.
  ///
  /// In fr, this message translates to:
  /// **'Canada'**
  String get canada;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
