import 'package:flutter_test/flutter_test.dart';
import 'package:kauri/core/constants/app_categories.dart';
import 'package:kauri/core/constants/category_labels.dart';

void main() {
  test(
    'codes internes traduits en FR et en EN (plus jamais "deposit" à l\'écran)',
    () {
      expect(CategoryLabels.forLanguage('deposit', 'fr'), 'Recharge');
      expect(CategoryLabels.forLanguage('deposit', 'en'), 'Top-up');
      expect(CategoryLabels.forLanguage('withdrawal', 'fr'), 'Retrait');
      expect(
        CategoryLabels.forLanguage('tontine_payout', 'en'),
        'Tontine payout',
      );
    },
  );

  test('catégories par défaut : inchangées en FR, traduites en EN', () {
    expect(CategoryLabels.forLanguage('Alimentation', 'fr'), 'Alimentation');
    expect(CategoryLabels.forLanguage('Alimentation', 'en'), 'Food');
    for (final c in [
      ...AppCategories.categories,
      ...AppCategories.subscriptionCategories,
    ]) {
      final en = CategoryLabels.forLanguage(c, 'en');
      expect(
        en,
        isNot(matches(RegExp(r'[éèàçù]'))),
        reason: '"$c" non traduite en anglais',
      );
    }
  });

  test('catégorie personnalisée de l\'utilisateur : affichée telle quelle', () {
    expect(
      CategoryLabels.forLanguage('Mon resto préféré', 'en'),
      'Mon resto préféré',
    );
  });

  test("libellés FR déjà humanisés par l'API → anglais (Insights en EN)", () {
    expect(CategoryLabels.forLanguage('Retraits', 'en'), 'Withdrawals');
    expect(
      CategoryLabels.forLanguage('Cotisations tontines', 'en'),
      'Tontine contributions',
    );
    expect(CategoryLabels.forLanguage('Retraits', 'fr'), 'Retraits');
  });
}
