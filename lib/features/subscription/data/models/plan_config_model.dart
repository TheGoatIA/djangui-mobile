class PlanFeatureCategory {
  final String category;
  final List<PlanFeatureItem> items;

  PlanFeatureCategory({
    required this.category,
    required this.items,
  });

  factory PlanFeatureCategory.fromJson(Map<String, dynamic> json, {String language = 'fr'}) {
    final catRaw = json['category'];
    final categoryName = catRaw is Map
        ? (catRaw[language] ?? catRaw['fr'] ?? catRaw['en'] ?? '').toString()
        : (catRaw ?? '').toString();

    final itemsRaw = json['items'] as List? ?? [];
    final items = itemsRaw.map((e) => PlanFeatureItem.fromJson(e as Map<String, dynamic>, language: language)).toList();

    return PlanFeatureCategory(category: categoryName, items: items);
  }
}

class PlanFeatureItem {
  final String id;
  final String name;
  final bool included;
  final bool highlight;
  final String? value;

  PlanFeatureItem({
    required this.id,
    required this.name,
    this.included = true,
    this.highlight = false,
    this.value,
  });

  factory PlanFeatureItem.fromJson(Map<String, dynamic> json, {String language = 'fr'}) {
    final nameRaw = json['name'];
    final name = nameRaw is Map
        ? (nameRaw[language] ?? nameRaw['fr'] ?? nameRaw['en'] ?? '').toString()
        : (nameRaw ?? '').toString();

    final valRaw = json['value'];
    String? val;
    if (valRaw is Map) {
      val = (valRaw[language] ?? valRaw['fr'] ?? valRaw['en'])?.toString();
    } else if (valRaw != null) {
      val = valRaw.toString();
    }

    return PlanFeatureItem(
      id: (json['id'] ?? '').toString(),
      name: name,
      included: json['included'] == true,
      highlight: json['highlight'] == true,
      value: val,
    );
  }
}

class PlanConfigModel {
  final String slug;
  final String name;
  final String description;
  final Map<String, double> monthlyPricing;
  final Map<String, double> yearlyPricing;
  final bool highlight;
  final int order;
  final List<String> featureSummary;
  final List<PlanFeatureCategory> categories;

  PlanConfigModel({
    required this.slug,
    required this.name,
    required this.description,
    required this.monthlyPricing,
    required this.yearlyPricing,
    this.highlight = false,
    this.order = 1,
    this.featureSummary = const [],
    this.categories = const [],
  });

  factory PlanConfigModel.fromJson(Map<String, dynamic> json, {String language = 'fr'}) {
    final nameRaw = json['name'];
    final name = nameRaw is Map
        ? (nameRaw[language] ?? nameRaw['fr'] ?? nameRaw['en'] ?? '').toString()
        : (nameRaw ?? '').toString();

    final descRaw = json['description'];
    final description = descRaw is Map
        ? (descRaw[language] ?? descRaw['fr'] ?? descRaw['en'] ?? '').toString()
        : (descRaw ?? '').toString();

    final pricingRaw = json['pricing'] as Map<String, dynamic>? ?? {};
    final monthlyRaw = pricingRaw['monthly'] as Map<String, dynamic>? ?? {};
    final yearlyRaw = pricingRaw['yearly'] as Map<String, dynamic>? ?? {};

    final monthlyPricing = <String, double>{};
    monthlyRaw.forEach((k, v) => monthlyPricing[k] = (v is num ? v.toDouble() : 0.0));

    final yearlyPricing = <String, double>{};
    yearlyRaw.forEach((k, v) => yearlyPricing[k] = (v is num ? v.toDouble() : 0.0));

    final featSummaryRaw = json['featureSummary'];
    List<String> summary = [];
    if (featSummaryRaw is Map) {
      final list = featSummaryRaw[language] ?? featSummaryRaw['fr'] ?? featSummaryRaw['en'];
      if (list is List) {
        summary = list.map((e) => e.toString()).toList();
      }
    } else if (featSummaryRaw is List) {
      summary = featSummaryRaw.map((e) => e.toString()).toList();
    }

    final catRaw = json['categories'] as List? ?? [];
    final categories = catRaw
        .map((e) => PlanFeatureCategory.fromJson(e as Map<String, dynamic>, language: language))
        .toList();

    return PlanConfigModel(
      slug: (json['slug'] ?? 'free').toString(),
      name: name,
      description: description,
      monthlyPricing: monthlyPricing,
      yearlyPricing: yearlyPricing,
      highlight: json['highlight'] == true,
      order: json['order'] is int ? json['order'] as int : 1,
      featureSummary: summary,
      categories: categories,
    );
  }

  ({double amount, String currency, String formattedPrice}) getPriceForCountry(String? countryCode) {
    String curr = 'XAF';
    switch (countryCode) {
      case 'FR':
      case 'BE':
      case 'DE':
      case 'IT':
      case 'ES':
        curr = 'EUR';
        break;
      case 'US':
      case 'CA':
      case 'GB':
        curr = 'USD';
        break;
      case 'CM':
      default:
        curr = 'XAF';
        break;
    }

    final amt = monthlyPricing[curr] ?? (curr == 'EUR' ? 5.0 : curr == 'USD' ? 6.0 : 2000.0);
    String formatted;
    if (amt == 0) {
      formatted = '0 FCFA';
    } else if (curr == 'EUR') {
      formatted = '${amt.toStringAsFixed(0)} € / mois';
    } else if (curr == 'USD') {
      formatted = '${amt.toStringAsFixed(0)} \$ / month';
    } else {
      formatted = '${amt.toStringAsFixed(0)} FCFA / mois';
    }

    return (amount: amt, currency: curr, formattedPrice: formatted);
  }
}
