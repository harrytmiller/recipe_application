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
    late FirebaseAuth mockAuth;
    late MockIngredientAPI mockApi;
    late MockUser mockUser;

    Future<void> setupServices() async {
      mockApi = MockIngredientAPI();

      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser(uid: 'TestUid');

      final userManager = UserManager(auth: mockAuth, firestore: fakeFirestore);
      
      ingredientManager = IngredientManager(auth: mockAuth, firestore: fakeFirestore);
      ingredientManager.userManager = userManager;
      ingredientManager.api = mockApi;
      ingredientManager.firestore = fakeFirestore;

      client = MockClient();
      recipeService = RecipeService(client: client, ingredientManager: ingredientManager);
    }

    setUp(setupServices);

    test(
        'fetchRecipesBasedOnUserIngredients returns empty list when no ingredients are provided',
        () async {
      when(mockAuth.currentUser).thenReturn(mockUser);

      final List<dynamic> result = await recipeService.fetchRecipesBasedOnUserIngredients();
      expect(result, isEmpty);
    });

    test(
        'fetchRecipesBasedOnUserIngredients returns recipes when ingredients are provided',
        () async {
      await fakeFirestore.collection('UserIngredients').doc('TestUid').set({
        'ingredients': [
          {'name': 'Tomato', 'weight': '100', 'expiryDate': '2025-12-31'},
          {'name': 'Onion', 'weight': '50', 'expiryDate': '2025-12-31'},
        ]
      });

      when(mockAuth.currentUser).thenReturn(mockUser);

      // Mock HTTP response - use specific Uri
      when(client.get(Uri.parse('https://api.edamam.com/search'))).thenAnswer((_) async => http.Response(
          '{"hits": [' +
              '{"recipe": {"label": "Test Recipe 1", "url": "https://example.com/recipe1"}},' +
              '{"recipe": {"label": "Test Recipe 2", "url": "https://example.com/recipe2"}},' +
              '{"recipe": {"label": "Test Recipe 3", "url": "https://example.com/recipe3"}},' +
              '{"recipe": {"label": "Test Recipe 4", "url": "https://example.com/recipe4"}},' +
              '{"recipe": {"label": "Test Recipe 5", "url": "https://example.com/recipe5"}}' +
              ']}',
          200));

      final List<dynamic> result = await recipeService.fetchRecipesBasedOnUserIngredients();
      
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
      await fakeFirestore.collection('UserIngredients').doc('TestUid').set({
        'ingredients': List.generate(10, (index) => 
          {'name': 'Tomato', 'weight': '100', 'expiryDate': '2025-12-31'}
        )
      });

      when(mockAuth.currentUser).thenReturn(mockUser);

      when(client.get(Uri.parse('https://api.edamam.com/search'))).thenAnswer((_) async => http.Response(
          '{"hits": [' +
              '{"recipe": {"label": "Tomato Recipe 1", "url": "https://example.com/recipe1"}},' +
              '{"recipe": {"label": "Tomato Recipe 2", "url": "https://example.com/recipe2"}},' +
              '{"recipe": {"label": "Tomato Recipe 3", "url": "https://example.com/recipe3"}},' +
              '{"recipe": {"label": "Tomato Recipe 4", "url": "https://example.com/recipe4"}},' +
              '{"recipe": {"label": "Tomato Recipe 5", "url": "https://example.com/recipe5"}}' +
              ']}',
          200));

      final List<dynamic> result = await recipeService.fetchRecipesBasedOnUserIngredients();

      expect(result.length, 5);
      expect(result[0]['recipe']['label'], isA<String>());
      expect(result[0]['recipe']['label'], isNotEmpty);
      expect(result[0]['recipe']['url'], isA<String>());
      expect(result[0]['recipe']['url'], isNotEmpty);
      expect(result[0]['recipe']['url'], matches(RegExp(r'^https?://.+')));
    });

    test('fetchRecipesBasedOnUserIngredients returns in less than 5s', () async {
      await fakeFirestore.collection('UserIngredients').doc('TestUid').set({
        'ingredients': [
          {'name': 'Tomato', 'weight': '100', 'expiryDate': '2025-12-31'},
          {'name': 'Onion', 'weight': '50', 'expiryDate': '2025-12-31'},
        ]
      });

      when(mockAuth.currentUser).thenReturn(mockUser);

      when(client.get(Uri.parse('https://api.edamam.com/search'))).thenAnswer((_) async => http.Response(
          '{"hits": [{"recipe": {"label": "Quick Recipe", "url": "https://example.com/recipe"}}]}',
          200));

      final Stopwatch stopwatch = Stopwatch()..start();
      await recipeService.fetchRecipesBasedOnUserIngredients();
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    test('fetchRecipesBasedOnUserIngredients single ingredient timing test', () async {
      await fakeFirestore.collection('UserIngredients').doc('TestUid').set({
        'ingredients': [
          {'name': 'Tomato', 'weight': '100', 'expiryDate': '2025-12-31'},
        ]
      });

      when(mockAuth.currentUser).thenReturn(mockUser);

      when(client.get(Uri.parse('https://api.edamam.com/search'))).thenAnswer((_) async => http.Response(
          '{"hits": [{"recipe": {"label": "Single Recipe", "url": "https://example.com/recipe"}}]}',
          200));

      final Stopwatch stopwatch = Stopwatch()..start();
      await recipeService.fetchRecipesBasedOnUserIngredients();
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    test('fetchRecipesBasedOnUserIngredients handles no user', () async {
      when(mockAuth.currentUser).thenReturn(null);

      final List<dynamic> result = await recipeService.fetchRecipesBasedOnUserIngredients();
      expect(result, isEmpty);
    });

    test('fetchRecipesBasedOnUserIngredients handles API error', () async {
      await fakeFirestore.collection('UserIngredients').doc('TestUid').set({
        'ingredients': [
          {'name': 'Tomato', 'weight': '100', 'expiryDate': '2025-12-31'},
        ]
      });

      when(mockAuth.currentUser).thenReturn(mockUser);

      when(client.get(Uri.parse('https://api.edamam.com/search'))).thenAnswer((_) async => http.Response('Error', 500));

      final List<dynamic> result = await recipeService.fetchRecipesBasedOnUserIngredients();
      expect(result, isEmpty);
    });
  });
}