/// Gestionnaire des ressources statiques (Images, Icônes, Animations) de l'application.
/// Ce fichier centralise tous les chemins vers les assets pour éviter les erreurs de saisie manuelle.
class AppAssets {
  static const String _images = 'assets/images';
  static const String _onboarding = '$_images/onboarding';
  static const String _placeholders = '$_images/placeholders';

  // --- Logos ---
  /// Logo principal de l'application.
  static const String logo = '$_images/logo.png';

  // --- Écrans d'introduction (Onboarding) ---
  /// Image pour la première étape de l'introduction.
  static const String onboarding1 = '$_onboarding/onboarding_1.png';

  /// Image pour la deuxième étape de l'introduction.
  static const String onboarding2 = '$_onboarding/onboarding_2.png';

  /// Image pour la troisième étape de l'introduction.
  static const String onboarding3 = '$_onboarding/onboarding_3.png';

  // --- Images de substitution (Placeholders) ---
  /// Affichée quand aucun budget n'est défini.
  static const String emptyBudget = '$_placeholders/empty_budget.png';

  /// Affichée quand la liste des transactions est vide.
  static const String emptyTransactions =
      '$_placeholders/empty_transactions.png';

  /// Affichée quand aucun objectif d'épargne n'est configuré.
  static const String emptyGoals = '$_placeholders/empty_goals.png';

  static const String _icons = '$_images/icons';
  static const String _animations = '$_images/animations';

  // --- Icônes de catégories ---
  /// Icône pour l'alimentation et la restauration.
  static const String iconFood = '$_icons/food.png';

  /// Icône pour les transports et le carburant.
  static const String iconTransport = '$_icons/transport.png';

  /// Icône pour les achats et le shopping.
  static const String iconShopping = '$_icons/shopping.png';

  /// Icône pour les factures et charges fixes.
  static const String iconBills = '$_icons/bills.png';

  /// Icône pour les loisirs et le divertissement.
  static const String iconEntertainment = '$_icons/entertainment.png';

  /// Icône pour la santé et le bien-être.
  static const String iconHealth = '$_icons/health.png';

  // --- Animations statiques ---
  /// Image/Animation de succès pour les validations.
  static const String animSuccess = '$_animations/success.png';

  /// Image/Animation d'erreur pour les échecs d'opération.
  static const String animError = '$_animations/error.png';
}
