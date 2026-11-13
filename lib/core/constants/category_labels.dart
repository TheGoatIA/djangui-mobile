import 'package:flutter/widgets.dart';

/// Libellé AFFICHÉ d'une catégorie, dans la langue de l'app.
///
/// Les catégories sont enregistrées telles quelles (valeurs françaises des
/// catégories par défaut — « Alimentation », « Santé »… — ou codes internes
/// des mouvements d'argent — `deposit`, `tontine_payout`…). Les tests E2E
/// (app en anglais / mode sombre) montraient ces valeurs brutes à l'écran :
/// « deposit », « withdrawal », « Alimentation » dans une app anglaise.
/// On ne modifie jamais la valeur stockée (budgets, filtres et rapports s'en
/// servent) : on traduit seulement à l'affichage.
class CategoryLabels {
  CategoryLabels._();

  /// Codes internes (API) → [fr, en].
  static const Map<String, List<String>> _system = {
    'deposit': ['Recharge', 'Top-up'],
    'withdrawal': ['Retrait', 'Withdrawal'],
    'tontine_contribution': ['Cotisation tontine', 'Tontine contribution'],
    'tontine_social_fund': ['Fonds social tontine', 'Tontine social fund'],
    'tontine_absence_fee': ['Pénalité tontine', 'Tontine penalty'],
    'tontine_payout': ['Cagnotte tontine', 'Tontine payout'],
    'tontine_refund': ['Remboursement tontine', 'Tontine refund'],
    'challenge_reward': ['Récompense défi', 'Challenge reward'],
    'challenge_stake': ['Mise défi', 'Challenge stake'],
    'goal_contribution': ['Épargne objectif', 'Goal savings'],
    'goal_auto_save': ['Épargne automatique', 'Auto-save'],
    'goal_redeem': ['Retrait objectif', 'Goal withdrawal'],
    'saving_transfer': ['Épargne', 'Savings'],
    'investment_purchase': ['Investissement', 'Investment'],
    'investment_close': ['Clôture investissement', 'Investment closed'],
    'subscription': ['Abonnement Kauri', 'Kauri subscription'],
    'subscription_payment': ['Abonnement Kauri', 'Kauri subscription'],
    'simulation_reset': ['Remise à zéro (simulation)', 'Simulation reset'],
    'refund': ['Remboursement', 'Refund'],
    'fee': ['Frais', 'Fees'],
    'fees': ['Frais', 'Fees'],
    'income': ['Revenu', 'Income'],
    'expense': ['Dépense', 'Expense'],
  };

  /// Catégories par défaut (valeur stockée en français) → anglais.
  static const Map<String, String> _defaultsEn = {
    'Alimentation': 'Food',
    'Transport': 'Transport',
    'Logement': 'Housing',
    'Santé': 'Health',
    'Loisirs': 'Leisure',
    'Factures': 'Bills',
    'Shopping': 'Shopping',
    'Education': 'Education',
    'Éducation': 'Education',
    'Investissement': 'Investment',
    'Cadeaux': 'Gifts',
    'Salaire': 'Salary',
    'Autres': 'Other',
    'Autre': 'Other',
    // Catégories d'abonnements
    'Streaming Vidéo (Netflix, Disney+, etc.)':
        'Video streaming (Netflix, Disney+, etc.)',
    'Streaming Musical (Spotify, Deezer, etc.)':
        'Music streaming (Spotify, Deezer, etc.)',
    'Logiciels / SaaS (Adobe, Microsoft 365, etc.)':
        'Software / SaaS (Adobe, Microsoft 365, etc.)',
    'Stockage Cloud (Google One, iCloud, etc.)':
        'Cloud storage (Google One, iCloud, etc.)',
    'Salle de Sport / Fitness': 'Gym / Fitness',
    'Téléphonie / Internet': 'Phone / Internet',
    'Électricité / Gaz': 'Electricity / Gas',
    'Assurance (Habitation, Voiture, etc.)': 'Insurance (Home, Car, etc.)',
    'Presse / Magazines': 'News / Magazines',
    'Jeux Vidéo (Game Pass, PS Plus)': 'Video games (Game Pass, PS Plus)',
    'Livraison (Amazon Prime)': 'Delivery (Amazon Prime)',
    'Outils de Travail (Zoom, Slack)': 'Work tools (Zoom, Slack)',
    'Apprentissage / Cours (Udemy)': 'Learning / Courses (Udemy)',
    'Sécurité / Antivirus': 'Security / Antivirus',
    'Beauté / Box Mensuelles': 'Beauty / Monthly boxes',
    'Loyers / Logement': 'Rent / Housing',
    'Transport (Pass Navigo, Uber Pass)': 'Transport (Navigo, Uber Pass)',
    'Gaming (Steam, Epic Games)': 'Gaming (Steam, Epic Games)',
    'Dating (Tinder Gold, Badoo)': 'Dating (Tinder Gold, Badoo)',
    'Design (Canva, Figma)': 'Design (Canva, Figma)',
    'Développement (Copilot, JetBrains)': 'Development (Copilot, JetBrains)',
    'Hébergement / Domaines (OVH)': 'Hosting / Domains (OVH)',
    'Santé / Mutuelle': 'Health / Insurance',
    'Dons / Soutien (Patreon)': 'Donations / Support (Patreon)',
    'Finance / Trading (Bloomberg)': 'Finance / Trading (Bloomberg)',
    'VPN / Vie Privée': 'VPN / Privacy',
    'Maison Connectée / Sécurité': 'Smart home / Security',
    'Food Delivery (Uber Eats, Deliveroo)':
        'Food delivery (Uber Eats, Deliveroo)',
    'Éducation Enfants': "Children's education",
    'Outils Professionnels': 'Professional tools',
    'Loisirs Créatifs': 'Creative hobbies',
    'Bien-être (Calm, Headspace)': 'Wellbeing (Calm, Headspace)',
    'Services Bancaires (N26, Revolut)': 'Banking services (N26, Revolut)',
    // Libellés déjà « humanisés » en français par l'API (rapports/insights) :
    // un rapport en cache ou une ancienne API peut les renvoyer à une app en
    // anglais (constat E2E : « Retraits » dans Insights en anglais).
    'Cotisations tontines': 'Tontine contributions',
    'Fonds social tontines': 'Tontine social fund',
    'Pénalités absence tontines': 'Tontine absence fees',
    'Cagnottes tontines reçues': 'Tontine payouts received',
    'Retraits': 'Withdrawals',
    'Dépôts': 'Deposits',
    'Récompenses défis': 'Challenge rewards',
    "Objectifs d'épargne": 'Savings goals',
    'Mises défis': 'Challenge stakes',
    'Investissements': 'Investments',
    "Clôtures d'investissement": 'Investment closures',
    'Épargne': 'Savings',
  };

  /// Libellé pour une langue donnée (`fr` / `en`).
  static String forLanguage(String raw, String languageCode) {
    final en = languageCode == 'en';
    final system = _system[raw] ?? _system[raw.toLowerCase()];
    if (system != null) return en ? system[1] : system[0];
    if (en) return _defaultsEn[raw] ?? raw;
    return raw;
  }

  /// Libellé dans la langue courante de l'interface.
  static String display(BuildContext context, String raw) =>
      forLanguage(raw, Localizations.localeOf(context).languageCode);
}
