import 'package:flutter_log/pages/add_remove_ingredients_page/open_food_api.dart';
import 'package:test/test.dart';

void main() {
  // API Tests may fail provided no internet. Or due to API changes
  group('IngredientAPI Test: ingredientAPICheck()', () {
    test('Valid ingredient will return true', () async {
      final api = IngredientAPI();
      final result = await api.ingredientAPICheck('eggs');
      expect(result, true);
    });

    test('Valid ingredient will return true', () async {
      final api = IngredientAPI();
      final result = await api.ingredientAPICheck('banana');
      expect(result, true);
    });

    test('Valid ingredient abbreviation will return true', () async {
      final api = IngredientAPI();
      final result = await api.ingredientAPICheck('msg');
      expect(result, true);
    });

    test('Invalid ingredient will return false', () async {
      final api = IngredientAPI();
      final result = await api.ingredientAPICheck('nullwhjq');
      expect(result, false);
    });

    test('Invalid ingredient will return false', () async {
      final api = IngredientAPI();
      final result = await api.ingredientAPICheck('tea');
      expect(result, true);
    });

    test('Invalid ingredient will return false', () async {
      // Originally wrong
      final api = IngredientAPI();
      final result = await api.ingredientAPICheck('');
      expect(result, false);
    });

    test('Invalid ingredient will return false', () async {
      final api = IngredientAPI();
      final result =
          await api.ingredientAPICheck('asdfsdfdfdsajwqhwifeghufrwoqjf');
      expect(result, false);
    });
  });
}
