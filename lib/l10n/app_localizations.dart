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
