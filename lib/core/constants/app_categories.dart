class AppCategories {
  static const List<String> categories = [
    'Alimentation',
    'Transport',
    'Logement',
    'Santé',
    'Loisirs',
    'Factures',
    'Shopping',
    'Education',
    'Investissement',
    'Cadeaux',
    'Salaire',
    'Autres',
  ];

  static const List<String> subscriptionCategories = [
    'Streaming Vidéo (Netflix, Disney+, etc.)',
    'Streaming Musical (Spotify, Deezer, etc.)',
    'Logiciels / SaaS (Adobe, Microsoft 365, etc.)',
    'Stockage Cloud (Google One, iCloud, etc.)',
    'Salle de Sport / Fitness',
    'Téléphonie / Internet',
    'Électricité / Gaz',
    'Assurance (Habitation, Voiture, etc.)',
    'Presse / Magazines',
    'Jeux Vidéo (Game Pass, PS Plus)',
    'Livraison (Amazon Prime)',
    'Outils de Travail (Zoom, Slack)',
    'Apprentissage / Cours (Udemy)',
    'Sécurité / Antivirus',
    'Beauté / Box Mensuelles',
    'Loyers / Logement',
    'Transport (Pass Navigo, Uber Pass)',
    'Gaming (Steam, Epic Games)',
    'Dating (Tinder Gold, Badoo)',
    'Design (Canva, Figma)',
    'Développement (Copilot, JetBrains)',
    'Hébergement / Domaines (OVH)',
    'Santé / Mutuelle',
    'Dons / Soutien (Patreon)',
    'Finance / Trading (Bloomberg)',
    'VPN / Vie Privée',
    'Maison Connectée / Sécurité',
    'Food Delivery (Uber Eats, Deliveroo)',
    'Éducation Enfants',
    'Outils Professionnels',
    'Loisirs Créatifs',
    'Bien-être (Calm, Headspace)',
    'Services Bancaires (N26, Revolut)',
  ];

  /// Fait correspondre une chaîne (ex: issue de l'IA) à une catégorie standard de l'application.
  static String mapToStandardCategory(String input) {
    if (input.isEmpty) return 'Autres';

    final normalizedInput = input.toLowerCase();

    // Dictionnaire de correspondance (mots-clés -> catégorie standard)
    final Map<String, List<String>> mapping = {
      'Alimentation': [
        'course',
        'supermarché',
        'epicerie',
        'grocery',
        'food',
        'marché',
        'restaurant',
        'sorties',
        'manger',
        'repas',
      ],
      'Transport': [
        'essence',
        'fuel',
        'bus',
        'train',
        'taxi',
        'parking',
        'voiture',
        'péage',
        'transport',
        'avion',
      ],
      'Logement': [
        'loyer',
        'rent',
        'hypothèque',
        'crédit immobilier',
        'maison',
        'appartement',
        'logement',
        'home',
        'prêt',
      ],
      'Santé': [
        'santé',
        'docteur',
        'médicament',
        'pharmacie',
        'mutuelle',
        'health',
        'dentiste',
        'hopital',
      ],
      'Loisirs': [
        'loisir',
        'vacances',
        'cinéma',
        'sport',
        'abonnement',
        'streaming',
        'netflix',
        'culture',
        'fun',
        'hobby',
        'divertissement',
      ],
      'Factures': [
        'facture',
        'électricité',
        'eau',
        'internet',
        'téléphone',
        'gaz',
        'énergie',
        'bill',
        'charge',
        'assurance',
      ],
      'Shopping': [
        'shopping',
        'vêtement',
        'habit',
        'mode',
        'chaussure',
        'amazon',
        'achat',
        'clothes',
      ],
      'Education': [
        'ecole',
        'scolarité',
        'formation',
        'livre',
        'cours',
        'school',
        'education',
        'université',
      ],
      'Investissement': [
        'investissement',
        'épargne',
        'bourse',
        'pea',
        'assurance vie',
        'capital',
        'finance',
        'savings',
        'investment',
        'action',
      ],
      'Cadeaux': ['cadeau', 'don', 'donation', 'gift', 'plaisir', 'charité'],
      'Salaire': ['salaire', 'revenu', 'paye', 'salary', 'income', 'virement'],
    };

    // 1. Vérification si l'input contient directement une des catégories standards
    for (final standard in categories) {
      if (normalizedInput.contains(standard.toLowerCase())) {
        return standard;
      }
    }

    // 2. Recherche par mots-clés dans le mapping
    for (final entry in mapping.entries) {
      for (final keyword in entry.value) {
        if (normalizedInput.contains(keyword)) {
          return entry.key;
        }
      }
    }

    // 3. Cas par défaut : On conserve ce que l'IA a proposé au lieu de forcer "Autres"
    // Cela permet plus de flexibilité comme demandé par l'utilisateur.
    // On nettoie juste la casse (Majuscule au début)
    if (input.length > 1) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }
    return input;
  }
}
