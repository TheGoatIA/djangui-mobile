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
  /// **'Kauri'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get dashboard;

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
  /// **'Entrez votre e-mail pour recevoir un lien de réinitialisation.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get sendResetLink;

  /// No description provided for @emailSent.
  ///
  /// In fr, this message translates to:
  /// **'E-mail envoyé avec succès'**
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

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @editTontine.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la tontine'**
  String get editTontine;

  /// No description provided for @none.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get none;

  /// No description provided for @manageTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Gérer mes transactions'**
  String get manageTransactions;

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
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @addTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter Transaction'**
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
  /// **'Bienvenue sur Kauri'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In fr, this message translates to:
  /// **'La solution moderne pour gérer vos tontines et épargner ensemble en toute sécurité.'**
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
  /// **'Veuillez entrer votre e-mail'**
  String get enterEmailError;

  /// No description provided for @invalidEmailError.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un e-mail valide'**
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
  /// **'Rejoignez Kauri et commencez à épargner intelligemment.'**
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
  /// **'Date limite dépassée'**
  String get deadlinePassed;

  /// No description provided for @addTransactionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter Transaction'**
  String get addTransactionTitle;

  /// No description provided for @addBudgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Définir Budget'**
  String get addBudgetTitle;

  /// No description provided for @addGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Objectif'**
  String get addGoalTitle;

  /// No description provided for @transactionType.
  ///
  /// In fr, this message translates to:
  /// **'Type de Transaction'**
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

  /// No description provided for @subcategoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sous-catégorie'**
  String get subcategoryLabel;

  /// No description provided for @subcategoryHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Restaurant, Essence...'**
  String get subcategoryHint;

  /// No description provided for @merchantLabel.
  ///
  /// In fr, this message translates to:
  /// **'Commerçant'**
  String get merchantLabel;

  /// No description provided for @merchantHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Casino, Shell...'**
  String get merchantHint;

  /// No description provided for @locationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Douala, Cameroun'**
  String get locationHint;

  /// No description provided for @linkToGoalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lier à un objectif'**
  String get linkToGoalLabel;

  /// No description provided for @selectGoalHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un objectif (optionnel)'**
  String get selectGoalHint;

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
  /// **'Limite Mensuelle'**
  String get monthlyLimitLabel;

  /// No description provided for @goalNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'objectif'**
  String get goalNameLabel;

  /// No description provided for @goalNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Nouveau Téléphone, Voyage...'**
  String get goalNameHint;

  /// No description provided for @targetAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant Cible'**
  String get targetAmountLabel;

  /// No description provided for @deadlineLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date Limite'**
  String get deadlineLabel;

  /// No description provided for @saveAction.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveAction;

  /// No description provided for @createBudgetAction.
  ///
  /// In fr, this message translates to:
  /// **'Créer Budget'**
  String get createBudgetAction;

  /// No description provided for @saveGoalAction.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveGoalAction;

  /// No description provided for @successTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Transaction ajoutée avec succès'**
  String get successTransaction;

  /// No description provided for @errorTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'ajout de la transaction'**
  String get errorTransaction;

  /// No description provided for @successBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget créé avec succès'**
  String get successBudget;

  /// No description provided for @errorBudget.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création du budget'**
  String get errorBudget;

  /// No description provided for @successGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif créé avec succès'**
  String get successGoal;

  /// No description provided for @errorGoal.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la création de l\'objectif'**
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
  /// **'Accepter le défi'**
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
  /// **'Valider la semaine'**
  String get validateWeek;

  /// No description provided for @yourProgress.
  ///
  /// In fr, this message translates to:
  /// **'Votre progression'**
  String get yourProgress;

  /// No description provided for @percentCompleted.
  ///
  /// In fr, this message translates to:
  /// **'{percent}% Complété'**
  String percentCompleted(String percent);

  /// No description provided for @week.
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get week;

  /// No description provided for @validateWeekTitle.
  ///
  /// In fr, this message translates to:
  /// **'Valider la Semaine'**
  String get validateWeekTitle;

  /// No description provided for @enterAmountSaved.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le montant épargné cette semaine :'**
  String get enterAmountSaved;

  /// No description provided for @amountToContribute.
  ///
  /// In fr, this message translates to:
  /// **'Montant à verser :'**
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
  /// **'L\'IA réfléchit...'**
  String get coachThinking;

  /// No description provided for @typeQuestionHint.
  ///
  /// In fr, this message translates to:
  /// **'Posez une question...'**
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
  /// **'Tendances de Dépenses'**
  String get spendingTrends;

  /// No description provided for @categoryDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails par Catégorie'**
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

  /// No description provided for @appleSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get appleSignIn;

  /// No description provided for @phoneLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par téléphone'**
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
  /// **'Entrez le code de vérification'**
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
  /// **'Téléphone lié avec succès'**
  String get phoneLinkedSuccess;

  /// No description provided for @validationSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Semaine validée avec succès'**
  String get validationSuccess;

  /// No description provided for @invalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone invalide'**
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
  /// **'xxxxxxxxx'**
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
  /// **'Réinitialiser le mot de passe'**
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
  /// **'Réinitialiser'**
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
  /// **'Importer SMS'**
  String get importSms;

  /// No description provided for @featureNotAvailableOnIos.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalité non disponible sur iOS'**
  String get featureNotAvailableOnIos;

  /// No description provided for @scanningSms.
  ///
  /// In fr, this message translates to:
  /// **'Analyse des SMS en cours...'**
  String get scanningSms;

  /// No description provided for @automatic.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get automatic;

  /// No description provided for @transactionsImported.
  ///
  /// In fr, this message translates to:
  /// **'{count} transactions importées avec succès'**
  String transactionsImported(int count);

  /// No description provided for @deleteBudget.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le budget'**
  String get deleteBudget;

  /// No description provided for @deleteBudgetConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer ce budget ?'**
  String get deleteBudgetConfirmation;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

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
  /// **'{xp} XP pour le niveau suivant'**
  String xpToNextLevel(int xp);

  /// No description provided for @myInvestments.
  ///
  /// In fr, this message translates to:
  /// **'Mes Investissements'**
  String get myInvestments;

  /// No description provided for @addInvestment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter Investissement'**
  String get addInvestment;

  /// No description provided for @noInvestments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun Investissement'**
  String get noInvestments;

  /// No description provided for @startBuildingPortfolio.
  ///
  /// In fr, this message translates to:
  /// **'Commencez à bâtir votre portefeuille'**
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
  /// **'Montant Investi'**
  String get investedAmount;

  /// No description provided for @estimatedROI.
  ///
  /// In fr, this message translates to:
  /// **'ROI Estimé (%)'**
  String get estimatedROI;

  /// No description provided for @cryptoCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Cryptomonnaie'**
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
  /// **'Importer Objectif'**
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
  /// **'Montant Cible'**
  String get targetAmount;

  /// No description provided for @deadline.
  ///
  /// In fr, this message translates to:
  /// **'Date Limite'**
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
  /// **'Analyse Financière IA'**
  String get aiAnalysisTitle;

  /// No description provided for @aiAnalysisUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'L\'analyse IA est temporairement indisponible'**
  String get aiAnalysisUnavailable;

  /// No description provided for @countryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get countryLabel;

  /// No description provided for @notSet.
  ///
  /// In fr, this message translates to:
  /// **'Non défini'**
  String get notSet;

  /// No description provided for @upgradeToPremium.
  ///
  /// In fr, this message translates to:
  /// **'Passer Premium'**
  String get upgradeToPremium;

  /// No description provided for @premiumBannerDescription.
  ///
  /// In fr, this message translates to:
  /// **'Débloquez des analyses avancées, objectifs illimités et support prioritaire.'**
  String get premiumBannerDescription;

  /// No description provided for @discoverOffers.
  ///
  /// In fr, this message translates to:
  /// **'Voir les offres'**
  String get discoverOffers;

  /// No description provided for @aboutKauri.
  ///
  /// In fr, this message translates to:
  /// **'À propos de Kauri'**
  String get aboutKauri;

  /// No description provided for @versionInfo.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} ({buildNumber})'**
  String versionInfo(String version, String buildNumber);

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Kauri est une solution moderne pour gérer vos épargnes et tontines de manière autonome. Notre mission est de démocratiser la gestion financière grâce à la technologie.'**
  String get aboutDescription;

  /// No description provided for @developedBy.
  ///
  /// In fr, this message translates to:
  /// **'Développé avec ❤️ par l\'équipe Kauri'**
  String get developedBy;

  /// No description provided for @contact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @website.
  ///
  /// In fr, this message translates to:
  /// **'Site Web'**
  String get website;

  /// No description provided for @copyrightInfo.
  ///
  /// In fr, this message translates to:
  /// **'© 2024 Kauri. Tous droits réservés.'**
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
  /// **'Scanner reçu'**
  String get scanReceiptTooltip;

  /// No description provided for @upgradeToPremiumTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passez Premium'**
  String get upgradeToPremiumTitle;

  /// No description provided for @premiumWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans Premium'**
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
  /// **'Budgets Illimités'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs Illimités'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In fr, this message translates to:
  /// **'Analyses IA Avancées'**
  String get premiumFeature3;

  /// No description provided for @premiumFeature4.
  ///
  /// In fr, this message translates to:
  /// **'Support Prioritaire'**
  String get premiumFeature4;

  /// No description provided for @bestValue.
  ///
  /// In fr, this message translates to:
  /// **'Meilleure Offre'**
  String get bestValue;

  /// No description provided for @upgradeAction.
  ///
  /// In fr, this message translates to:
  /// **'S\'abonner Maintenant'**
  String get upgradeAction;

  /// No description provided for @currentPlan.
  ///
  /// In fr, this message translates to:
  /// **'Plan Actuel'**
  String get currentPlan;

  /// No description provided for @choosePaymentMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir Méthode de Paiement'**
  String get choosePaymentMethodTitle;

  /// No description provided for @paymentInitError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'initialisation du paiement'**
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

  /// No description provided for @unjoinChallenge.
  ///
  /// In fr, this message translates to:
  /// **'Quitter le défi'**
  String get unjoinChallenge;

  /// No description provided for @unjoinConfirmationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter le défi'**
  String get unjoinConfirmationTitle;

  /// No description provided for @unjoinConfirmationMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir quitter ce défi ? Votre progression sera perdue.'**
  String get unjoinConfirmationMessage;

  /// No description provided for @unjoinAction.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get unjoinAction;

  /// No description provided for @join.
  ///
  /// In fr, this message translates to:
  /// **'REJOINDRE'**
  String get join;

  /// No description provided for @easyDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get easyDifficulty;

  /// No description provided for @mediumDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get mediumDifficulty;

  /// No description provided for @hardDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get hardDifficulty;

  /// No description provided for @savingType.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get savingType;

  /// No description provided for @spendingType.
  ///
  /// In fr, this message translates to:
  /// **'Dépense'**
  String get spendingType;

  /// No description provided for @deleteInvestmentConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cet investissement ?'**
  String get deleteInvestmentConfirmation;

  /// No description provided for @budgetDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails du Budget'**
  String get budgetDetails;

  /// No description provided for @allocated.
  ///
  /// In fr, this message translates to:
  /// **'Alloué'**
  String get allocated;

  /// No description provided for @spent.
  ///
  /// In fr, this message translates to:
  /// **'Dépensé'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In fr, this message translates to:
  /// **'Restant'**
  String get remaining;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @goalDescriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get goalDescriptionLabel;

  /// No description provided for @goalDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Épargne de secours'**
  String get goalDescriptionHint;

  /// No description provided for @goalTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'objectif'**
  String get goalTypeLabel;

  /// No description provided for @goalPriorityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get goalPriorityLabel;

  /// No description provided for @goalEmojiLabel.
  ///
  /// In fr, this message translates to:
  /// **'Emoji'**
  String get goalEmojiLabel;

  /// No description provided for @autoSaveRulesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Règles d\'Épargne Auto'**
  String get autoSaveRulesTitle;

  /// No description provided for @enableSurplusLabel.
  ///
  /// In fr, this message translates to:
  /// **'Épargner le surplus'**
  String get enableSurplusLabel;

  /// No description provided for @enableRoundupLabel.
  ///
  /// In fr, this message translates to:
  /// **'Arrondir les transactions'**
  String get enableRoundupLabel;

  /// No description provided for @percentageIncomeLabel.
  ///
  /// In fr, this message translates to:
  /// **'% du Revenu'**
  String get percentageIncomeLabel;

  /// No description provided for @emergencyType.
  ///
  /// In fr, this message translates to:
  /// **'Urgence'**
  String get emergencyType;

  /// No description provided for @savingsType.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get savingsType;

  /// No description provided for @investmentType.
  ///
  /// In fr, this message translates to:
  /// **'Investissement'**
  String get investmentType;

  /// No description provided for @highPriority.
  ///
  /// In fr, this message translates to:
  /// **'Haute'**
  String get highPriority;

  /// No description provided for @mediumPriority.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne'**
  String get mediumPriority;

  /// No description provided for @lowPriority.
  ///
  /// In fr, this message translates to:
  /// **'Basse'**
  String get lowPriority;

  /// No description provided for @deleteGoalConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer cet objectif ?'**
  String get deleteGoalConfirmation;

  /// No description provided for @strategyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Stratégie d\'Épargne'**
  String get strategyLabel;

  /// No description provided for @strategy_50_30_20.
  ///
  /// In fr, this message translates to:
  /// **'Règle 50-30-20'**
  String get strategy_50_30_20;

  /// No description provided for @strategy_50_30_20_desc.
  ///
  /// In fr, this message translates to:
  /// **'Allouez 20% des revenus à l\'épargne (50% besoins, 30% envies).'**
  String get strategy_50_30_20_desc;

  /// No description provided for @strategy_progressive.
  ///
  /// In fr, this message translates to:
  /// **'Progressive'**
  String get strategy_progressive;

  /// No description provided for @strategy_progressive_desc.
  ///
  /// In fr, this message translates to:
  /// **'Commencez petit et augmentez les contributions avec le temps.'**
  String get strategy_progressive_desc;

  /// No description provided for @strategy_roundup.
  ///
  /// In fr, this message translates to:
  /// **'Arrondi'**
  String get strategy_roundup;

  /// No description provided for @strategy_roundup_desc.
  ///
  /// In fr, this message translates to:
  /// **'Épargnez automatiquement la différence en arrondissant vos dÃ©penses.'**
  String get strategy_roundup_desc;

  /// No description provided for @strategy_pay_yourself_first.
  ///
  /// In fr, this message translates to:
  /// **'Se Payer en Premier'**
  String get strategy_pay_yourself_first;

  /// No description provided for @strategy_pay_yourself_first_desc.
  ///
  /// In fr, this message translates to:
  /// **'Virement automatique vers l\'épargne dès réception du revenu.'**
  String get strategy_pay_yourself_first_desc;

  /// No description provided for @strategy_envelope.
  ///
  /// In fr, this message translates to:
  /// **'Enveloppe'**
  String get strategy_envelope;

  /// No description provided for @strategy_envelope_desc.
  ///
  /// In fr, this message translates to:
  /// **'Allouez un montant fixe et arrêtez de dépenser une fois l\'enveloppe vide.'**
  String get strategy_envelope_desc;

  /// No description provided for @strategy_custom.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisée'**
  String get strategy_custom;

  /// No description provided for @strategy_custom_desc.
  ///
  /// In fr, this message translates to:
  /// **'Contributions flexibles sans règles prédéfinies.'**
  String get strategy_custom_desc;

  /// No description provided for @addSavingsAction.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter Épargne'**
  String get addSavingsAction;

  /// No description provided for @currentAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Épargné'**
  String get currentAmountLabel;

  /// No description provided for @monthAndYear.
  ///
  /// In fr, this message translates to:
  /// **'Mois & Année'**
  String get monthAndYear;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @updateAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour disponible'**
  String get updateAvailable;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Une nouvelle version de Kauri est disponible. Veuillez mettre à jour pour continuer à utiliser l\'application.'**
  String get updateRequiredMessage;

  /// No description provided for @updateNow.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour'**
  String get updateNow;

  /// No description provided for @maintenanceMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Maintenance'**
  String get maintenanceMode;

  /// No description provided for @maintenanceMessage.
  ///
  /// In fr, this message translates to:
  /// **'L\'application est actuellement en maintenance. Veuillez réessayer plus tard.'**
  String get maintenanceMessage;

  /// No description provided for @markAllAsRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get markAllAsRead;

  /// No description provided for @noNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get noNotifications;

  /// No description provided for @unknownError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inconnue'**
  String get unknownError;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est définitive et toutes vos données seront perdues.'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In fr, this message translates to:
  /// **'Ceci supprimera définitivement votre compte et toutes les données associées.'**
  String get deleteAccountWarning;

  /// No description provided for @securitySettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres de Sécurité'**
  String get securitySettings;

  /// No description provided for @activeSessions.
  ///
  /// In fr, this message translates to:
  /// **'Sessions Actives'**
  String get activeSessions;

  /// No description provided for @biometrics.
  ///
  /// In fr, this message translates to:
  /// **'Biométrie'**
  String get biometrics;

  /// No description provided for @enableBiometrics.
  ///
  /// In fr, this message translates to:
  /// **'Activer la Biométrie'**
  String get enableBiometrics;

  /// No description provided for @biometricsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser FaceID ou l\'empreinte digitale pour déverrouiller l\'application'**
  String get biometricsDescription;

  /// No description provided for @dangerZone.
  ///
  /// In fr, this message translates to:
  /// **'Zone de Danger'**
  String get dangerZone;

  /// No description provided for @currentSession.
  ///
  /// In fr, this message translates to:
  /// **'Session Actuelle'**
  String get currentSession;

  /// No description provided for @lastActive.
  ///
  /// In fr, this message translates to:
  /// **'Dernière Activité'**
  String get lastActive;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get location;

  /// No description provided for @changePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer Mot de Passe'**
  String get changePassword;

  /// No description provided for @changePasswordDescription.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre mot de passe actuel et le nouveau pour le mettre à jour.'**
  String get changePasswordDescription;

  /// No description provided for @currentPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get currentPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer nouveau mot de passe'**
  String get confirmNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour'**
  String get updatePassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit faire au moins 6 caractères'**
  String get passwordTooShort;

  /// No description provided for @noSessionsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session active trouvée'**
  String get noSessionsFound;

  /// No description provided for @passwordChanged.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe mis à jour avec succès'**
  String get passwordChanged;

  /// No description provided for @deleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le Compte'**
  String get deleteAccount;

  /// No description provided for @uploadingImage.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement de l\'image...'**
  String get uploadingImage;

  /// No description provided for @investmentsPremiumRestriction.
  ///
  /// In fr, this message translates to:
  /// **'L\'accès au portefeuille d\'investissement est réservé aux membres Premium.'**
  String get investmentsPremiumRestriction;

  /// No description provided for @ocrPremiumRestriction.
  ///
  /// In fr, this message translates to:
  /// **'Le scan de reçus est réservé aux membres Premium.'**
  String get ocrPremiumRestriction;

  /// No description provided for @seeOffers.
  ///
  /// In fr, this message translates to:
  /// **'Voir les offres'**
  String get seeOffers;

  /// No description provided for @smsImportPremiumRestriction.
  ///
  /// In fr, this message translates to:
  /// **'L\'import automatique est réservé aux membres Premium.'**
  String get smsImportPremiumRestriction;

  /// No description provided for @aiAnalysisPremiumRestriction.
  ///
  /// In fr, this message translates to:
  /// **'Obtenez une analyse détaillée avec le plan Premium.'**
  String get aiAnalysisPremiumRestriction;

  /// No description provided for @confirmDowngradeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le déclassement'**
  String get confirmDowngradeTitle;

  /// No description provided for @confirmDowngradeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir revenir au plan gratuit ? Les fonctionnalités Premium ne seront plus accessibles.'**
  String get confirmDowngradeMessage;

  /// No description provided for @featureTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Transactions'**
  String get featureTransactions;

  /// No description provided for @featureBudgetsGoals.
  ///
  /// In fr, this message translates to:
  /// **'Budgets & Objectifs'**
  String get featureBudgetsGoals;

  /// No description provided for @featureCoachStandard.
  ///
  /// In fr, this message translates to:
  /// **'Coach IA Standard'**
  String get featureCoachStandard;

  /// No description provided for @featureGamification.
  ///
  /// In fr, this message translates to:
  /// **'Gamification (XP, Badges)'**
  String get featureGamification;

  /// No description provided for @featureInvestments.
  ///
  /// In fr, this message translates to:
  /// **'Investissements (Bourse, Crypto, Immo)'**
  String get featureInvestments;

  /// No description provided for @featureOCR.
  ///
  /// In fr, this message translates to:
  /// **'OCR / Scan de Reçus'**
  String get featureOCR;

  /// No description provided for @featureAIReports.
  ///
  /// In fr, this message translates to:
  /// **'Rapports Narratifs IA'**
  String get featureAIReports;

  /// No description provided for @featureBulkImport.
  ///
  /// In fr, this message translates to:
  /// **'Import en Masse (CSV/SMS)'**
  String get featureBulkImport;

  /// No description provided for @revertToFree.
  ///
  /// In fr, this message translates to:
  /// **'Revenir au plan gratuit'**
  String get revertToFree;

  /// No description provided for @downgradeRequestSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Votre demande de déclassement a été prise en compte.'**
  String get downgradeRequestSuccess;

  /// No description provided for @paymentHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des Paiements'**
  String get paymentHistory;

  /// No description provided for @noPaymentFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun paiement trouvé'**
  String get noPaymentFound;

  /// No description provided for @mobileMoney.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money'**
  String get mobileMoney;

  /// No description provided for @bankCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte Bancaire'**
  String get bankCard;

  /// No description provided for @mobileMoneyPlatforms.
  ///
  /// In fr, this message translates to:
  /// **'Orange, MTN, Moov... ({price})'**
  String mobileMoneyPlatforms(Object price);

  /// No description provided for @bankCardPlatforms.
  ///
  /// In fr, this message translates to:
  /// **'Visa, Mastercard... ({price})'**
  String bankCardPlatforms(Object price);

  /// No description provided for @invalidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get invalidAmount;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get english;

  /// No description provided for @unknownRenewalDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de renouvellement inconnue'**
  String get unknownRenewalDate;

  /// No description provided for @premiumMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre Premium'**
  String get premiumMember;

  /// No description provided for @expiresOn.
  ///
  /// In fr, this message translates to:
  /// **'Expire le : {date}'**
  String expiresOn(Object date);

  /// No description provided for @activeSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement actif'**
  String get activeSubscription;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement annulé'**
  String get subscriptionCancelled;

  /// No description provided for @pricePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{price} / mois'**
  String pricePerMonth(Object price);

  /// No description provided for @revokeAllSessions.
  ///
  /// In fr, this message translates to:
  /// **'Révoquer toutes les autres sessions'**
  String get revokeAllSessions;

  /// No description provided for @revokeSession.
  ///
  /// In fr, this message translates to:
  /// **'Révoquer'**
  String get revokeSession;

  /// No description provided for @confirmRevokeSession.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir révoquer cette session ?'**
  String get confirmRevokeSession;

  /// No description provided for @confirmRevokeAllSessions.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir révoquer toutes les autres sessions ?'**
  String get confirmRevokeAllSessions;

  /// No description provided for @sessionRevoked.
  ///
  /// In fr, this message translates to:
  /// **'Session révoquée avec succès'**
  String get sessionRevoked;

  /// No description provided for @allSessionsRevoked.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les autres sessions révoquées avec succès'**
  String get allSessionsRevoked;

  /// No description provided for @termsOfService.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'Utilisation'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de Confidentialité'**
  String get privacyPolicy;

  /// No description provided for @legalSection.
  ///
  /// In fr, this message translates to:
  /// **'Légal'**
  String get legalSection;

  /// No description provided for @supportTicketList.
  ///
  /// In fr, this message translates to:
  /// **'Tickets de Support'**
  String get supportTicketList;

  /// No description provided for @createTicket.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Ticket Support'**
  String get createTicket;

  /// No description provided for @ticketSubject.
  ///
  /// In fr, this message translates to:
  /// **'Sujet'**
  String get ticketSubject;

  /// No description provided for @ticketMessage.
  ///
  /// In fr, this message translates to:
  /// **'Message'**
  String get ticketMessage;

  /// No description provided for @ticketCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get ticketCategory;

  /// No description provided for @sendTicket.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer Ticket'**
  String get sendTicket;

  /// No description provided for @reply.
  ///
  /// In fr, this message translates to:
  /// **'Répondre'**
  String get reply;

  /// No description provided for @status.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get status;

  /// No description provided for @open.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get closed;

  /// No description provided for @answered.
  ///
  /// In fr, this message translates to:
  /// **'Répondu'**
  String get answered;

  /// No description provided for @categoryBug.
  ///
  /// In fr, this message translates to:
  /// **'Bug'**
  String get categoryBug;

  /// No description provided for @categoryPayment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get categoryPayment;

  /// No description provided for @categoryAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get categoryAccount;

  /// No description provided for @categoryOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get categoryOther;

  /// No description provided for @ticketCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Ticket créé avec succès'**
  String get ticketCreatedSuccess;

  /// No description provided for @aboutApp.
  ///
  /// In fr, this message translates to:
  /// **'À propos de l\'application'**
  String get aboutApp;

  /// No description provided for @tutorialGamificationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur votre Dashboard'**
  String get tutorialGamificationTitle;

  /// No description provided for @tutorialGamificationDesc.
  ///
  /// In fr, this message translates to:
  /// **'C\'est ici que vous suivez votre progression, vos points et badges.'**
  String get tutorialGamificationDesc;

  /// No description provided for @tutorialBalanceCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre Solde Total'**
  String get tutorialBalanceCardTitle;

  /// No description provided for @tutorialBalanceCardDesc.
  ///
  /// In fr, this message translates to:
  /// **'Visualisez rapidement l\'ensemble de vos avoirs et votre revenu mensuel.'**
  String get tutorialBalanceCardDesc;

  /// No description provided for @tutorialQuickActionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Actions Rapides'**
  String get tutorialQuickActionsTitle;

  /// No description provided for @tutorialQuickActionsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez une transaction, investissez ou consultez vos rapports en un clic.'**
  String get tutorialQuickActionsDesc;

  /// No description provided for @tutorialInsightsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse Détaillée'**
  String get tutorialInsightsTitle;

  /// No description provided for @tutorialInsightsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Filtrez par période pour voir votre évolution financière.'**
  String get tutorialInsightsDesc;

  /// No description provided for @resetTutorials.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les tutoriels'**
  String get resetTutorials;

  /// No description provided for @resetTutorialsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Relancez toutes les visites guidées pour revoir comment utiliser l\'application.'**
  String get resetTutorialsDesc;

  /// No description provided for @resetTutorialsConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous réinitialiser tous les tutoriels ? Ils s\'afficheront à nouveau lors de vos prochaines visites.'**
  String get resetTutorialsConfirm;

  /// No description provided for @resetTutorialsSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Tutoriels réinitialisés avec succès'**
  String get resetTutorialsSuccess;

  /// No description provided for @tutorialChallengesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Défis & Objectifs'**
  String get tutorialChallengesTitle;

  /// No description provided for @tutorialChallengesDesc.
  ///
  /// In fr, this message translates to:
  /// **'Relevez des défis pour améliorer votre santé financière.'**
  String get tutorialChallengesDesc;

  /// No description provided for @tutorialBudgetsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Budgets'**
  String get tutorialBudgetsTitle;

  /// No description provided for @tutorialBudgetsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Créez et suivez vos limites de dépenses par catégorie.'**
  String get tutorialBudgetsDesc;

  /// No description provided for @tutorialGoalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs d\'Épargne'**
  String get tutorialGoalsTitle;

  /// No description provided for @tutorialGoalsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Fixez des projets et suivez votre avancement pour les réaliser.'**
  String get tutorialGoalsDesc;

  /// No description provided for @tutorialTransactionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des Transactions'**
  String get tutorialTransactionsTitle;

  /// No description provided for @tutorialTransactionsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Consultez le détail de toutes vos entrées et sorties d\'argent.'**
  String get tutorialTransactionsDesc;

  /// No description provided for @tutorialInvestmentsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos Investissements'**
  String get tutorialInvestmentsTitle;

  /// No description provided for @tutorialInvestmentsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Suivez la performance de vos placements et faites fructifier votre argent.'**
  String get tutorialInvestmentsDesc;

  /// No description provided for @tutorialProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre Profil'**
  String get tutorialProfileTitle;

  /// No description provided for @tutorialProfileDesc.
  ///
  /// In fr, this message translates to:
  /// **'Gérez vos informations personnelles, votre abonnement et vos paramètres.'**
  String get tutorialProfileDesc;

  /// No description provided for @tutorialAddTransactionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une Transaction'**
  String get tutorialAddTransactionTitle;

  /// No description provided for @tutorialAddTransactionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez les détails pour garder un œil sur votre budget.'**
  String get tutorialAddTransactionDesc;

  /// No description provided for @tutorialAddGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Objectif'**
  String get tutorialAddGoalTitle;

  /// No description provided for @tutorialAddGoalDesc.
  ///
  /// In fr, this message translates to:
  /// **'Donnez un nom à votre projet et fixez un montant cible.'**
  String get tutorialAddGoalDesc;

  /// No description provided for @tutorialAddBudgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Budget'**
  String get tutorialAddBudgetTitle;

  /// No description provided for @tutorialAddBudgetDesc.
  ///
  /// In fr, this message translates to:
  /// **'Allouez un montant précis à une catégorie pour ce mois.'**
  String get tutorialAddBudgetDesc;

  /// No description provided for @tutorialAddInvestmentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Investissement'**
  String get tutorialAddInvestmentTitle;

  /// No description provided for @tutorialAddInvestmentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Diversifiez votre portefeuille en ajoutant un nouvel investissement.'**
  String get tutorialAddInvestmentDesc;

  /// No description provided for @tutorialAddTontineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tontine Digitale'**
  String get tutorialAddTontineTitle;

  /// No description provided for @tutorialAddTontineDesc.
  ///
  /// In fr, this message translates to:
  /// **'Épargnez ensemble, gérez les tours de rôle et suivez les cotisations avec l\'IA.'**
  String get tutorialAddTontineDesc;

  /// No description provided for @tutorialOCRTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scan de Reçu'**
  String get tutorialOCRTitle;

  /// No description provided for @tutorialOCRDesc.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez l\'IA pour saisir automatiquement vos transactions à partir de vos photos.'**
  String get tutorialOCRDesc;

  /// No description provided for @tutorialSubscriptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Kauri Premium'**
  String get tutorialSubscriptionTitle;

  /// No description provided for @tutorialSubscriptionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez tous les avantages exclusifs pour booster vos finances.'**
  String get tutorialSubscriptionDesc;

  /// No description provided for @confirmCountryChange.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le changement de pays'**
  String get confirmCountryChange;

  /// No description provided for @countryChangeWarning.
  ///
  /// In fr, this message translates to:
  /// **'Changer de pays convertira le solde de votre portefeuille et nécessitera l\'approbation d\'un administrateur. Êtes-vous sûr de vouloir continuer ?'**
  String get countryChangeWarning;

  /// No description provided for @completeProfile.
  ///
  /// In fr, this message translates to:
  /// **'Compléter le profil'**
  String get completeProfile;

  /// No description provided for @completeProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dernière étape'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez indiquer votre nom pour personnaliser votre expérience.'**
  String get completeProfileSubtitle;

  /// No description provided for @tutorialIncomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Revenu Mensuel'**
  String get tutorialIncomeTitle;

  /// No description provided for @tutorialIncomeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre revenu pour obtenir des conseils budgétaires personnalisés.'**
  String get tutorialIncomeDesc;

  /// No description provided for @updateIncomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour le revenu'**
  String get updateIncomeTitle;

  /// No description provided for @incomeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant mensuel'**
  String get incomeLabel;

  /// No description provided for @countryChangeRequestSubmitted.
  ///
  /// In fr, this message translates to:
  /// **'Demande de changement de pays soumise avec succès.'**
  String get countryChangeRequestSubmitted;

  /// No description provided for @confirmTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la transaction'**
  String get confirmTransaction;

  /// No description provided for @recordingInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement en cours...'**
  String get recordingInProgress;

  /// No description provided for @releaseToFinish.
  ///
  /// In fr, this message translates to:
  /// **'Relâchez pour terminer'**
  String get releaseToFinish;

  /// No description provided for @voiceExtractionAccuracy.
  ///
  /// In fr, this message translates to:
  /// **'Extraction précise à {percent}%'**
  String voiceExtractionAccuracy(Object percent);

  /// No description provided for @targetGoalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Objectif cible : {goal}'**
  String targetGoalLabel(Object goal);

  /// No description provided for @previewRecording.
  ///
  /// In fr, this message translates to:
  /// **'Préécouter l\'enregistrement'**
  String get previewRecording;

  /// No description provided for @discardRecording.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get discardRecording;

  /// No description provided for @sendAudio.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer l\'audio'**
  String get sendAudio;

  /// No description provided for @tontine.
  ///
  /// In fr, this message translates to:
  /// **'Tontine'**
  String get tontine;

  /// No description provided for @createTontine.
  ///
  /// In fr, this message translates to:
  /// **'Créer une Tontine'**
  String get createTontine;

  /// No description provided for @noTontineJoined.
  ///
  /// In fr, this message translates to:
  /// **'Aucune tontine rejointe'**
  String get noTontineJoined;

  /// No description provided for @startTontineDescription.
  ///
  /// In fr, this message translates to:
  /// **'Commencez à épargner avec vos amis ou votre famille dès aujourd\'hui.'**
  String get startTontineDescription;

  /// No description provided for @createMyFirstTontine.
  ///
  /// In fr, this message translates to:
  /// **'Créer ma première tontine'**
  String get createMyFirstTontine;

  /// No description provided for @premiumRequired.
  ///
  /// In fr, this message translates to:
  /// **'Premium Requis'**
  String get premiumRequired;

  /// No description provided for @tontinePremiumRestrictionDesc.
  ///
  /// In fr, this message translates to:
  /// **'La création de plusieurs tontines est réservée aux membres Premium.'**
  String get tontinePremiumRestrictionDesc;

  /// No description provided for @basicInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations de base'**
  String get basicInfo;

  /// No description provided for @tontineName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la tontine'**
  String get tontineName;

  /// No description provided for @contributionAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant de la cotisation'**
  String get contributionAmount;

  /// No description provided for @frequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence'**
  String get frequency;

  /// No description provided for @daily.
  ///
  /// In fr, this message translates to:
  /// **'Quotidien'**
  String get daily;

  /// No description provided for @rules.
  ///
  /// In fr, this message translates to:
  /// **'Règles & Gouvernance'**
  String get rules;

  /// No description provided for @totalParts.
  ///
  /// In fr, this message translates to:
  /// **'Nombre total de parts'**
  String get totalParts;

  /// No description provided for @rotationMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode de rotation'**
  String get rotationMode;

  /// No description provided for @manualRotation.
  ///
  /// In fr, this message translates to:
  /// **'Manuel'**
  String get manualRotation;

  /// No description provided for @randomRotation.
  ///
  /// In fr, this message translates to:
  /// **'Aléatoire'**
  String get randomRotation;

  /// No description provided for @trustScoreRotation.
  ///
  /// In fr, this message translates to:
  /// **'Basé sur le score de confiance'**
  String get trustScoreRotation;

  /// No description provided for @validationMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode de validation'**
  String get validationMode;

  /// No description provided for @aiOnlyValidation.
  ///
  /// In fr, this message translates to:
  /// **'IA uniquement'**
  String get aiOnlyValidation;

  /// No description provided for @creatorOnlyValidation.
  ///
  /// In fr, this message translates to:
  /// **'Créateur uniquement'**
  String get creatorOnlyValidation;

  /// No description provided for @democraticValidation.
  ///
  /// In fr, this message translates to:
  /// **'Démocratique (Vote)'**
  String get democraticValidation;

  /// No description provided for @summary.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get summary;

  /// No description provided for @confirmAndCreate.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer et Créer'**
  String get confirmAndCreate;

  /// No description provided for @successJoinTontine.
  ///
  /// In fr, this message translates to:
  /// **'Tontine rejointe avec succès'**
  String get successJoinTontine;

  /// No description provided for @joinTontine.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une Tontine'**
  String get joinTontine;

  /// No description provided for @enterInviteCode.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code d\'invitation'**
  String get enterInviteCode;

  /// No description provided for @enterInviteCodeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code fourni par l\'organisateur de la tontine.'**
  String get enterInviteCodeDescription;

  /// No description provided for @inviteCode.
  ///
  /// In fr, this message translates to:
  /// **'Code d\'invitation'**
  String get inviteCode;

  /// No description provided for @joinNow.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre maintenant'**
  String get joinNow;

  /// No description provided for @members.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get members;

  /// No description provided for @chat.
  ///
  /// In fr, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @recentActivity.
  ///
  /// In fr, this message translates to:
  /// **'Activité récente'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité récente'**
  String get noRecentActivity;

  /// No description provided for @collectedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Collecté'**
  String get collectedAmount;

  /// No description provided for @expectedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Attendu'**
  String get expectedAmount;

  /// No description provided for @contributors.
  ///
  /// In fr, this message translates to:
  /// **'Contributeurs'**
  String get contributors;

  /// No description provided for @noMembersFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun membre trouvé'**
  String get noMembersFound;

  /// No description provided for @contribute.
  ///
  /// In fr, this message translates to:
  /// **'Cotiser'**
  String get contribute;

  /// No description provided for @noMessagesYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de messages'**
  String get noMessagesYet;

  /// No description provided for @typeAMessage.
  ///
  /// In fr, this message translates to:
  /// **'Tapez un message...'**
  String get typeAMessage;

  /// No description provided for @successContribution.
  ///
  /// In fr, this message translates to:
  /// **'Cotisation envoyée avec succès'**
  String get successContribution;

  /// No description provided for @pendingContributions.
  ///
  /// In fr, this message translates to:
  /// **'Cotisations en attente'**
  String get pendingContributions;

  /// No description provided for @approve.
  ///
  /// In fr, this message translates to:
  /// **'Approuver'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter'**
  String get reject;

  /// No description provided for @validation.
  ///
  /// In fr, this message translates to:
  /// **'Validation'**
  String get validation;

  /// No description provided for @noPendingContributions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune cotisation en attente'**
  String get noPendingContributions;

  /// No description provided for @turn.
  ///
  /// In fr, this message translates to:
  /// **'Tour'**
  String get turn;

  /// No description provided for @displayName.
  ///
  /// In fr, this message translates to:
  /// **'Pseudonyme'**
  String get displayName;

  /// No description provided for @numberOfParts.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de parts'**
  String get numberOfParts;

  /// No description provided for @startTontine.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer la tontine'**
  String get startTontine;

  /// No description provided for @confirmStartTontine.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir démarrer cette Tontine ?'**
  String get confirmStartTontine;

  /// No description provided for @confirmDeleteTontine.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer cette tontine ?'**
  String get confirmDeleteTontine;

  /// No description provided for @confirmStopTontine.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment stopper cette tontine ? Elle passera en statut terminé.'**
  String get confirmStopTontine;

  /// No description provided for @stopTontine.
  ///
  /// In fr, this message translates to:
  /// **'Stopper la tontine'**
  String get stopTontine;

  /// No description provided for @stop.
  ///
  /// In fr, this message translates to:
  /// **'Stopper'**
  String get stop;

  /// No description provided for @tontineGuideTitle.
  ///
  /// In fr, this message translates to:
  /// **'Guide Complet Djangui'**
  String get tontineGuideTitle;

  /// No description provided for @tontineGuideDesc.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez comment optimiser votre épargne communautaire.'**
  String get tontineGuideDesc;

  /// No description provided for @whatIsTontineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Concept Djangui'**
  String get whatIsTontineTitle;

  /// No description provided for @whatIsTontineDesc.
  ///
  /// In fr, this message translates to:
  /// **'La tontine est un levier financier puissant. Sur Djangui, nous automatisons la collecte et la redistribution pour une sécurité totale.'**
  String get whatIsTontineDesc;

  /// No description provided for @tontineLifecycleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre les Statuts'**
  String get tontineLifecycleTitle;

  /// No description provided for @guidePendingTitle.
  ///
  /// In fr, this message translates to:
  /// **'1. Recrutement (Pending)'**
  String get guidePendingTitle;

  /// No description provided for @guidePendingDesc.
  ///
  /// In fr, this message translates to:
  /// **'La tontine est créée mais pas encore lancée. Invitez vos amis via le code. Le créateur peut encore modifier les règles (montant, fréquence, etc.).'**
  String get guidePendingDesc;

  /// No description provided for @guideActiveTitle.
  ///
  /// In fr, this message translates to:
  /// **'2. Action (Active)'**
  String get guideActiveTitle;

  /// No description provided for @guideActiveDesc.
  ///
  /// In fr, this message translates to:
  /// **'Le cycle a démarré. À chaque tour, les membres cotisent. L\'argent collecté est versé au bénéficiaire désigné par le mode de rotation.'**
  String get guideActiveDesc;

  /// No description provided for @guideCompletedTitle.
  ///
  /// In fr, this message translates to:
  /// **'3. Archive (Completed)'**
  String get guideCompletedTitle;

  /// No description provided for @guideCompletedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Tous les tours sont finis. La tontine reste consultable pour l\'historique des paiements.'**
  String get guideCompletedDesc;

  /// No description provided for @guideRotationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modes de Rotation'**
  String get guideRotationTitle;

  /// No description provided for @guideRotationDesc.
  ///
  /// In fr, this message translates to:
  /// **'• Fixe : L\'ordre est prédéfini.\n• Aléatoire : La chance décide du gagnant.\n• Enchères/Score : Les membres les plus rigoureux ou ayant besoin de fonds sont prioritaires.'**
  String get guideRotationDesc;

  /// No description provided for @guideValidationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transparence & Validation'**
  String get guideValidationTitle;

  /// No description provided for @guideValidationDesc.
  ///
  /// In fr, this message translates to:
  /// **'Fini les disputes ! Notre IA analyse vos reçus de paiement en quelques secondes pour valider vos cotisations.'**
  String get guideValidationDesc;

  /// No description provided for @guideSocialFundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Solidarité : Fonds Social'**
  String get guideSocialFundTitle;

  /// No description provided for @guideSocialFundDesc.
  ///
  /// In fr, this message translates to:
  /// **'Une caisse d\'entraide pour les coups durs (maladie, événements familiaux). Ces fonds ne sont pas redistribués automatiquement.'**
  String get guideSocialFundDesc;

  /// No description provided for @guideSanctionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Discipline & Sanctions'**
  String get guideSanctionsTitle;

  /// No description provided for @guideSanctionsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Pour garantir le succès, des frais de retard ou d\'absence peuvent être appliqués. Un délai de grâce (ex: 24h) est souvent accordé.'**
  String get guideSanctionsDesc;

  /// No description provided for @guideTrustScoreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre Score de Confiance'**
  String get guideTrustScoreTitle;

  /// No description provided for @guideTrustScoreDesc.
  ///
  /// In fr, this message translates to:
  /// **'C\'est votre réputation financière. Payez à temps pour augmenter votre score et débloquer des avantages dans les futures tontines.'**
  String get guideTrustScoreDesc;

  /// No description provided for @tontineStarted.
  ///
  /// In fr, this message translates to:
  /// **'Tontine démarrée avec succès'**
  String get tontineStarted;

  /// No description provided for @invalidAmountError.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get invalidAmountError;

  /// No description provided for @startDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de début'**
  String get startDate;

  /// No description provided for @socialFund.
  ///
  /// In fr, this message translates to:
  /// **'Fonds Social'**
  String get socialFund;

  /// No description provided for @enableSocialFund.
  ///
  /// In fr, this message translates to:
  /// **'Activer le fonds social'**
  String get enableSocialFund;

  /// No description provided for @sanctions.
  ///
  /// In fr, this message translates to:
  /// **'Sanctions'**
  String get sanctions;

  /// No description provided for @lateFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais de retard'**
  String get lateFee;

  /// No description provided for @absenceFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais d\'absence'**
  String get absenceFee;

  /// No description provided for @gracePeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période de grâce (heures)'**
  String get gracePeriod;

  /// No description provided for @paymentAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes de paiement'**
  String get paymentAccounts;

  /// No description provided for @addAccount.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un compte'**
  String get addAccount;

  /// No description provided for @accountType.
  ///
  /// In fr, this message translates to:
  /// **'Type de compte'**
  String get accountType;

  /// No description provided for @provider.
  ///
  /// In fr, this message translates to:
  /// **'Opérateur/Banque'**
  String get provider;

  /// No description provided for @accountNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de compte'**
  String get accountNumber;

  /// No description provided for @accountName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du compte'**
  String get accountName;

  /// No description provided for @noAccountsAdded.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte ajouté'**
  String get noAccountsAdded;

  /// No description provided for @mySubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Mes Abonnements'**
  String get mySubscriptions;

  /// No description provided for @detectSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Détecter les abonnements'**
  String get detectSubscriptions;

  /// No description provided for @noSubscriptionsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun abonnement trouvé'**
  String get noSubscriptionsFound;

  /// No description provided for @addSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un abonnement'**
  String get addSubscription;

  /// No description provided for @editSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'abonnement'**
  String get editSubscription;

  /// No description provided for @paymentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Paiement :'**
  String get paymentLabel;

  /// No description provided for @providerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur'**
  String get providerLabel;

  /// No description provided for @nextBillingDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine facturation'**
  String get nextBillingDateLabel;

  /// No description provided for @trialEndDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fin de l\'essai gratuit (Optionnel)'**
  String get trialEndDateLabel;

  /// No description provided for @remindMeLabel.
  ///
  /// In fr, this message translates to:
  /// **'M\'alerter avant l\'échéance'**
  String get remindMeLabel;

  /// No description provided for @remindMeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir une notification 48h avant'**
  String get remindMeSubtitle;

  /// No description provided for @subscriptionNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'abonnement'**
  String get subscriptionNameLabel;

  /// No description provided for @subscriptionNameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Netflix, Spotify...'**
  String get subscriptionNameHint;

  /// No description provided for @nextInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Prochaines Factures'**
  String get nextInvoices;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @inDays.
  ///
  /// In fr, this message translates to:
  /// **'Dans {count} jours'**
  String inDays(int count);

  /// No description provided for @statusActive.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get statusActive;

  /// No description provided for @statusPaused.
  ///
  /// In fr, this message translates to:
  /// **'En pause'**
  String get statusPaused;

  /// No description provided for @statusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get statusCancelled;

  /// No description provided for @statusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expiré'**
  String get statusExpired;

  /// No description provided for @frequencyWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get frequencyWeekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get frequencyMonthly;

  /// No description provided for @frequencyYearly.
  ///
  /// In fr, this message translates to:
  /// **'Annuel'**
  String get frequencyYearly;

  /// No description provided for @operationSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Opération réalisée avec succès'**
  String get operationSuccess;

  /// No description provided for @alreadyContributed.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà cotisé pour ce tour'**
  String get alreadyContributed;

  /// No description provided for @removeMember.
  ///
  /// In fr, this message translates to:
  /// **'Retirer un membre'**
  String get removeMember;

  /// No description provided for @howKauriWorks.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionne Kauri ?'**
  String get howKauriWorks;

  /// No description provided for @removeMemberConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment retirer {name} de cette tontine ?'**
  String removeMemberConfirmation(String name);

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pending;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @noContributions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune contribution'**
  String get noContributions;

  /// No description provided for @remove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get remove;

  /// No description provided for @tutorialSubscriptionListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos Abonnements'**
  String get tutorialSubscriptionListTitle;

  /// No description provided for @tutorialSubscriptionListDesc.
  ///
  /// In fr, this message translates to:
  /// **'Consultez et gérez tous vos paiements récurrents ici.'**
  String get tutorialSubscriptionListDesc;

  /// No description provided for @tutorialDetectSubscriptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détection Auto'**
  String get tutorialDetectSubscriptionTitle;

  /// No description provided for @tutorialDetectSubscriptionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Laissez l\'IA trouver vos abonnements à partir de vos SMS.'**
  String get tutorialDetectSubscriptionDesc;

  /// No description provided for @tutorialAddSubscriptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajout Manuel'**
  String get tutorialAddSubscriptionTitle;

  /// No description provided for @tutorialAddSubscriptionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un abonnement manuellement s\'il n\'a pas été détecté.'**
  String get tutorialAddSubscriptionDesc;

  /// No description provided for @tutorialTontineListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos Tontines'**
  String get tutorialTontineListTitle;

  /// No description provided for @tutorialTontineListDesc.
  ///
  /// In fr, this message translates to:
  /// **'Suivez tous vos groupes de tontine et vos cotisations.'**
  String get tutorialTontineListDesc;

  /// No description provided for @tutorialJoinTontineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une Tontine'**
  String get tutorialJoinTontineTitle;

  /// No description provided for @tutorialJoinTontineDesc.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez un code pour rejoindre un groupe existant.'**
  String get tutorialJoinTontineDesc;

  /// No description provided for @tutorialCreateTontineButtonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer une Tontine'**
  String get tutorialCreateTontineButtonTitle;

  /// No description provided for @tutorialCreateTontineButtonDesc.
  ///
  /// In fr, this message translates to:
  /// **'Lancez une nouvelle tontine et invitez vos amis.'**
  String get tutorialCreateTontineButtonDesc;
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
