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

  /// No description provided for @kycFrontRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez fournir la pièce d\'identité (recto).'**
  String get kycFrontRequired;

  /// No description provided for @premiumFallbackTontines.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu\'à 2 tontines créées (participation illimitée)'**
  String get premiumFallbackTontines;

  /// No description provided for @requiredAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get requiredAmountLabel;

  /// No description provided for @perMonthSuffix.
  ///
  /// In fr, this message translates to:
  /// **'/ mois'**
  String get perMonthSuffix;

  /// No description provided for @errKycRequired.
  ///
  /// In fr, this message translates to:
  /// **'Votre profil KYC n\'a pas encore été validé. Veuillez soumettre ou finaliser vos documents pour débloquer les retraits.'**
  String get errKycRequired;

  /// No description provided for @errInvalidPhoneOrProvider.
  ///
  /// In fr, this message translates to:
  /// **'Le numéro de téléphone ou l\'opérateur sélectionné est invalide. Veuillez vérifier votre saisie.'**
  String get errInvalidPhoneOrProvider;

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

  /// No description provided for @optional.
  ///
  /// In fr, this message translates to:
  /// **'Optionnel'**
  String get optional;

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

  /// No description provided for @resteAVivreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Reste à vivre ce mois-ci'**
  String get resteAVivreLabel;

  /// No description provided for @resteAVivreOverspentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dépassement de budget ce mois-ci'**
  String get resteAVivreOverspentLabel;

  /// No description provided for @joinBudget.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre un budget'**
  String get joinBudget;

  /// No description provided for @joinBudgetDescription.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code d\'invitation partagé par le propriétaire du budget pour le rejoindre.'**
  String get joinBudgetDescription;

  /// No description provided for @successJoinBudget.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez rejoint le budget avec succès'**
  String get successJoinBudget;

  /// No description provided for @shareBudget.
  ///
  /// In fr, this message translates to:
  /// **'Partager ce budget'**
  String get shareBudget;

  /// No description provided for @shareBudgetDescription.
  ///
  /// In fr, this message translates to:
  /// **'Partagez ce code avec les personnes que vous voulez inviter à contribuer à ce budget.'**
  String get shareBudgetDescription;

  /// No description provided for @budgetParticipants.
  ///
  /// In fr, this message translates to:
  /// **'Participants'**
  String get budgetParticipants;

  /// No description provided for @leaveBudget.
  ///
  /// In fr, this message translates to:
  /// **'Quitter ce budget'**
  String get leaveBudget;

  /// No description provided for @leaveBudgetConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment quitter ce budget partagé ?'**
  String get leaveBudgetConfirm;

  /// No description provided for @removeParticipant.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get removeParticipant;

  /// No description provided for @joinGoal.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre un objectif'**
  String get joinGoal;

  /// No description provided for @joinGoalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code d\'invitation partagé par le propriétaire de l\'objectif pour le rejoindre.'**
  String get joinGoalDescription;

  /// No description provided for @successJoinGoal.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez rejoint l\'objectif avec succès'**
  String get successJoinGoal;

  /// No description provided for @shareGoal.
  ///
  /// In fr, this message translates to:
  /// **'Partager cet objectif'**
  String get shareGoal;

  /// No description provided for @shareGoalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Partagez ce code avec les personnes que vous voulez inviter à contribuer à cet objectif.'**
  String get shareGoalDescription;

  /// No description provided for @goalParticipants.
  ///
  /// In fr, this message translates to:
  /// **'Participants'**
  String get goalParticipants;

  /// No description provided for @leaveGoal.
  ///
  /// In fr, this message translates to:
  /// **'Quitter cet objectif'**
  String get leaveGoal;

  /// No description provided for @leaveGoalConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment quitter cet objectif partagé ?'**
  String get leaveGoalConfirm;

  /// No description provided for @contributionByLabel.
  ///
  /// In fr, this message translates to:
  /// **'Par {name}'**
  String contributionByLabel(String name);

  /// No description provided for @contributionByYou.
  ///
  /// In fr, this message translates to:
  /// **'Par vous'**
  String get contributionByYou;

  /// No description provided for @sharedByLabel.
  ///
  /// In fr, this message translates to:
  /// **'Partagé par {name}'**
  String sharedByLabel(String name);

  /// No description provided for @sharedBadge.
  ///
  /// In fr, this message translates to:
  /// **'Partagé'**
  String get sharedBadge;

  /// No description provided for @spendingHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des dépenses'**
  String get spendingHistory;

  /// No description provided for @selectCategory.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une catégorie'**
  String get selectCategory;

  /// No description provided for @linkedGoalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Objectif lié'**
  String get linkedGoalLabel;

  /// No description provided for @linkedGoalNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objectif lié'**
  String get linkedGoalNone;

  /// No description provided for @linkedGoalDescription.
  ///
  /// In fr, this message translates to:
  /// **'Le surplus non dépensé en fin de mois vous sera suggéré comme contribution à cet objectif.'**
  String get linkedGoalDescription;

  /// No description provided for @copyToClipboard.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copyToClipboard;

  /// No description provided for @copiedToClipboard.
  ///
  /// In fr, this message translates to:
  /// **'Copié dans le presse-papiers'**
  String get copiedToClipboard;

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

  /// No description provided for @tutorialFinish.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get tutorialFinish;

  /// No description provided for @replayOnboarding.
  ///
  /// In fr, this message translates to:
  /// **'Revoir l\'introduction'**
  String get replayOnboarding;

  /// No description provided for @replayOnboardingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Revoir les écrans de bienvenue — les trois pages vues lors de votre tout premier lancement de l\'application.'**
  String get replayOnboardingDesc;

  /// No description provided for @tutorialGoalContributeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Alimentez cet objectif'**
  String get tutorialGoalContributeTitle;

  /// No description provided for @tutorialGoalContributeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez de l\'argent quand vous le souhaitez, ou récupérez votre épargne une fois prête.'**
  String get tutorialGoalContributeDesc;

  /// No description provided for @tutorialTontineContributeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Effectuez votre contribution'**
  String get tutorialTontineContributeTitle;

  /// No description provided for @tutorialTontineContributeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Déposez ici la preuve de paiement pour ce tour — le créateur la valide avant qu\'elle ne compte.'**
  String get tutorialTontineContributeDesc;

  /// No description provided for @tutorialTontineTurnTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivez la rotation'**
  String get tutorialTontineTurnTitle;

  /// No description provided for @tutorialTontineTurnDesc.
  ///
  /// In fr, this message translates to:
  /// **'Voyez à qui c\'est le tour de recevoir la cagnotte et combien de membres ont déjà payé.'**
  String get tutorialTontineTurnDesc;

  /// No description provided for @tutorialCreateTontineRulesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Définissez les règles'**
  String get tutorialCreateTontineRulesTitle;

  /// No description provided for @tutorialCreateTontineRulesDesc.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le mode de rotation des paiements et de validation des contributions — non modifiables une fois que des membres ont rejoint.'**
  String get tutorialCreateTontineRulesDesc;

  /// No description provided for @tutorialResellerVaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre coffre-fort sécurisé'**
  String get tutorialResellerVaultTitle;

  /// No description provided for @tutorialResellerVaultDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les identifiants des comptes maîtres sont stockés ici. Appuyez pour les révéler uniquement quand vous en avez besoin.'**
  String get tutorialResellerVaultDesc;

  /// No description provided for @tutorialResellerAddAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un compte maître'**
  String get tutorialResellerAddAccountTitle;

  /// No description provided for @tutorialResellerAddAccountDesc.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez un compte de streaming que vous revendez — suivez ses profils, sa facturation et sa marge au même endroit.'**
  String get tutorialResellerAddAccountDesc;

  /// No description provided for @tutorialSecurityBiometricTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sécurisez votre compte'**
  String get tutorialSecurityBiometricTitle;

  /// No description provided for @tutorialSecurityBiometricDesc.
  ///
  /// In fr, this message translates to:
  /// **'Activez ici la connexion biométrique pour que vous seul puissiez accéder à votre argent, même si quelqu\'un a votre téléphone.'**
  String get tutorialSecurityBiometricDesc;

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
  /// **'Le mot de passe doit contenir au moins 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spécial'**
  String get passwordLengthError;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get genericError;

  /// No description provided for @networkErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet. Vérifiez votre réseau et réessayez.'**
  String get networkErrorGeneric;

  /// No description provided for @timeoutErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur met trop de temps à répondre. Veuillez réessayer.'**
  String get timeoutErrorGeneric;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

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

  /// No description provided for @successBudgetUpdate.
  ///
  /// In fr, this message translates to:
  /// **'Budget mis à jour avec succès'**
  String get successBudgetUpdate;

  /// No description provided for @editBudgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le Budget'**
  String get editBudgetTitle;

  /// No description provided for @updateBudgetAction.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour'**
  String get updateBudgetAction;

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

  /// No description provided for @amountMustBePositive.
  ///
  /// In fr, this message translates to:
  /// **'Le montant doit être supérieur à zéro'**
  String get amountMustBePositive;

  /// No description provided for @percentageMustBeInRange.
  ///
  /// In fr, this message translates to:
  /// **'Le pourcentage doit être entre 0 et 100'**
  String get percentageMustBeInRange;

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

  /// No description provided for @forecastSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prévision de solde (30 jours)'**
  String get forecastSectionTitle;

  /// No description provided for @forecastCriticalAlertPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Alerte :'**
  String get forecastCriticalAlertPrefix;

  /// No description provided for @forecastInsightsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ce que Kauri observe'**
  String get forecastInsightsLabel;

  /// No description provided for @forecastUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Prévision indisponible pour le moment.'**
  String get forecastUnavailable;

  /// No description provided for @healthScoreHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Évolution de votre santé financière'**
  String get healthScoreHistoryTitle;

  /// No description provided for @healthScoreHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Revenez le mois prochain pour voir apparaître votre courbe d\'évolution.'**
  String get healthScoreHistoryEmpty;

  /// No description provided for @autoBudgetNoIncomeHint.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez votre revenu mensuel dans votre profil pour obtenir un budget recommandé personnalisé.'**
  String get autoBudgetNoIncomeHint;

  /// No description provided for @autoBudgetNeeds.
  ///
  /// In fr, this message translates to:
  /// **'Besoins essentiels (50%)'**
  String get autoBudgetNeeds;

  /// No description provided for @autoBudgetWants.
  ///
  /// In fr, this message translates to:
  /// **'Envies (30%)'**
  String get autoBudgetWants;

  /// No description provided for @autoBudgetSavings.
  ///
  /// In fr, this message translates to:
  /// **'Épargne (20%)'**
  String get autoBudgetSavings;

  /// No description provided for @autoBudgetActualSpent.
  ///
  /// In fr, this message translates to:
  /// **'Dépensé ce mois-ci : {spent} sur un revenu de {income}'**
  String autoBudgetActualSpent(String spent, String income);

  /// No description provided for @premiumReportReady.
  ///
  /// In fr, this message translates to:
  /// **'Votre Rapport de {month} est prêt !'**
  String premiumReportReady(String month);

  /// No description provided for @premiumReportPreparing.
  ///
  /// In fr, this message translates to:
  /// **'Votre Rapport de {month} arrive bientôt...'**
  String premiumReportPreparing(String month);

  /// No description provided for @premiumReportShareAction.
  ///
  /// In fr, this message translates to:
  /// **'Partager mon rapport'**
  String get premiumReportShareAction;

  /// No description provided for @reportPdfKeyInsights.
  ///
  /// In fr, this message translates to:
  /// **'Points clés'**
  String get reportPdfKeyInsights;

  /// No description provided for @reportPdfRecommendations.
  ///
  /// In fr, this message translates to:
  /// **'Recommandations de Kauri'**
  String get reportPdfRecommendations;

  /// No description provided for @reportPdfGeneratedOn.
  ///
  /// In fr, this message translates to:
  /// **'Généré par Kauri le {date}'**
  String reportPdfGeneratedOn(String date);

  /// No description provided for @reportPdfGenerating.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du PDF...'**
  String get reportPdfGenerating;

  /// No description provided for @reportPdfError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de générer le PDF du rapport.'**
  String get reportPdfError;

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

  /// No description provided for @insightsLoadErrorBanner.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de mettre à jour vos analyses. Les données affichées peuvent être obsolètes.'**
  String get insightsLoadErrorBanner;

  /// No description provided for @financialHealthScoreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Score de santé financière'**
  String get financialHealthScoreLabel;

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

  /// No description provided for @greetingMorning.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In fr, this message translates to:
  /// **'Bon après-midi,'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In fr, this message translates to:
  /// **'Bonsoir,'**
  String get greetingEvening;

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

  /// No description provided for @deleteTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la transaction'**
  String get deleteTransaction;

  /// No description provided for @deleteConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer cette transaction ?'**
  String get deleteConfirmation;

  /// No description provided for @manualTransactionBadge.
  ///
  /// In fr, this message translates to:
  /// **'Manuel'**
  String get manualTransactionBadge;

  /// No description provided for @manualTransactionInfo.
  ///
  /// In fr, this message translates to:
  /// **'Cette transaction est manuelle et n\'affecte pas votre solde réel.'**
  String get manualTransactionInfo;

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

  /// No description provided for @tontineAiAnalysisTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse IA du reçu'**
  String get tontineAiAnalysisTitle;

  /// No description provided for @tontineAiDetectedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant détecté'**
  String get tontineAiDetectedAmount;

  /// No description provided for @tontineAiDetectedRef.
  ///
  /// In fr, this message translates to:
  /// **'Référence détectée'**
  String get tontineAiDetectedRef;

  /// No description provided for @tontineAiDetectedDate.
  ///
  /// In fr, this message translates to:
  /// **'Date détectée'**
  String get tontineAiDetectedDate;

  /// No description provided for @tontineAiConfidence.
  ///
  /// In fr, this message translates to:
  /// **'Confiance de l\'IA'**
  String get tontineAiConfidence;

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
  /// **'© {year} Kauri. Tous droits réservés.'**
  String copyrightInfo(String year);

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

  /// No description provided for @avatarOptionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil'**
  String get avatarOptionsTitle;

  /// No description provided for @generateAvatarWithAi.
  ///
  /// In fr, this message translates to:
  /// **'Générer avec l\'IA'**
  String get generateAvatarWithAi;

  /// No description provided for @generateAvatarWithAiDesc.
  ///
  /// In fr, this message translates to:
  /// **'Créez un avatar unique à partir d\'un style, en quelques secondes.'**
  String get generateAvatarWithAiDesc;

  /// No description provided for @aiAvatarStyleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un style'**
  String get aiAvatarStyleLabel;

  /// No description provided for @aiAvatarRefinementHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des détails (optionnel)'**
  String get aiAvatarRefinementHint;

  /// No description provided for @aiAvatarGenerateButton.
  ///
  /// In fr, this message translates to:
  /// **'Générer mon avatar'**
  String get aiAvatarGenerateButton;

  /// No description provided for @aiAvatarGenerating.
  ///
  /// In fr, this message translates to:
  /// **'Génération en cours...'**
  String get aiAvatarGenerating;

  /// No description provided for @aiAvatarSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel avatar généré avec succès !'**
  String get aiAvatarSuccess;

  /// No description provided for @aiAvatarStyleProfessional.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel'**
  String get aiAvatarStyleProfessional;

  /// No description provided for @aiAvatarStyleIllustrated.
  ///
  /// In fr, this message translates to:
  /// **'Illustré'**
  String get aiAvatarStyleIllustrated;

  /// No description provided for @aiAvatarStyleCyberpunk.
  ///
  /// In fr, this message translates to:
  /// **'Cyberpunk'**
  String get aiAvatarStyleCyberpunk;

  /// No description provided for @aiAvatarStyleMinimalist.
  ///
  /// In fr, this message translates to:
  /// **'Minimaliste'**
  String get aiAvatarStyleMinimalist;

  /// No description provided for @aiAvatarStyleFantasy.
  ///
  /// In fr, this message translates to:
  /// **'Fantaisie'**
  String get aiAvatarStyleFantasy;

  /// No description provided for @aiAvatarStyleWatercolor.
  ///
  /// In fr, this message translates to:
  /// **'Aquarelle'**
  String get aiAvatarStyleWatercolor;

  /// No description provided for @aiAvatarStyleCartoon.
  ///
  /// In fr, this message translates to:
  /// **'Cartoon'**
  String get aiAvatarStyleCartoon;

  /// No description provided for @aiAvatarPreviewHint.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu — vous pouvez le régénérer ou modifier vos réglages avant de l\'appliquer.'**
  String get aiAvatarPreviewHint;

  /// No description provided for @aiAvatarUseButton.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser cet avatar'**
  String get aiAvatarUseButton;

  /// No description provided for @aiAvatarApplying.
  ///
  /// In fr, this message translates to:
  /// **'Application en cours...'**
  String get aiAvatarApplying;

  /// No description provided for @aiAvatarRegenerateButton.
  ///
  /// In fr, this message translates to:
  /// **'Régénérer'**
  String get aiAvatarRegenerateButton;

  /// No description provided for @aiAvatarEditButton.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get aiAvatarEditButton;

  /// No description provided for @avatarViewerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil'**
  String get avatarViewerTitle;

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
  /// **'2 000 FCFA/mois'**
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

  /// No description provided for @surplusDayOfMonthLabel.
  ///
  /// In fr, this message translates to:
  /// **'Jour du mois pour la suggestion'**
  String get surplusDayOfMonthLabel;

  /// No description provided for @surplusDayOfMonthValue.
  ///
  /// In fr, this message translates to:
  /// **'Le {day}'**
  String surplusDayOfMonthValue(int day);

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
  /// **'Épargnez automatiquement la différence en arrondissant vos dépenses.'**
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

  /// No description provided for @redeemAction.
  ///
  /// In fr, this message translates to:
  /// **'Récupérer l\'argent'**
  String get redeemAction;

  /// No description provided for @redeemSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Fonds récupérés avec succès'**
  String get redeemSuccess;

  /// No description provided for @redeemDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récupérer des fonds'**
  String get redeemDialogTitle;

  /// No description provided for @redeemAmountHint.
  ///
  /// In fr, this message translates to:
  /// **'Combien souhaitez-vous reverser dans votre portefeuille ?'**
  String get redeemAmountHint;

  /// No description provided for @redeemAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le montant'**
  String get redeemAmountLabel;

  /// No description provided for @redeemAvailableAmount.
  ///
  /// In fr, this message translates to:
  /// **'Disponible : {amount}'**
  String redeemAvailableAmount(String amount);

  /// No description provided for @redeemConfirmAction.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le rachat'**
  String get redeemConfirmAction;

  /// No description provided for @redeemAmountExceedsError.
  ///
  /// In fr, this message translates to:
  /// **'Le montant dépasse l\'épargne actuelle.'**
  String get redeemAmountExceedsError;

  /// No description provided for @earlyRedemptionWarning.
  ///
  /// In fr, this message translates to:
  /// **'Attention: un retrait anticipé (avant le {date}) entraînera une pénalité de 0,5% sur le montant retiré pour indiscipline. Êtes-vous sûr ?'**
  String earlyRedemptionWarning(String date);

  /// No description provided for @earlyRedemptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retrait Anticipé'**
  String get earlyRedemptionTitle;

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
  /// **'Le mot de passe doit contenir au moins 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spécial'**
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

  /// No description provided for @freeFeatureLimits.
  ///
  /// In fr, this message translates to:
  /// **'Limite de 100 000 FCFA / jour'**
  String get freeFeatureLimits;

  /// No description provided for @freeFeatureInput.
  ///
  /// In fr, this message translates to:
  /// **'Saisie manuelle des transactions'**
  String get freeFeatureInput;

  /// No description provided for @freeFeatureTontine.
  ///
  /// In fr, this message translates to:
  /// **'Max 1 tontine créée, 3 participations'**
  String get freeFeatureTontine;

  /// No description provided for @freeFeatureAI.
  ///
  /// In fr, this message translates to:
  /// **'Assistant IA (mémoire de 20 tr)'**
  String get freeFeatureAI;

  /// No description provided for @freeFeatureTracker.
  ///
  /// In fr, this message translates to:
  /// **'Suivi budgétaire standard'**
  String get freeFeatureTracker;

  /// No description provided for @freeFeatureFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais retrait Mobile Money : 3%'**
  String get freeFeatureFees;

  /// No description provided for @premiumFeatureLimits.
  ///
  /// In fr, this message translates to:
  /// **'Limite de 300 000 FCFA / jour'**
  String get premiumFeatureLimits;

  /// No description provided for @premiumFeatureInput.
  ///
  /// In fr, this message translates to:
  /// **'Saisie Express (Import, OCR, Vocal)'**
  String get premiumFeatureInput;

  /// No description provided for @premiumFeatureTontine.
  ///
  /// In fr, this message translates to:
  /// **'Tontines illimitées'**
  String get premiumFeatureTontine;

  /// No description provided for @premiumFeatureAI.
  ///
  /// In fr, this message translates to:
  /// **'IA VIP (100 tr, Budget Auto, Rapports)'**
  String get premiumFeatureAI;

  /// No description provided for @premiumFeatureInvest.
  ///
  /// In fr, this message translates to:
  /// **'Simulateur, Prévisions et Actifs'**
  String get premiumFeatureInvest;

  /// No description provided for @premiumFeatureFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais retrait réduits : 1.5%'**
  String get premiumFeatureFees;

  /// No description provided for @premiumFeaturePrevention.
  ///
  /// In fr, this message translates to:
  /// **'Alerte de Découvert proactive IA'**
  String get premiumFeaturePrevention;

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

  /// No description provided for @tutorialAiReportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre rapport IA'**
  String get tutorialAiReportTitle;

  /// No description provided for @tutorialAiReportDesc.
  ///
  /// In fr, this message translates to:
  /// **'Kauri analyse vos transactions et rédige un résumé en langage simple de vos habitudes de dépense, avec des conseils personnalisés.'**
  String get tutorialAiReportDesc;

  /// No description provided for @tutorialChartsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Répartition des dépenses'**
  String get tutorialChartsTitle;

  /// No description provided for @tutorialChartsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ce graphique répartit vos dépenses par catégorie pour repérer instantanément où part votre argent.'**
  String get tutorialChartsDesc;

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

  /// No description provided for @tutorialSettingsSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get tutorialSettingsSectionTitle;

  /// No description provided for @tutorialSettingsSectionDesc.
  ///
  /// In fr, this message translates to:
  /// **'Langue, thème, sécurité, notifications, KYC : toutes vos préférences de l\'application se trouvent ici.'**
  String get tutorialSettingsSectionDesc;

  /// No description provided for @tutorialCoachInputTitle.
  ///
  /// In fr, this message translates to:
  /// **'Posez une question à votre Coach IA'**
  String get tutorialCoachInputTitle;

  /// No description provided for @tutorialCoachInputDesc.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez n\'importe quelle question sur votre argent — \"Puis-je me permettre cet achat ?\", \"Comment épargner plus vite ?\" — et obtenez une réponse personnalisée basée sur vos données réelles.'**
  String get tutorialCoachInputDesc;

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

  /// No description provided for @tutorialGoalNameFieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nommez votre objectif'**
  String get tutorialGoalNameFieldTitle;

  /// No description provided for @tutorialGoalNameFieldDesc.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un nom clair et motivant (ex. \"Voyage à Paris\") : c\'est lui que vous verrez à chaque fois que vous suivrez votre progression.'**
  String get tutorialGoalNameFieldDesc;

  /// No description provided for @tutorialGoalAmountFieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fixez votre objectif'**
  String get tutorialGoalAmountFieldTitle;

  /// No description provided for @tutorialGoalAmountFieldDesc.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez le montant total que vous souhaitez épargner. Kauri l\'utilise pour calculer votre progression et suggérer un rythme d\'épargne.'**
  String get tutorialGoalAmountFieldDesc;

  /// No description provided for @tutorialBudgetCategoryFieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une catégorie'**
  String get tutorialBudgetCategoryFieldTitle;

  /// No description provided for @tutorialBudgetCategoryFieldDesc.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez la catégorie de dépense concernée par ce budget, pour que Kauri puisse la suivre automatiquement à partir de vos transactions.'**
  String get tutorialBudgetCategoryFieldDesc;

  /// No description provided for @tutorialBudgetAmountFieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fixez votre limite'**
  String get tutorialBudgetAmountFieldTitle;

  /// No description provided for @tutorialBudgetAmountFieldDesc.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez le montant maximum à dépenser dans cette catégorie ce mois-ci. Vous serez alerté(e) en vous en approchant.'**
  String get tutorialBudgetAmountFieldDesc;

  /// No description provided for @budgetInfoTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionnent les budgets ?'**
  String get budgetInfoTooltip;

  /// No description provided for @budgetInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionnent les budgets'**
  String get budgetInfoTitle;

  /// No description provided for @budgetInfoTrackingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivi automatique'**
  String get budgetInfoTrackingTitle;

  /// No description provided for @budgetInfoTrackingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Créez un budget mensuel en allouant un montant à une ou plusieurs catégories (ex. Alimentation, Transport). Chaque nouvelle dépense correspondant à cette catégorie est comptabilisée automatiquement — pas besoin de la saisir deux fois.'**
  String get budgetInfoTrackingDesc;

  /// No description provided for @budgetInfoAlertsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Alertes de dépassement'**
  String get budgetInfoAlertsTitle;

  /// No description provided for @budgetInfoAlertsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous recevez une notification dès qu\'une catégorie atteint 80% du montant alloué, puis une seconde si elle est dépassée.'**
  String get budgetInfoAlertsDesc;

  /// No description provided for @budgetInfoSharingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partage'**
  String get budgetInfoSharingTitle;

  /// No description provided for @budgetInfoSharingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Partagez un budget avec d\'autres personnes via un code d\'invitation : elles participent aux mêmes catégories, mais vous restez seul(e), en tant que propriétaire, à pouvoir modifier les montants alloués.'**
  String get budgetInfoSharingDesc;

  /// No description provided for @budgetInfoGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif lié'**
  String get budgetInfoGoalTitle;

  /// No description provided for @budgetInfoGoalDesc.
  ///
  /// In fr, this message translates to:
  /// **'Associez un budget à l\'un de vos objectifs d\'épargne pour garder le lien entre vos dépenses du mois et ce vers quoi vous économisez.'**
  String get budgetInfoGoalDesc;

  /// No description provided for @budgetInfoAutoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Génération automatique'**
  String get budgetInfoAutoTitle;

  /// No description provided for @budgetInfoAutoDesc.
  ///
  /// In fr, this message translates to:
  /// **'Anne peut analyser vos revenus et vos habitudes de dépenses pour vous proposer un budget déjà réparti par catégorie, que vous pouvez ensuite ajuster.'**
  String get budgetInfoAutoDesc;

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

  /// No description provided for @rotationModeLockedHint.
  ///
  /// In fr, this message translates to:
  /// **'Ne peut plus être modifié après la création'**
  String get rotationModeLockedHint;

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

  /// No description provided for @turnBeneficiaryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bénéficiaire de ce tour'**
  String get turnBeneficiaryLabel;

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

  /// No description provided for @recordingHint.
  ///
  /// In fr, this message translates to:
  /// **'Maintenez pour enregistrer...'**
  String get recordingHint;

  /// No description provided for @micPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Permission microphone refusée. Activez-la dans les paramètres.'**
  String get micPermissionDenied;

  /// No description provided for @recordingTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement trop court.'**
  String get recordingTooShort;

  /// No description provided for @voiceNoteFallbackLabel.
  ///
  /// In fr, this message translates to:
  /// **'Note vocale'**
  String get voiceNoteFallbackLabel;

  /// No description provided for @voiceNotePlaybackError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lire cette note vocale.'**
  String get voiceNotePlaybackError;

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
  /// **'Guide Complet Kauri'**
  String get tontineGuideTitle;

  /// No description provided for @tontineGuideDesc.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez comment optimiser votre épargne communautaire.'**
  String get tontineGuideDesc;

  /// No description provided for @whatIsTontineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Concept Kauri (Argent Réel)'**
  String get whatIsTontineTitle;

  /// No description provided for @whatIsTontineDesc.
  ///
  /// In fr, this message translates to:
  /// **'La tontine Kauri est une épargne collective sécurisée. Pour participer, vous devez être au Cameroun 🇨🇲 et avoir un profil KYC vérifié. Tout passe par votre Wallet Kauri.'**
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
  /// **'2. Action & Cotisation'**
  String get guideActiveTitle;

  /// No description provided for @guideActiveDesc.
  ///
  /// In fr, this message translates to:
  /// **'Le cycle a démarré. À chaque tour, cotisez via votre Wallet. L\'argent collecté est versé au bénéficiaire de manière transparente et sécurisée.'**
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
  /// **'• Fixe : L\'ordre est prédéfini.\n• Aléatoire : La chance décide du gagnant.'**
  String get guideRotationDesc;

  /// No description provided for @guideValidationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification assistée par IA'**
  String get guideValidationTitle;

  /// No description provided for @guideValidationDesc.
  ///
  /// In fr, this message translates to:
  /// **'Envoyez une capture de votre reçu NotchPay/Mobile Money dans le chat. Notre IA lit le montant et la référence pour aider le créateur de la tontine à confirmer votre cotisation.'**
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

  /// No description provided for @guideFinancialSafetyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité Financière & KYC'**
  String get guideFinancialSafetyTitle;

  /// No description provided for @guideFinancialSafetyDesc.
  ///
  /// In fr, this message translates to:
  /// **'La vérification d\'identité est obligatoire pour les flux réels. Les fonds sont cantonnés sur des comptes sécurisés pour garantir le paiement de chaque gagnant.'**
  String get guideFinancialSafetyDesc;

  /// No description provided for @biWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Bimensuelle'**
  String get biWeekly;

  /// No description provided for @payoutDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de versement'**
  String get payoutDetails;

  /// No description provided for @payoutDetailsHint.
  ///
  /// In fr, this message translates to:
  /// **'Numéro Mobile Money ou RIB'**
  String get payoutDetailsHint;

  /// No description provided for @tontineRestrictionCM.
  ///
  /// In fr, this message translates to:
  /// **'La création et l\'adhésion aux tontines sont réservées aux utilisateurs au Cameroun 🇨🇲.'**
  String get tontineRestrictionCM;

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

  /// No description provided for @socialFundPaymentRequired.
  ///
  /// In fr, this message translates to:
  /// **'Fonds social requis'**
  String get socialFundPaymentRequired;

  /// No description provided for @socialFundPaymentDescription.
  ///
  /// In fr, this message translates to:
  /// **'Payez votre part unique du fonds social avant le démarrage de la tontine.'**
  String get socialFundPaymentDescription;

  /// No description provided for @paySocialFundNow.
  ///
  /// In fr, this message translates to:
  /// **'Payer maintenant'**
  String get paySocialFundNow;

  /// No description provided for @socialFundPaidConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Fonds social payé avec succès !'**
  String get socialFundPaidConfirmation;

  /// No description provided for @socialFundPaidLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fonds social payé'**
  String get socialFundPaidLabel;

  /// No description provided for @socialFundUnpaidLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fonds social non payé'**
  String get socialFundUnpaidLabel;

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

  /// No description provided for @subscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get subscriptions;

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
  /// **'Prochains Abonnements'**
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

  /// No description provided for @tutorialIncomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Revenu Mensuel'**
  String get tutorialIncomeTitle;

  /// No description provided for @tutorialIncomeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Définissez votre revenu mensuel estimé pour permettre à Kauri de calculer votre capacité d\'épargne.'**
  String get tutorialIncomeDesc;

  /// No description provided for @verifyYourEmail.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre E-mail'**
  String get verifyYourEmail;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In fr, this message translates to:
  /// **'Un lien de vérification a été envoyé à votre adresse e-mail. Veuillez vérifier votre boîte de réception et cliquer sur le lien pour activer votre compte.'**
  String get verifyEmailDescription;

  /// No description provided for @backToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get backToLogin;

  /// No description provided for @premiumThemes.
  ///
  /// In fr, this message translates to:
  /// **'Thèmes Élite (Premium)'**
  String get premiumThemes;

  /// No description provided for @obsidianGoldThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Obsidienne & Or'**
  String get obsidianGoldThemeLabel;

  /// No description provided for @polarNightThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nuit Polaire'**
  String get polarNightThemeLabel;

  /// No description provided for @sunsetGlowThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Crépuscule'**
  String get sunsetGlowThemeLabel;

  /// No description provided for @emeraldForestThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Forêt d\'Émeraude'**
  String get emeraldForestThemeLabel;

  /// No description provided for @midnightRoyalThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Royal de Minuit'**
  String get midnightRoyalThemeLabel;

  /// No description provided for @roseVelvetThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Velours Rose'**
  String get roseVelvetThemeLabel;

  /// No description provided for @rubyEmberThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Braise Rubis'**
  String get rubyEmberThemeLabel;

  /// No description provided for @oceanAbyssThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Abysse Océanique'**
  String get oceanAbyssThemeLabel;

  /// No description provided for @cyberNeonThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Néon Cyber'**
  String get cyberNeonThemeLabel;

  /// No description provided for @champagnePearlThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nacre Champagne'**
  String get champagnePearlThemeLabel;

  /// No description provided for @standardThemesLabel.
  ///
  /// In fr, this message translates to:
  /// **'STANDARD'**
  String get standardThemesLabel;

  /// No description provided for @premiumThemesLabel.
  ///
  /// In fr, this message translates to:
  /// **'PREMIUM'**
  String get premiumThemesLabel;

  /// No description provided for @fontFamily.
  ///
  /// In fr, this message translates to:
  /// **'Police d\'écriture'**
  String get fontFamily;

  /// No description provided for @elegantFont.
  ///
  /// In fr, this message translates to:
  /// **'Élégant (Playfair)'**
  String get elegantFont;

  /// No description provided for @modernFont.
  ///
  /// In fr, this message translates to:
  /// **'Moderne (Poppins)'**
  String get modernFont;

  /// No description provided for @technicalFont.
  ///
  /// In fr, this message translates to:
  /// **'Technique (Roboto Mono)'**
  String get technicalFont;

  /// No description provided for @classicFont.
  ///
  /// In fr, this message translates to:
  /// **'Classique (Outfit)'**
  String get classicFont;

  /// No description provided for @sectionAccount.
  ///
  /// In fr, this message translates to:
  /// **'Mon Compte'**
  String get sectionAccount;

  /// No description provided for @sectionAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get sectionAppearance;

  /// No description provided for @sectionLegal.
  ///
  /// In fr, this message translates to:
  /// **'Aide & Informations'**
  String get sectionLegal;

  /// No description provided for @sectionDanger.
  ///
  /// In fr, this message translates to:
  /// **'Zone de Danger'**
  String get sectionDanger;

  /// No description provided for @coachTone.
  ///
  /// In fr, this message translates to:
  /// **'Ton du Coach'**
  String get coachTone;

  /// No description provided for @toneBalanced.
  ///
  /// In fr, this message translates to:
  /// **'Équilibré (Recommandé)'**
  String get toneBalanced;

  /// No description provided for @toneEncouraging.
  ///
  /// In fr, this message translates to:
  /// **'Encourageant'**
  String get toneEncouraging;

  /// No description provided for @toneFirm.
  ///
  /// In fr, this message translates to:
  /// **'Directif'**
  String get toneFirm;

  /// No description provided for @toneBillionaire.
  ///
  /// In fr, this message translates to:
  /// **'Mentor Milliardaire'**
  String get toneBillionaire;

  /// No description provided for @toneAccountant.
  ///
  /// In fr, this message translates to:
  /// **'Comptable Strict'**
  String get toneAccountant;

  /// No description provided for @toneAuntie.
  ///
  /// In fr, this message translates to:
  /// **'Tata Bienveillante'**
  String get toneAuntie;

  /// No description provided for @notificationFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence des Notifications'**
  String get notificationFrequency;

  /// No description provided for @freqHigh.
  ///
  /// In fr, this message translates to:
  /// **'Élevée (Toutes les actus)'**
  String get freqHigh;

  /// No description provided for @freqMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne (Essentiel)'**
  String get freqMedium;

  /// No description provided for @freqLow.
  ///
  /// In fr, this message translates to:
  /// **'Faible (Critique uniquement)'**
  String get freqLow;

  /// No description provided for @generateViaAnne.
  ///
  /// In fr, this message translates to:
  /// **'Générer via Anne'**
  String get generateViaAnne;

  /// No description provided for @anneAnalyzing.
  ///
  /// In fr, this message translates to:
  /// **'Anne analyse vos finances...'**
  String get anneAnalyzing;

  /// No description provided for @applyBudgets.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get applyBudgets;

  /// No description provided for @anneAnalysisTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse d\'Anne'**
  String get anneAnalysisTitle;

  /// No description provided for @autoBudgetSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Budgets appliqués avec succès !'**
  String get autoBudgetSuccess;

  /// No description provided for @tutorialAnneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Génération Auto'**
  String get tutorialAnneTitle;

  /// No description provided for @tutorialAnneDesc.
  ///
  /// In fr, this message translates to:
  /// **'Anne analyse vos revenus et d\'épenses pour vous proposer un budget optimisé pour le mois à venir.'**
  String get tutorialAnneDesc;

  /// No description provided for @budgetExistsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Budget déjà existant'**
  String get budgetExistsTitle;

  /// No description provided for @budgetExistsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Un budget pour cette période existe déjà. Voulez-vous le remplacer par l\'analyse d\'Anne ?'**
  String get budgetExistsMessage;

  /// No description provided for @replaceBudget.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer'**
  String get replaceBudget;

  /// No description provided for @success.
  ///
  /// In fr, this message translates to:
  /// **'Succès'**
  String get success;

  /// No description provided for @debtType.
  ///
  /// In fr, this message translates to:
  /// **'Dette'**
  String get debtType;

  /// No description provided for @strategy_snowball.
  ///
  /// In fr, this message translates to:
  /// **'Boule de neige'**
  String get strategy_snowball;

  /// No description provided for @strategy_snowball_desc.
  ///
  /// In fr, this message translates to:
  /// **'Remboursez vos plus petites dettes en premier pour gagner en élan.'**
  String get strategy_snowball_desc;

  /// No description provided for @strategy_avalanche.
  ///
  /// In fr, this message translates to:
  /// **'Avalanche'**
  String get strategy_avalanche;

  /// No description provided for @strategy_avalanche_desc.
  ///
  /// In fr, this message translates to:
  /// **'Remboursez les dettes aux taux d\'intérêt les plus élevés pour économiser.'**
  String get strategy_avalanche_desc;

  /// No description provided for @repaymentAction.
  ///
  /// In fr, this message translates to:
  /// **'Rembourser'**
  String get repaymentAction;

  /// No description provided for @repaymentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement enregistré avec succès'**
  String get repaymentSuccess;

  /// No description provided for @repaymentDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer un remboursement'**
  String get repaymentDialogTitle;

  /// No description provided for @repaymentAmountHint.
  ///
  /// In fr, this message translates to:
  /// **'Montant à rembourser'**
  String get repaymentAmountHint;

  /// No description provided for @noteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Échéance de Janvier'**
  String get noteHint;

  /// No description provided for @historyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Historique des contributions'**
  String get historyLabel;

  /// No description provided for @contributionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contribution'**
  String get contributionLabel;

  /// No description provided for @withdrawalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Retrait'**
  String get withdrawalLabel;

  /// No description provided for @goalForcedExpenseHint.
  ///
  /// In fr, this message translates to:
  /// **'L\'épargne pour un objectif est enregistrée comme une dépense de votre portefeuille.'**
  String get goalForcedExpenseHint;

  /// No description provided for @debtRepaymentWarningHint.
  ///
  /// In fr, this message translates to:
  /// **'Ce remboursement est enregistré comme une dépense de votre portefeuille et débite votre solde Kauri immédiatement.'**
  String get debtRepaymentWarningHint;

  /// No description provided for @enableSurplusDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous suggère chaque mois de verser dans cet objectif ce qu\'il vous reste après vos dépenses — c\'est vous qui décidez, aucun débit automatique.'**
  String get enableSurplusDesc;

  /// No description provided for @enableRoundupDesc.
  ///
  /// In fr, this message translates to:
  /// **'Arrondit vos dépenses à l\'euro supérieur et épargne la différence.'**
  String get enableRoundupDesc;

  /// No description provided for @percentageIncomeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Pourcentage de chaque revenu automatiquement mis de côté.'**
  String get percentageIncomeDesc;

  /// No description provided for @featureDisabledTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalité Indisponible'**
  String get featureDisabledTitle;

  /// No description provided for @featureDisabledMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette fonctionnalité est actuellement désactivée. Veuillez contacter le support ou réessayer plus tard.'**
  String get featureDisabledMessage;

  /// No description provided for @featureUpdateRequiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette fonctionnalité nécessite une version plus récente de Kauri. Veuillez mettre à jour votre application pour en profiter.'**
  String get featureUpdateRequiredMessage;

  /// No description provided for @fintechOnlyCameroon.
  ///
  /// In fr, this message translates to:
  /// **'Les services financiers (Wallet, Recharges, Retraits) sont actuellement réservés aux utilisateurs résidant au Cameroun 🇨🇲.'**
  String get fintechOnlyCameroon;

  /// No description provided for @featureRestrictedCountry.
  ///
  /// In fr, this message translates to:
  /// **'Cette fonctionnalité n\'est pas disponible dans votre pays.'**
  String get featureRestrictedCountry;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @addCustomCategory.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une catégorie personnalisée'**
  String get addCustomCategory;

  /// No description provided for @kycStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut KYC'**
  String get kycStatus;

  /// No description provided for @kycVerified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifié'**
  String get kycVerified;

  /// No description provided for @kycPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get kycPending;

  /// No description provided for @kycPendingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vos documents sont en cours d\'analyse par notre équipe.'**
  String get kycPendingDesc;

  /// No description provided for @kycRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejeté'**
  String get kycRejected;

  /// No description provided for @kycNotSubmitted.
  ///
  /// In fr, this message translates to:
  /// **'Non soumis'**
  String get kycNotSubmitted;

  /// No description provided for @kycAction.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier mon identité'**
  String get kycAction;

  /// No description provided for @autoBudgetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Budget Automatisé IA'**
  String get autoBudgetTitle;

  /// No description provided for @autoBudgetDesc.
  ///
  /// In fr, this message translates to:
  /// **'Laissez Kauri optimiser vos limites en fonction de vos revenus.'**
  String get autoBudgetDesc;

  /// No description provided for @premiumReportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rapport Financier Premium'**
  String get premiumReportTitle;

  /// No description provided for @premiumReportDesc.
  ///
  /// In fr, this message translates to:
  /// **'Analyse approfondie de votre santé financière ce mois-ci.'**
  String get premiumReportDesc;

  /// No description provided for @challengeTypeSaving.
  ///
  /// In fr, this message translates to:
  /// **'Épargne'**
  String get challengeTypeSaving;

  /// No description provided for @challengeTypeSpending.
  ///
  /// In fr, this message translates to:
  /// **'Réduction de dépenses'**
  String get challengeTypeSpending;

  /// No description provided for @challengeTypeHabit.
  ///
  /// In fr, this message translates to:
  /// **'Habitude'**
  String get challengeTypeHabit;

  /// No description provided for @challengeSkipAction.
  ///
  /// In fr, this message translates to:
  /// **'Passer la semaine'**
  String get challengeSkipAction;

  /// No description provided for @challengePostponeAction.
  ///
  /// In fr, this message translates to:
  /// **'Reporter'**
  String get challengePostponeAction;

  /// No description provided for @challengeSkipsRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{count} sauts restants'**
  String challengeSkipsRemaining(int count);

  /// No description provided for @trustScore.
  ///
  /// In fr, this message translates to:
  /// **'Trust Score'**
  String get trustScore;

  /// No description provided for @trustScoreDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre réputation financière Kauri.'**
  String get trustScoreDesc;

  /// No description provided for @xpEarned.
  ///
  /// In fr, this message translates to:
  /// **'+{points} XP'**
  String xpEarned(int points);

  /// No description provided for @challengeSkipConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment passer cette semaine ?'**
  String get challengeSkipConfirm;

  /// No description provided for @challengePostponeConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous reporter la deadline de 48h ?'**
  String get challengePostponeConfirm;

  /// No description provided for @challengeProofRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez ajouter une preuve d\'image'**
  String get challengeProofRequired;

  /// No description provided for @transactionProof.
  ///
  /// In fr, this message translates to:
  /// **'Preuve de transaction'**
  String get transactionProof;

  /// No description provided for @photo.
  ///
  /// In fr, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @gallery.
  ///
  /// In fr, this message translates to:
  /// **'Galerie'**
  String get gallery;

  /// No description provided for @walletTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon Portefeuille'**
  String get walletTitle;

  /// No description provided for @recentTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions récentes'**
  String get recentTransactions;

  /// No description provided for @availableBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde disponible'**
  String get availableBalance;

  /// No description provided for @incomes.
  ///
  /// In fr, this message translates to:
  /// **'Entrées'**
  String get incomes;

  /// No description provided for @outcomes.
  ///
  /// In fr, this message translates to:
  /// **'Sorties'**
  String get outcomes;

  /// No description provided for @recharge.
  ///
  /// In fr, this message translates to:
  /// **'Recharger'**
  String get recharge;

  /// No description provided for @withdraw.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get withdraw;

  /// No description provided for @transferLimitInfo.
  ///
  /// In fr, this message translates to:
  /// **'Cette limite inclut tous vos transferts sortants pour le mois en cours.'**
  String get transferLimitInfo;

  /// No description provided for @tutorialWalletTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre Portefeuille'**
  String get tutorialWalletTitle;

  /// No description provided for @tutorialWalletDesc.
  ///
  /// In fr, this message translates to:
  /// **'Cliquez ici pour accéder aux détails de votre portefeuille, effectuer des dépôts ou des retraits.'**
  String get tutorialWalletDesc;

  /// No description provided for @realMoneyWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Gestion de l\'Argent Réel'**
  String get realMoneyWelcomeTitle;

  /// No description provided for @realMoneySlide1Title.
  ///
  /// In fr, this message translates to:
  /// **'L\'Argent Réel arrive sur Kauri !'**
  String get realMoneySlide1Title;

  /// No description provided for @realMoneySlide1Desc.
  ///
  /// In fr, this message translates to:
  /// **'Kauri passe au niveau supérieur ! Vous pouvez désormais gérer votre vrai argent directement depuis l\'application.'**
  String get realMoneySlide1Desc;

  /// No description provided for @realMoneySlide2Title.
  ///
  /// In fr, this message translates to:
  /// **'Portefeuille'**
  String get realMoneySlide2Title;

  /// No description provided for @realMoneySlide2Desc.
  ///
  /// In fr, this message translates to:
  /// **'Dépôts et retraits facilités via Mobile Money en toute sécurité.'**
  String get realMoneySlide2Desc;

  /// No description provided for @realMoneySlide3Title.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs'**
  String get realMoneySlide3Title;

  /// No description provided for @realMoneySlide3Desc.
  ///
  /// In fr, this message translates to:
  /// **'Vos épargnes sont désormais réelles et sécurisées. Plus besoin de simuler vos finances !'**
  String get realMoneySlide3Desc;

  /// No description provided for @realMoneySlide4Title.
  ///
  /// In fr, this message translates to:
  /// **'Tontines'**
  String get realMoneySlide4Title;

  /// No description provided for @realMoneySlide4Desc.
  ///
  /// In fr, this message translates to:
  /// **'Automatisez vos prélèvements et paiements pour vos tontines sans tracas.'**
  String get realMoneySlide4Desc;

  /// No description provided for @gotItButton.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai compris !'**
  String get gotItButton;

  /// No description provided for @nextButton.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get nextButton;

  /// No description provided for @noTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction pour le moment'**
  String get noTransactions;

  /// No description provided for @autoDebit.
  ///
  /// In fr, this message translates to:
  /// **'Auto-Débit'**
  String get autoDebit;

  /// No description provided for @rotateTurn.
  ///
  /// In fr, this message translates to:
  /// **'Lancer la Rotation'**
  String get rotateTurn;

  /// No description provided for @deadlineLabelTontine.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get deadlineLabelTontine;

  /// No description provided for @confirmRotateTurn.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment lancer la rotation du tour ?'**
  String get confirmRotateTurn;

  /// No description provided for @kycTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification d\'identité'**
  String get kycTitle;

  /// No description provided for @kycStepTitle.
  ///
  /// In fr, this message translates to:
  /// **'Étape cruciale pour Kauri'**
  String get kycStepTitle;

  /// No description provided for @kycStepDesc.
  ///
  /// In fr, this message translates to:
  /// **'Pour des raisons de sécurité et de conformité financière, nous devons vérifier votre identité.'**
  String get kycStepDesc;

  /// No description provided for @kycFullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet (tel que sur le document)'**
  String get kycFullNameLabel;

  /// No description provided for @kycDocTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de document'**
  String get kycDocTypeLabel;

  /// No description provided for @kycDocNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro du document'**
  String get kycDocNumberLabel;

  /// No description provided for @kycDocPhotoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Photo du document'**
  String get kycDocPhotoLabel;

  /// No description provided for @kycSelfieLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre Selfie'**
  String get kycSelfieLabel;

  /// No description provided for @kycSubmitAction.
  ///
  /// In fr, this message translates to:
  /// **'Soumettre pour vérification'**
  String get kycSubmitAction;

  /// No description provided for @kycUploadClick.
  ///
  /// In fr, this message translates to:
  /// **'Cliquez pour uploader'**
  String get kycUploadClick;

  /// No description provided for @kycMissingPhotos.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez fournir les deux photos'**
  String get kycMissingPhotos;

  /// No description provided for @required.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get required;

  /// No description provided for @rechargeMethod.
  ///
  /// In fr, this message translates to:
  /// **'Méthode de recharge'**
  String get rechargeMethod;

  /// No description provided for @notchpayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money (Local)'**
  String get notchpayLabel;

  /// No description provided for @stripeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Carte Bancaire (International)'**
  String get stripeLabel;

  /// No description provided for @withdrawOperator.
  ///
  /// In fr, this message translates to:
  /// **'Opérateur'**
  String get withdrawOperator;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In fr, this message translates to:
  /// **'6XXXXXXXX'**
  String get phoneNumberHint;

  /// No description provided for @confirmAction.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirmAction;

  /// No description provided for @invalidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get invalidAmount;

  /// No description provided for @insufficientBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant'**
  String get insufficientBalance;

  /// No description provided for @rechargeSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Recharge initiée ! Redirection...'**
  String get rechargeSuccess;

  /// No description provided for @withdrawSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Demande de retrait soumise avec succès'**
  String get withdrawSuccess;

  /// No description provided for @tutorialWalletRechargeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recharger votre compte'**
  String get tutorialWalletRechargeTitle;

  /// No description provided for @tutorialWalletRechargeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Cliquez ici pour approvisionner votre solde via Mobile Money ou Carte Bancaire.'**
  String get tutorialWalletRechargeDesc;

  /// No description provided for @rechargeLimitError.
  ///
  /// In fr, this message translates to:
  /// **'Le montant de recharge est limité à 50 000 FCFA par transaction.'**
  String get rechargeLimitError;

  /// No description provided for @kycDocInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations du document'**
  String get kycDocInfoTitle;

  /// No description provided for @kycDocFrontTitle.
  ///
  /// In fr, this message translates to:
  /// **'1. Pièce d\'identité - Recto (Face avant)'**
  String get kycDocFrontTitle;

  /// No description provided for @kycDocFrontSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Photo claire ou document PDF (Requis)'**
  String get kycDocFrontSubtitle;

  /// No description provided for @kycDocBackTitle.
  ///
  /// In fr, this message translates to:
  /// **'2. Pièce d\'identité - Verso (Face arrière)'**
  String get kycDocBackTitle;

  /// No description provided for @kycDocBackSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Photo du dos de la pièce (Facultatif mais conseillé)'**
  String get kycDocBackSubtitle;

  /// No description provided for @kycDocTypeCni.
  ///
  /// In fr, this message translates to:
  /// **'Carte Nationale d\'Identité (CNI)'**
  String get kycDocTypeCni;

  /// No description provided for @kycDocTypePassport.
  ///
  /// In fr, this message translates to:
  /// **'Passeport'**
  String get kycDocTypePassport;

  /// No description provided for @kycDocTypeLicense.
  ///
  /// In fr, this message translates to:
  /// **'Permis de conduire'**
  String get kycDocTypeLicense;

  /// No description provided for @kycDocTypeResidence.
  ///
  /// In fr, this message translates to:
  /// **'Titre de séjour / Résident'**
  String get kycDocTypeResidence;

  /// No description provided for @kycImportMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le moyen d\'importer votre document :'**
  String get kycImportMethodTitle;

  /// No description provided for @kycImportMethodCamera.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une photo'**
  String get kycImportMethodCamera;

  /// No description provided for @kycImportMethodCameraSub.
  ///
  /// In fr, this message translates to:
  /// **'Caméra arrière (cadrage net)'**
  String get kycImportMethodCameraSub;

  /// No description provided for @kycImportMethodGallery.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une image'**
  String get kycImportMethodGallery;

  /// No description provided for @kycImportMethodGallerySub.
  ///
  /// In fr, this message translates to:
  /// **'Depuis votre galerie (JPG, PNG, WEBP)'**
  String get kycImportMethodGallerySub;

  /// No description provided for @kycImportMethodPdf.
  ///
  /// In fr, this message translates to:
  /// **'Importer un document PDF'**
  String get kycImportMethodPdf;

  /// No description provided for @kycImportMethodPdfSub.
  ///
  /// In fr, this message translates to:
  /// **'Fichier PDF (scan officiel, max 10 Mo)'**
  String get kycImportMethodPdfSub;

  /// No description provided for @kycSelfieStepTitle.
  ///
  /// In fr, this message translates to:
  /// **'3. Selfie de vérification'**
  String get kycSelfieStepTitle;

  /// No description provided for @kycSelfieStepSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Photo nette de votre visage prise avec la caméra avant'**
  String get kycSelfieStepSubtitle;

  /// No description provided for @kycSelfieSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prendre votre Selfie'**
  String get kycSelfieSheetTitle;

  /// No description provided for @kycSelfieSheetSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Positionnez votre visage bien au centre, sans lunettes de soleil ni chapeau :'**
  String get kycSelfieSheetSubtitle;

  /// No description provided for @kycSelfieCameraTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prendre un selfie maintenant'**
  String get kycSelfieCameraTitle;

  /// No description provided for @kycSelfieCameraSub.
  ///
  /// In fr, this message translates to:
  /// **'Caméra frontale nette et centrée'**
  String get kycSelfieCameraSub;

  /// No description provided for @kycSelfieGalleryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une photo récente'**
  String get kycSelfieGalleryTitle;

  /// No description provided for @kycSelfieGallerySub.
  ///
  /// In fr, this message translates to:
  /// **'Depuis votre galerie photo'**
  String get kycSelfieGallerySub;

  /// No description provided for @kycSelfieAction.
  ///
  /// In fr, this message translates to:
  /// **'Prendre un selfie (Caméra avant)'**
  String get kycSelfieAction;

  /// No description provided for @kycSelfieActionSub.
  ///
  /// In fr, this message translates to:
  /// **'Touchez pour lancer la caméra avant'**
  String get kycSelfieActionSub;

  /// No description provided for @kycSelfieRetake.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get kycSelfieRetake;

  /// No description provided for @kycSelfieMirrorActive.
  ///
  /// In fr, this message translates to:
  /// **'Miroir activé'**
  String get kycSelfieMirrorActive;

  /// No description provided for @kycSelfieMirrorToggle.
  ///
  /// In fr, this message translates to:
  /// **'Inverser / Miroir'**
  String get kycSelfieMirrorToggle;

  /// No description provided for @kycDocPdfLabel.
  ///
  /// In fr, this message translates to:
  /// **'Document PDF'**
  String get kycDocPdfLabel;

  /// No description provided for @kycDocPdfAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Format PDF accepté'**
  String get kycDocPdfAccepted;

  /// No description provided for @kycDocPhotoOrPdf.
  ///
  /// In fr, this message translates to:
  /// **'Photo ou PDF (JPG, PNG, PDF)'**
  String get kycDocPhotoOrPdf;

  /// No description provided for @kycDocTapToUpload.
  ///
  /// In fr, this message translates to:
  /// **'Touchez pour importer le document'**
  String get kycDocTapToUpload;

  /// No description provided for @kycDocChange.
  ///
  /// In fr, this message translates to:
  /// **'Changer'**
  String get kycDocChange;

  /// No description provided for @kycUploadingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Téléversement en cours...'**
  String get kycUploadingTitle;

  /// No description provided for @kycUploadStep1.
  ///
  /// In fr, this message translates to:
  /// **'1/3 - Préparation des fichiers et chiffrement...'**
  String get kycUploadStep1;

  /// No description provided for @kycUploadStep2.
  ///
  /// In fr, this message translates to:
  /// **'2/3 - Téléversement de la pièce d\'identité...'**
  String get kycUploadStep2;

  /// No description provided for @kycUploadStep3.
  ///
  /// In fr, this message translates to:
  /// **'3/3 - Validation et vérification biométrique...'**
  String get kycUploadStep3;

  /// No description provided for @kycSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification validée avec succès !'**
  String get kycSuccessTitle;

  /// No description provided for @kycSuccessSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos documents KYC ont été soumis avec succès.'**
  String get kycSuccessSubtitle;

  /// No description provided for @kycMissingFront.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez fournir le document d\'identité (Recto).'**
  String get kycMissingFront;

  /// No description provided for @kycMissingSelfie.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez prendre un selfie de vérification.'**
  String get kycMissingSelfie;

  /// No description provided for @kycPendingDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification en cours'**
  String get kycPendingDialogTitle;

  /// No description provided for @kycPendingDialogMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vos documents d\'identité sont actuellement en cours d\'examen par notre équipe. Ce processus prend généralement entre 24h et 48h. Vous recevrez une notification dès que la validation sera effectuée.'**
  String get kycPendingDialogMessage;

  /// No description provided for @kycVerifiedDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Identité vérifiée'**
  String get kycVerifiedDialogTitle;

  /// No description provided for @kycVerifiedDialogMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte est certifié et votre identité est validée. Toutes les limites et opérations sont débloquées.'**
  String get kycVerifiedDialogMessage;

  /// No description provided for @kycPendingPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dossier en cours d\'examen'**
  String get kycPendingPageTitle;

  /// No description provided for @kycPendingPageSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous analysons actuellement vos documents et votre selfie. Vous n\'avez aucune action supplémentaire à effectuer.'**
  String get kycPendingPageSubtitle;

  /// No description provided for @kycPendingEstimatedTime.
  ///
  /// In fr, this message translates to:
  /// **'Délai moyen de traitement : 24h à 48h'**
  String get kycPendingEstimatedTime;

  /// No description provided for @kycPendingUnderReviewBadge.
  ///
  /// In fr, this message translates to:
  /// **'Examen en cours'**
  String get kycPendingUnderReviewBadge;

  /// No description provided for @kycPendingDocumentsSent.
  ///
  /// In fr, this message translates to:
  /// **'Pièce d\'identité et selfie transmis'**
  String get kycPendingDocumentsSent;

  /// No description provided for @kycBackToProfile.
  ///
  /// In fr, this message translates to:
  /// **'Retour au profil'**
  String get kycBackToProfile;

  /// No description provided for @kycBackToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get kycBackToHome;

  /// No description provided for @kycRejectedNotice.
  ///
  /// In fr, this message translates to:
  /// **'Votre précédente soumission a été rejetée. Veuillez vérifier la netteté de vos documents et soumettre à nouveau.'**
  String get kycRejectedNotice;

  /// No description provided for @kycDocExpiryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'expiration du document'**
  String get kycDocExpiryLabel;

  /// No description provided for @kycDocExpiryHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la date d\'expiration'**
  String get kycDocExpiryHint;

  /// No description provided for @kycDocExpiryRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez renseigner la date d\'expiration du document'**
  String get kycDocExpiryRequired;

  /// No description provided for @kycDocExpiryInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Le document est expiré ou la date est dépassée'**
  String get kycDocExpiryInvalid;

  /// No description provided for @kycUpdateRequiredNotice.
  ///
  /// In fr, this message translates to:
  /// **'Votre dossier KYC nécessite une mise à jour (document expiré ou informations à renouveler). Vos précédentes informations ont été pré-remplies ci-dessous.'**
  String get kycUpdateRequiredNotice;

  /// No description provided for @kycExistingDocKept.
  ///
  /// In fr, this message translates to:
  /// **'Document actuel enregistré'**
  String get kycExistingDocKept;

  /// No description provided for @kycReplaceDoc.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer le fichier'**
  String get kycReplaceDoc;

  /// No description provided for @kycStatusExpired.
  ///
  /// In fr, this message translates to:
  /// **'Document Expiré'**
  String get kycStatusExpired;

  /// No description provided for @kycStatusUpdateRequired.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour requise'**
  String get kycStatusUpdateRequired;

  /// No description provided for @txStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Réussie'**
  String get txStatusCompleted;

  /// No description provided for @txStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get txStatusPending;

  /// No description provided for @txStatusFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échouée'**
  String get txStatusFailed;

  /// No description provided for @txStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get txStatusCancelled;

  /// No description provided for @withdrawSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail de l\'opération'**
  String get withdrawSummaryTitle;

  /// No description provided for @withdrawAmountRequested.
  ///
  /// In fr, this message translates to:
  /// **'Montant du retrait'**
  String get withdrawAmountRequested;

  /// No description provided for @withdrawFeesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Frais de retrait'**
  String get withdrawFeesLabel;

  /// No description provided for @withdrawTotalDebited.
  ///
  /// In fr, this message translates to:
  /// **'Total débité'**
  String get withdrawTotalDebited;

  /// No description provided for @withdrawRemainingBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde restant après retrait'**
  String get withdrawRemainingBalance;

  /// No description provided for @withdrawPremiumDiscountTag.
  ///
  /// In fr, this message translates to:
  /// **'Réduction Premium -50%'**
  String get withdrawPremiumDiscountTag;

  /// No description provided for @withdrawFreeFeeHint.
  ///
  /// In fr, this message translates to:
  /// **'Frais standards de 3% (min 100 FCFA). Passez à Premium pour bénéficier de 1.5% !'**
  String get withdrawFreeFeeHint;

  /// No description provided for @withdrawPremiumFeeHint.
  ///
  /// In fr, this message translates to:
  /// **'Frais réduits Premium de 1.5% (min 100 FCFA) appliqués !'**
  String get withdrawPremiumFeeHint;

  /// No description provided for @withdrawMinAmountError.
  ///
  /// In fr, this message translates to:
  /// **'Le montant minimum de retrait est de 500 FCFA'**
  String get withdrawMinAmountError;

  /// No description provided for @withdrawMaxAmountError.
  ///
  /// In fr, this message translates to:
  /// **'Le montant maximum par retrait est de 50 000 FCFA'**
  String get withdrawMaxAmountError;

  /// No description provided for @withdrawInsufficientFundsForFees.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant pour couvrir le montant et les frais'**
  String get withdrawInsufficientFundsForFees;

  /// No description provided for @withdrawInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Traitement de votre retrait...'**
  String get withdrawInProgress;

  /// No description provided for @withdrawInProgressHint.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez patienter, ne fermez pas l\'application.'**
  String get withdrawInProgressHint;

  /// No description provided for @budgetSavingInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement du budget...'**
  String get budgetSavingInProgress;

  /// No description provided for @walletPaymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Portefeuille Kauri'**
  String get walletPaymentMethod;

  /// No description provided for @walletPaymentSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Payer instantanément avec votre solde ({balance})'**
  String walletPaymentSubtitle(Object balance);

  /// No description provided for @walletInsufficientBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant dans votre portefeuille pour souscrire'**
  String get walletInsufficientBalance;

  /// No description provided for @walletSubscriptionSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations ! Votre abonnement Premium est maintenant actif.'**
  String get walletSubscriptionSuccess;

  /// No description provided for @walletSubscriptionConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Payer avec le portefeuille'**
  String get walletSubscriptionConfirmTitle;

  /// No description provided for @walletSubscriptionConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous débiter {amount} de votre portefeuille Kauri pour activer l\'abonnement Premium (1 mois) ?'**
  String walletSubscriptionConfirmMessage(Object amount);

  /// No description provided for @otherTools.
  ///
  /// In fr, this message translates to:
  /// **'Autres outils'**
  String get otherTools;

  /// No description provided for @resellerGuideTitle.
  ///
  /// In fr, this message translates to:
  /// **'Guide Espace Revendeur'**
  String get resellerGuideTitle;

  /// No description provided for @resellerGuideSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionne la gestion des abonnements partagés ?'**
  String get resellerGuideSubtitle;

  /// No description provided for @resellerGuideMasterTitle.
  ///
  /// In fr, this message translates to:
  /// **'1. Comptes Maîtres (Vos abonnements)'**
  String get resellerGuideMasterTitle;

  /// No description provided for @resellerGuideMasterDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous enregistrez ici vos comptes d\'origine (Netflix, Spotify, Canva...). Vous y définissez ce que vous payez au fournisseur et la date de renouvellement de votre abonnement.'**
  String get resellerGuideMasterDesc;

  /// No description provided for @resellerGuideSlotsTitle.
  ///
  /// In fr, this message translates to:
  /// **'2. Profils & Slots Clients'**
  String get resellerGuideSlotsTitle;

  /// No description provided for @resellerGuideSlotsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Chaque compte est découpé en slots (écrans/profils). Vous attribuez chaque slot à un client avec son nom, son numéro WhatsApp, son prix de revente et sa date de début.'**
  String get resellerGuideSlotsDesc;

  /// No description provided for @resellerGuidePaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'3. \'Marquer comme payé\''**
  String get resellerGuidePaymentTitle;

  /// No description provided for @resellerGuidePaymentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Quand votre client vous règle, cliquez sur son profil puis \'Marquer comme payé\'. Le système enregistre l\'historique et prolonge automatiquement son accès d\'un mois (le badge repasse au vert).'**
  String get resellerGuidePaymentDesc;

  /// No description provided for @resellerGuideQuotasTitle.
  ///
  /// In fr, this message translates to:
  /// **'4. Quotas par Forfait'**
  String get resellerGuideQuotasTitle;

  /// No description provided for @resellerGuideQuotasFree.
  ///
  /// In fr, this message translates to:
  /// **'• Forfait Gratuit : Jusqu\'à 2 comptes maîtres et 3 profils clients.'**
  String get resellerGuideQuotasFree;

  /// No description provided for @resellerGuideQuotasPremium.
  ///
  /// In fr, this message translates to:
  /// **'• Forfait Premium : Jusqu\'à 3 comptes maîtres et 10 profils clients.'**
  String get resellerGuideQuotasPremium;

  /// No description provided for @resellerGuideQuotasBusiness.
  ///
  /// In fr, this message translates to:
  /// **'• Forfait Business : Comptes et profils illimités, exports comptables et statistiques avancées.'**
  String get resellerGuideQuotasBusiness;

  /// No description provided for @businessPlan.
  ///
  /// In fr, this message translates to:
  /// **'Business (Reseller Hub Pro)'**
  String get businessPlan;

  /// No description provided for @businessPlanDesc.
  ///
  /// In fr, this message translates to:
  /// **'La formule ultime pour gérer vos finances et votre activité de revendeur d\'abonnements.'**
  String get businessPlanDesc;

  /// No description provided for @businessFeatureResellerUnlimited.
  ///
  /// In fr, this message translates to:
  /// **'Hub Revendeur : Comptes & Profils illimités'**
  String get businessFeatureResellerUnlimited;

  /// No description provided for @businessFeatureAutoReminders.
  ///
  /// In fr, this message translates to:
  /// **'Relances & Rappels WhatsApp automatisés'**
  String get businessFeatureAutoReminders;

  /// No description provided for @businessFeatureAccountingExports.
  ///
  /// In fr, this message translates to:
  /// **'Exports comptables & bilans en 1 clic'**
  String get businessFeatureAccountingExports;

  /// No description provided for @businessFeatureAdvancedStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques & prévisions financières avancées'**
  String get businessFeatureAdvancedStats;

  /// No description provided for @businessFeatureVIPSupport.
  ///
  /// In fr, this message translates to:
  /// **'Support VIP dédié & prioritaire'**
  String get businessFeatureVIPSupport;

  /// No description provided for @upgradeToBusiness.
  ///
  /// In fr, this message translates to:
  /// **'Passer à Super Premium'**
  String get upgradeToBusiness;

  /// No description provided for @currentBusinessPlan.
  ///
  /// In fr, this message translates to:
  /// **'Votre forfait Business actif'**
  String get currentBusinessPlan;

  /// No description provided for @businessPrice.
  ///
  /// In fr, this message translates to:
  /// **'5 000 FCFA/mois'**
  String get businessPrice;

  /// No description provided for @businessFeature1.
  ///
  /// In fr, this message translates to:
  /// **'Tout le forfait Premium inclus'**
  String get businessFeature1;

  /// No description provided for @businessFeature2.
  ///
  /// In fr, this message translates to:
  /// **'Services & Comptes Maîtres Illimités'**
  String get businessFeature2;

  /// No description provided for @businessFeature3.
  ///
  /// In fr, this message translates to:
  /// **'Slots & Profils Clients Illimités'**
  String get businessFeature3;

  /// No description provided for @businessFeature4.
  ///
  /// In fr, this message translates to:
  /// **'Relances Automatiques WhatsApp / SMS / Push'**
  String get businessFeature4;

  /// No description provided for @businessFeature5.
  ///
  /// In fr, this message translates to:
  /// **'Coffre-fort d\'Identifiants Sécurisé (AES-256)'**
  String get businessFeature5;

  /// No description provided for @businessFeature6.
  ///
  /// In fr, this message translates to:
  /// **'Exports Comptables & Fiscaux (CSV / Excel)'**
  String get businessFeature6;

  /// No description provided for @businessFeature7.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de Bord & MRR en Temps Réel'**
  String get businessFeature7;

  /// No description provided for @businessFeature8.
  ///
  /// In fr, this message translates to:
  /// **'Support VIP Dédié 24/7'**
  String get businessFeature8;

  /// No description provided for @closureVoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Clôture de la tontine'**
  String get closureVoteTitle;

  /// No description provided for @closureVoteExplainer.
  ///
  /// In fr, this message translates to:
  /// **'Une tontine en cours ne peut être clôturée que si la majorité des membres vote pour. Chaque membre a une voix.'**
  String get closureVoteExplainer;

  /// No description provided for @proposeClosure.
  ///
  /// In fr, this message translates to:
  /// **'Proposer la clôture'**
  String get proposeClosure;

  /// No description provided for @confirmProposeClosure.
  ///
  /// In fr, this message translates to:
  /// **'Tous les membres pourront voter pendant 72 heures. Si la majorité vote « Oui », la tontine sera clôturée : les tours déjà versés restent acquis et il n\'y aura plus de prélèvements.'**
  String get confirmProposeClosure;

  /// No description provided for @closureVoteOpen.
  ///
  /// In fr, this message translates to:
  /// **'Vote de clôture en cours'**
  String get closureVoteOpen;

  /// No description provided for @voteYesClose.
  ///
  /// In fr, this message translates to:
  /// **'Oui, clôturer'**
  String get voteYesClose;

  /// No description provided for @voteNoContinue.
  ///
  /// In fr, this message translates to:
  /// **'Non, continuer'**
  String get voteNoContinue;

  /// No description provided for @closureVoteProgress.
  ///
  /// In fr, this message translates to:
  /// **'{votes} vote(s) · {majority} voix nécessaires'**
  String closureVoteProgress(int votes, int majority);

  /// No description provided for @closureVoteEndsAt.
  ///
  /// In fr, this message translates to:
  /// **'Fin du vote : {date}'**
  String closureVoteEndsAt(String date);

  /// No description provided for @youHaveVoted.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez voté. Votre choix reste secret.'**
  String get youHaveVoted;

  /// No description provided for @closureVoteApproved.
  ///
  /// In fr, this message translates to:
  /// **'Clôture approuvée : la tontine est terminée.'**
  String get closureVoteApproved;

  /// No description provided for @closureVoteRejected.
  ///
  /// In fr, this message translates to:
  /// **'Clôture rejetée : la tontine continue.'**
  String get closureVoteRejected;

  /// No description provided for @closureVoteExpired.
  ///
  /// In fr, this message translates to:
  /// **'Vote expiré sans majorité : la tontine continue.'**
  String get closureVoteExpired;

  /// No description provided for @voteRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Vote enregistré'**
  String get voteRecorded;

  /// No description provided for @confirmVote.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer votre vote : « {choice} » ? Vous ne pourrez pas le modifier.'**
  String confirmVote(String choice);

  /// No description provided for @deleteGoalWithPenalty.
  ///
  /// In fr, this message translates to:
  /// **'Cet objectif contient {amount} XAF. Le supprimer avant l\'échéance ({date}) vous rembourse avec une pénalité de 0,5 % : {penalty} XAF seront retenus. Continuer ?'**
  String deleteGoalWithPenalty(String amount, String penalty, String date);

  /// No description provided for @goalSavingsAdded.
  ///
  /// In fr, this message translates to:
  /// **'Épargne ajoutée à votre objectif'**
  String get goalSavingsAdded;

  /// No description provided for @shareTontineInviteText.
  ///
  /// In fr, this message translates to:
  /// **'Rejoins ma tontine sur Kauri avec le code : {code}'**
  String shareTontineInviteText(String code);

  /// No description provided for @shareTontineInviteSubject.
  ///
  /// In fr, this message translates to:
  /// **'Invitation Tontine Kauri'**
  String get shareTontineInviteSubject;

  /// No description provided for @offlineCachedDataBanner.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne — données en cache, peut-être pas à jour'**
  String get offlineCachedDataBanner;

  /// No description provided for @accountSuspendedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte suspendu'**
  String get accountSuspendedTitle;

  /// No description provided for @accountSuspendedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte a été temporairement suspendu pour des raisons de sécurité suite à des activités inhabituelles détectées par notre IA.'**
  String get accountSuspendedMessage;

  /// No description provided for @accountSuspendedThreeStrikes.
  ///
  /// In fr, this message translates to:
  /// **'Politique des \"3 Frappes\" : Si vous avez téléchargé des reçus invalides ou frauduleux plus de 3 fois, votre compte est verrouillé.'**
  String get accountSuspendedThreeStrikes;

  /// No description provided for @contactSupport.
  ///
  /// In fr, this message translates to:
  /// **'Contacter le support'**
  String get contactSupport;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @biometricLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par biométrie'**
  String get biometricLogin;

  /// No description provided for @biometricEnrollFirst.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez d\'abord une empreinte ou un visage dans les réglages de votre téléphone.'**
  String get biometricEnrollFirst;

  /// No description provided for @biometricEnabledSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Connexion biométrique activée'**
  String get biometricEnabledSuccess;

  /// No description provided for @confirmYourPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre mot de passe'**
  String get confirmYourPassword;

  /// No description provided for @biometricPasswordPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre mot de passe pour activer la connexion biométrique.'**
  String get biometricPasswordPrompt;

  /// No description provided for @weekNumberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Semaine {number}'**
  String weekNumberLabel(int number);

  /// No description provided for @challengeAutoDebitNotice.
  ///
  /// In fr, this message translates to:
  /// **'Le montant sera automatiquement prélevé de votre portefeuille Kauri.'**
  String get challengeAutoDebitNotice;

  /// No description provided for @featureDisabledVersionRequired.
  ///
  /// In fr, this message translates to:
  /// **'{message} (version requise)'**
  String featureDisabledVersionRequired(String message);

  /// No description provided for @congratulations.
  ///
  /// In fr, this message translates to:
  /// **'Félicitations !'**
  String get congratulations;

  /// No description provided for @levelUpReached.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez atteint le'**
  String get levelUpReached;

  /// No description provided for @levelNumber.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level}'**
  String levelNumber(int level);

  /// No description provided for @levelUpKeepGoing.
  ///
  /// In fr, this message translates to:
  /// **'Continuez comme ça pour débloquer de nouveaux badges et fonctionnalités !'**
  String get levelUpKeepGoing;

  /// No description provided for @continueAction.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueAction;

  /// No description provided for @goalNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Objectif introuvable'**
  String get goalNotFound;

  /// No description provided for @withdrawAmountMustBePositive.
  ///
  /// In fr, this message translates to:
  /// **'Le montant de retrait doit être supérieur à 0.'**
  String get withdrawAmountMustBePositive;

  /// No description provided for @paymentVerificationInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Vérification de votre paiement en cours…'**
  String get paymentVerificationInProgress;

  /// No description provided for @kycReviewInProgressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification KYC en cours'**
  String get kycReviewInProgressTitle;

  /// No description provided for @kycReviewInProgressMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vos documents d\'identité sont actuellement en cours d\'examen par notre équipe de conformité (24h à 48h). Les retraits seront automatiquement débloqués dès validation.'**
  String get kycReviewInProgressMessage;

  /// No description provided for @gotIt.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get gotIt;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @verifyMyKyc.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier mon KYC'**
  String get verifyMyKyc;

  /// No description provided for @virtualWalletBanner.
  ///
  /// In fr, this message translates to:
  /// **'Mode portefeuille virtuel — dépôts et retraits réels désactivés'**
  String get virtualWalletBanner;

  /// No description provided for @seeMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus'**
  String get seeMore;

  /// No description provided for @virtualWalletTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode portefeuille virtuel'**
  String get virtualWalletTitle;

  /// No description provided for @virtualWalletMessage.
  ///
  /// In fr, this message translates to:
  /// **'Kauri fonctionne actuellement en mode simulation : les dépôts et retraits en argent réel sont temporairement désactivés. Vous pouvez continuer à utiliser toutes les autres fonctionnalités (tontines, objectifs, défis, budgets...) normalement.'**
  String get virtualWalletMessage;

  /// No description provided for @orangeMoneyCameroon.
  ///
  /// In fr, this message translates to:
  /// **'Orange Money Cameroun'**
  String get orangeMoneyCameroon;

  /// No description provided for @mtnMomoCameroon.
  ///
  /// In fr, this message translates to:
  /// **'MTN MoMo Cameroun'**
  String get mtnMomoCameroon;

  /// No description provided for @plansAndResellerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Forfaits Kauri & Espace Revendeur'**
  String get plansAndResellerTitle;

  /// No description provided for @plansAndResellerDesc.
  ///
  /// In fr, this message translates to:
  /// **'Passez à Premium (2 000 FCFA) ou lancez votre activité Revendeur (5 000 FCFA) avec outils et marges dédiés.'**
  String get plansAndResellerDesc;

  /// No description provided for @discoverPlansAndPricing.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir les forfaits et tarifs'**
  String get discoverPlansAndPricing;

  /// No description provided for @chooseAppIcon.
  ///
  /// In fr, this message translates to:
  /// **'Choisir l\'icône'**
  String get chooseAppIcon;

  /// No description provided for @appIconDefaultGreen.
  ///
  /// In fr, this message translates to:
  /// **'Par défaut (vert)'**
  String get appIconDefaultGreen;

  /// No description provided for @appIconChanged.
  ///
  /// In fr, this message translates to:
  /// **'Icône changée : {name}. Un redémarrage peut être nécessaire.'**
  String appIconChanged(String name);

  /// No description provided for @resellerNewMasterAccount.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau compte maître'**
  String get resellerNewMasterAccount;

  /// No description provided for @resellerServiceInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations du service'**
  String get resellerServiceInfo;

  /// No description provided for @resellerServiceNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du service (ex : Netflix 4K, Spotify…)'**
  String get resellerServiceNameLabel;

  /// No description provided for @resellerCostPaidByYou.
  ///
  /// In fr, this message translates to:
  /// **'Coût payé par vous'**
  String get resellerCostPaidByYou;

  /// No description provided for @currencyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get currencyLabel;

  /// No description provided for @resellerMaxSlots.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d\'écrans / slots maximum'**
  String get resellerMaxSlots;

  /// No description provided for @resellerNextProviderPayment.
  ///
  /// In fr, this message translates to:
  /// **'Date de votre prochain paiement fournisseur'**
  String get resellerNextProviderPayment;

  /// No description provided for @resellerSecureVault.
  ///
  /// In fr, this message translates to:
  /// **'Coffre-fort sécurisé (chiffré AES-256)'**
  String get resellerSecureVault;

  /// No description provided for @resellerVaultPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Vos accès sont stockés de manière chiffrée et restent privés.'**
  String get resellerVaultPrivacy;

  /// No description provided for @resellerAccountLogin.
  ///
  /// In fr, this message translates to:
  /// **'E-mail / identifiant du compte'**
  String get resellerAccountLogin;

  /// No description provided for @resellerMasterPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe maître'**
  String get resellerMasterPassword;

  /// No description provided for @resellerMainPin.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN principal (optionnel)'**
  String get resellerMainPin;

  /// No description provided for @resellerSaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le compte'**
  String get resellerSaveAccount;

  /// No description provided for @resellerNewSlot.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau slot ({service})'**
  String resellerNewSlot(String service);

  /// No description provided for @resellerProfileAssignment.
  ///
  /// In fr, this message translates to:
  /// **'Attribution du profil'**
  String get resellerProfileAssignment;

  /// No description provided for @resellerProfileNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du profil / écran (ex : Profil 2 - Marie)'**
  String get resellerProfileNameLabel;

  /// No description provided for @resellerClientFullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet du client'**
  String get resellerClientFullName;

  /// No description provided for @resellerClientPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone / WhatsApp (+237…)'**
  String get resellerClientPhone;

  /// No description provided for @resellerSalePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix de vente (ex : 3 000 FCFA)'**
  String get resellerSalePrice;

  /// No description provided for @quarterly.
  ///
  /// In fr, this message translates to:
  /// **'Trimestriel'**
  String get quarterly;

  /// No description provided for @resellerFirstPaymentDate.
  ///
  /// In fr, this message translates to:
  /// **'Date du premier paiement / début d\'accès'**
  String get resellerFirstPaymentDate;

  /// No description provided for @resellerReminderChannel.
  ///
  /// In fr, this message translates to:
  /// **'Canal de rappel automatique'**
  String get resellerReminderChannel;

  /// No description provided for @whatsappRecommended.
  ///
  /// In fr, this message translates to:
  /// **'WhatsApp (recommandé)'**
  String get whatsappRecommended;

  /// No description provided for @resellerAssignAndSave.
  ///
  /// In fr, this message translates to:
  /// **'Attribuer le profil et enregistrer'**
  String get resellerAssignAndSave;

  /// No description provided for @copiedAutoClear.
  ///
  /// In fr, this message translates to:
  /// **'{label} copié (effacement automatique dans 30 s)'**
  String copiedAutoClear(String label);

  /// No description provided for @resellerVaultOf.
  ///
  /// In fr, this message translates to:
  /// **'Coffre-fort ({service})'**
  String resellerVaultOf(String service);

  /// No description provided for @emailOrLogin.
  ///
  /// In fr, this message translates to:
  /// **'E-mail / identifiant'**
  String get emailOrLogin;

  /// No description provided for @resellerProfilePin.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN du profil'**
  String get resellerProfilePin;

  /// No description provided for @resellerPricePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'Prix : {price} {currency} / mois'**
  String resellerPricePerMonth(String price, String currency);

  /// No description provided for @remindOnWhatsapp.
  ///
  /// In fr, this message translates to:
  /// **'Relancer sur WhatsApp'**
  String get remindOnWhatsapp;

  /// No description provided for @resellerMarkPaid.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme payé (renouveler)'**
  String get resellerMarkPaid;

  /// No description provided for @resellerExtendOneMonth.
  ///
  /// In fr, this message translates to:
  /// **'Prolonge l\'accès d\'un mois'**
  String get resellerExtendOneMonth;

  /// No description provided for @resellerFreeProfile.
  ///
  /// In fr, this message translates to:
  /// **'Libérer le profil (retirer le client)'**
  String get resellerFreeProfile;

  /// No description provided for @resellerFreeProfileDesc.
  ///
  /// In fr, this message translates to:
  /// **'Rend ce profil à nouveau disponible'**
  String get resellerFreeProfileDesc;

  /// No description provided for @resellerRemoveClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Retirer le client ?'**
  String get resellerRemoveClientTitle;

  /// No description provided for @resellerRemoveAndFree.
  ///
  /// In fr, this message translates to:
  /// **'Retirer et libérer'**
  String get resellerRemoveAndFree;

  /// No description provided for @deleteNamedQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer {name} ?'**
  String deleteNamedQuestion(String name);

  /// No description provided for @deletePermanently.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer définitivement'**
  String get deletePermanently;

  /// No description provided for @resellerSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace Revendeur'**
  String get resellerSpace;

  /// No description provided for @guideAndQuotas.
  ///
  /// In fr, this message translates to:
  /// **'Guide et quotas'**
  String get guideAndQuotas;

  /// No description provided for @resellerMonthlyRevenue.
  ///
  /// In fr, this message translates to:
  /// **'Chiffre d\'affaires mensuel (MRR)'**
  String get resellerMonthlyRevenue;

  /// No description provided for @resellerActiveAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes et slots actifs'**
  String get resellerActiveAccounts;

  /// No description provided for @newAccount.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau compte'**
  String get newAccount;

  /// No description provided for @resellerNoMasterAccount.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte maître enregistré'**
  String get resellerNoMasterAccount;

  /// No description provided for @resellerNoMasterAccountDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez vos comptes d\'abonnements partagés pour commencer à gérer vos profils clients.'**
  String get resellerNoMasterAccountDesc;

  /// No description provided for @resellerDeleteMasterAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte maître'**
  String get resellerDeleteMasterAccount;

  /// No description provided for @resellerSlotsOccupied.
  ///
  /// In fr, this message translates to:
  /// **'SLOTS ({occupied}/{max} occupés)'**
  String resellerSlotsOccupied(int occupied, int max);

  /// No description provided for @assign.
  ///
  /// In fr, this message translates to:
  /// **'Attribuer'**
  String get assign;

  /// No description provided for @costLabelValue.
  ///
  /// In fr, this message translates to:
  /// **'Coût : {amount} {currency}'**
  String costLabelValue(String amount, String currency);

  /// No description provided for @accessAndPin.
  ///
  /// In fr, this message translates to:
  /// **'Accès et PIN'**
  String get accessAndPin;

  /// No description provided for @paymentFailedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement échoué'**
  String get paymentFailedTitle;

  /// No description provided for @referenceValue.
  ///
  /// In fr, this message translates to:
  /// **'Référence : {ref}'**
  String referenceValue(String ref);

  /// No description provided for @retryPayment.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer le paiement'**
  String get retryPayment;

  /// No description provided for @backToDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Retour au tableau de bord'**
  String get backToDashboard;

  /// No description provided for @seeAllDetailsAndFeatures.
  ///
  /// In fr, this message translates to:
  /// **'Voir tous les détails et fonctionnalités'**
  String get seeAllDetailsAndFeatures;

  /// No description provided for @instant.
  ///
  /// In fr, this message translates to:
  /// **'Instantané'**
  String get instant;

  /// No description provided for @topUpWallet.
  ///
  /// In fr, this message translates to:
  /// **'Recharger le portefeuille'**
  String get topUpWallet;

  /// No description provided for @mobileMoneyNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro Mobile Money'**
  String get mobileMoneyNumber;

  /// No description provided for @mobileMoneyNumberPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez renseigner votre numéro de téléphone (Orange Money ou MTN MoMo) pour valider le paiement.'**
  String get mobileMoneyNumberPrompt;

  /// No description provided for @voiceNoteMessagePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'🎤 Note vocale'**
  String get voiceNoteMessagePlaceholder;

  /// No description provided for @inviteCodeExample.
  ///
  /// In fr, this message translates to:
  /// **'ex : ABC-123'**
  String get inviteCodeExample;

  /// No description provided for @uploadTransferReceiptPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez le reçu de votre transfert pour valider votre cotisation.'**
  String get uploadTransferReceiptPrompt;

  /// No description provided for @voiceExtractionConfidence.
  ///
  /// In fr, this message translates to:
  /// **'Extraction précise à {percent} %'**
  String voiceExtractionConfidence(String percent);

  /// No description provided for @targetGoalValue.
  ///
  /// In fr, this message translates to:
  /// **'Objectif cible : {goal}'**
  String targetGoalValue(String goal);

  /// No description provided for @errInvalidInput.
  ///
  /// In fr, this message translates to:
  /// **'Les informations fournies sont invalides ou incomplètes.'**
  String get errInvalidInput;

  /// No description provided for @errSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Veuillez vous reconnecter.'**
  String get errSessionExpired;

  /// No description provided for @errAccessDenied.
  ///
  /// In fr, this message translates to:
  /// **'Accès refusé. Vous devez valider votre compte ou votre KYC pour effectuer cette action.'**
  String get errAccessDenied;

  /// No description provided for @errNotFound.
  ///
  /// In fr, this message translates to:
  /// **'La ressource demandée est introuvable.'**
  String get errNotFound;

  /// No description provided for @errConflict.
  ///
  /// In fr, this message translates to:
  /// **'Un conflit est survenu avec cette opération.'**
  String get errConflict;

  /// No description provided for @errUnprocessable.
  ///
  /// In fr, this message translates to:
  /// **'Données non traitables. Veuillez vérifier votre saisie.'**
  String get errUnprocessable;

  /// No description provided for @errTooManyRequests.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Veuillez patienter quelques instants.'**
  String get errTooManyRequests;

  /// No description provided for @errServerUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur rencontre une indisponibilité temporaire. Veuillez réessayer plus tard.'**
  String get errServerUnavailable;

  /// No description provided for @errKycPending.
  ///
  /// In fr, this message translates to:
  /// **'Votre dossier KYC est en cours de validation. Les retraits seront disponibles dès son approbation.'**
  String get errKycPending;

  /// No description provided for @errInsufficientBalance.
  ///
  /// In fr, this message translates to:
  /// **'Votre solde est insuffisant pour effectuer cette opération.'**
  String get errInsufficientBalance;

  /// No description provided for @errAmountLimits.
  ///
  /// In fr, this message translates to:
  /// **'Le montant saisi ne respecte pas les limites ou plafonds autorisés.'**
  String get errAmountLimits;

  /// No description provided for @errTechnical.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur technique temporaire est survenue sur nos serveurs. Veuillez réessayer dans un instant.'**
  String get errTechnical;

  /// No description provided for @resellerShort.
  ///
  /// In fr, this message translates to:
  /// **'Revendeur'**
  String get resellerShort;

  /// No description provided for @accountsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Comptes'**
  String get accountsLabel;

  /// No description provided for @resellerManagedSlots.
  ///
  /// In fr, this message translates to:
  /// **'Slots gérés'**
  String get resellerManagedSlots;

  /// No description provided for @resellerFreeSlots.
  ///
  /// In fr, this message translates to:
  /// **'Slots libres'**
  String get resellerFreeSlots;

  /// No description provided for @pinCode.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN'**
  String get pinCode;

  /// No description provided for @resellerMasterCreated.
  ///
  /// In fr, this message translates to:
  /// **'Compte maître créé avec succès'**
  String get resellerMasterCreated;

  /// No description provided for @resellerSlotAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Slot attribué avec succès'**
  String get resellerSlotAssigned;

  /// No description provided for @paymentRecordedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Paiement enregistré avec succès'**
  String get paymentRecordedSuccess;

  /// No description provided for @resellerProfileFreed.
  ///
  /// In fr, this message translates to:
  /// **'Profil libéré avec succès'**
  String get resellerProfileFreed;

  /// No description provided for @accountDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Compte supprimé avec succès'**
  String get accountDeletedSuccess;

  /// No description provided for @errSignInTokenMissing.
  ///
  /// In fr, this message translates to:
  /// **'La connexion n\'a pas pu aboutir (jeton manquant). Réessayez.'**
  String get errSignInTokenMissing;

  /// No description provided for @errLoadData.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les données. Réessayez.'**
  String get errLoadData;

  /// No description provided for @memberNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Membre introuvable'**
  String get memberNotFound;

  /// No description provided for @errCoachUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'L\'assistant ne répond pas pour le moment. Réessayez.'**
  String get errCoachUnavailable;

  /// No description provided for @errRedeemNeedsConnection.
  ///
  /// In fr, this message translates to:
  /// **'Une connexion internet est requise pour récupérer des fonds.'**
  String get errRedeemNeedsConnection;

  /// No description provided for @premiumFallbackBudgetsGoals.
  ///
  /// In fr, this message translates to:
  /// **'5 budgets et 5 objectifs simultanés'**
  String get premiumFallbackBudgetsGoals;

  /// No description provided for @premiumFallbackOcr.
  ///
  /// In fr, this message translates to:
  /// **'15 scans de reçus (OCR) / mois'**
  String get premiumFallbackOcr;

  /// No description provided for @premiumFallbackCoach.
  ///
  /// In fr, this message translates to:
  /// **'Coach IA Anne (50 requêtes / mois, 30 jours d’historique)'**
  String get premiumFallbackCoach;

  /// No description provided for @premiumFallbackReseller.
  ///
  /// In fr, this message translates to:
  /// **'Espace Revendeur : 3 comptes maîtres et 10 slots clients'**
  String get premiumFallbackReseller;

  /// No description provided for @tontineCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Tontine créée avec succès'**
  String get tontineCreatedSuccess;

  /// No description provided for @tontineUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Tontine mise à jour'**
  String get tontineUpdatedSuccess;

  /// No description provided for @contributionSentPendingValidation.
  ///
  /// In fr, this message translates to:
  /// **'Cotisation envoyée : en attente de validation par l\'organisateur'**
  String get contributionSentPendingValidation;

  /// No description provided for @statusValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validé'**
  String get statusValidated;

  /// No description provided for @statusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejeté'**
  String get statusRejected;

  /// No description provided for @accountSuspendedContactSupport.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte a été suspendu par notre système de sécurité. Veuillez contacter le support.'**
  String get accountSuspendedContactSupport;

  /// No description provided for @kycSelfieRequired.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez fournir le selfie de vérification.'**
  String get kycSelfieRequired;

  /// No description provided for @unknownDevice.
  ///
  /// In fr, this message translates to:
  /// **'Appareil inconnu'**
  String get unknownDevice;
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
