import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_log/pages/add_remove_ingredients_page/ingredientManager.dart';
import 'package:flutter_log/pages/add_remove_ingredients_page/open_food_api.dart';
import 'package:flutter_log/pages/profile_page/userManager.dart';
import 'package:flutter_log/pages/recipe_generation_page/api_search.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockIngredientManager extends Mock implements IngredientManager {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserManager extends Mock implements UserManager {}

class MockIngredientAPI extends Mock implements IngredientAPI {}

class MockAPISearch extends Mock implements RecipeService {}

void main() {
  group('RecipeService', () {
    late MockClient client;
    late IngredientManager ingredientManager;
    late RecipeService recipeService;
    late FirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    late MockIngredientAPI mockApi;
    late MockUser mockUser;

    Future<void> setupServices() async {
      mockApi = MockIngredientAPI();

      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();

      ingredientManager =
          IngredientManager(auth: mockAuth, firestore: fakeFirestore);
      ingredientManager.api = mockApi;
      ingredientManager.firestore = fakeFirestore;

      when(mockAuth.currentUser).thenReturn(mockUser);

      client = MockClient();
      recipeService =
          RecipeService(client: client, ingredientManager: ingredientManager);
    }

    setUp(setupServices);

    test(
        'fetchRecipesBasedOnUserIngredients returns empty list when no ingredients are provided',
        () async {
      when(ingredientManager.userManager.getCurrentUserUID())
          .thenAnswer((_) => Future.value('TestUid'));
      when(recipeService.fetchRecipesBasedOnUserIngredients())
          .thenAnswer((_) => Future.value([]));

      final List<dynamic> result =
          await recipeService.fetchRecipesBasedOnUserIngredients();
      expect(result, isEmpty);
    });

    test(
        'fetchRecipesBasedOnUserIngredients returns recipes when ingredients are provided',
        () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(recipeService.fetchRecipesBasedOnUserIngredients())
          .thenAnswer((_) async => Future.value([
                ['Tomato'],
                ['Onion']
              ]));

      final List<dynamic> result = await recipeService
          .fetchRecipesBasedOnUserIngredients(); //ERROR ON THIS LINE
      expect(result.length, 5);
      expect(result[0]['recipe']['label'], isA<String>());
      expect(result[0]['recipe']['label'], isNotEmpty);
      expect(result[0]['recipe']['url'], isA<String>());
      expect(result[0]['recipe']['url'], isNotEmpty);
      expect(result[0]['recipe']['url'], matches(RegExp(r'^https?://.+')));
    });

    test(
        'fetchRecipesBasedOnUserIngredients returns recipes when several of the same ingredient is provided',
        () async {
      when(ingredientManager.userManager.getCurrentUserUID())
          .thenAnswer((_) => Future.value('TestUid'));
      when(recipeService.fetchRecipesBasedOnUserIngredients())
          .thenAnswer((_) => Future.value([
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato'],
                ['Tomato']
              ]));

      final List<dynamic> result =
          await recipeService.fetchRecipesBasedOnUserIngredients();

      expect(result.length, 5);
      expect(result[0]['recipe']['label'], isA<String>());
      expect(result[0]['recipe']['label'], isNotEmpty);
      expect(result[0]['recipe']['url'], isA<String>());
      expect(result[0]['recipe']['url'], isNotEmpty);
      expect(result[0]['recipe']['url'], matches(RegExp(r'^https?://.+')));
    });

    test('fetchRecipesBasedOnUserIngredients returns in less than 5s',
        () async {
      when(ingredientManager.userManager.getCurrentUserUID())
          .thenAnswer((_) => Future.value('TestUid'));
      when(recipeService.fetchRecipesBasedOnUserIngredients())
          .thenAnswer((_) => Future.value([
                ['Tomato'],
                ['Onion']
              ]));

      final Stopwatch stopwatch = Stopwatch()..start();
      await recipeService.fetchRecipesBasedOnUserIngredients();
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
    test('fetchRecipesBasedOnUserIngredients returns in less than 5s',
        () async {
      when(ingredientManager.userManager.getCurrentUserUID())
          .thenAnswer((_) => Future.value('TestUid'));
      when(recipeService.fetchRecipesBasedOnUserIngredients())
          .thenAnswer((_) => Future.value([
                ['Tomato']
              ]));

      final Stopwatch stopwatch = Stopwatch()..start();
      await recipeService.fetchRecipesBasedOnUserIngredients();
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
  });
}