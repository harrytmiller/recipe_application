// Mock class for UserManager
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_log/pages/add_recipe_page/add_recipe_manager.dart';
import 'package:flutter_log/pages/profile_page/userManager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock class for UserManager
class MockUserManager extends Mock implements UserManager {}

// Mock class for FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late AddRemoveRecipeManager addRemoveRecipeManager;
  late FirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    // Mock FirebaseAuth and FirebaseFirestore
    fakeFirestore = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth();

    addRemoveRecipeManager =
        AddRemoveRecipeManager(auth: mockAuth, firestore: fakeFirestore);
    addRemoveRecipeManager.firestore = fakeFirestore;
  });

  group('addRemoveRecipeManager Test: deleteRecipe()', () {
    test('Recipe Cannot Be Deleted due to UID as Null', () async {
      final convertedList = ['ingredient1', 'ingredient2', 'ingredient3'];
      const recipeName = 'Example Recipe';
      const foodRestriction = 'None';

      // Recipe Added to Fake Firestore
      await fakeFirestore
          .collection("Recipes")
          .doc("dummyUid")
          .collection("UserRecipes")
          .add({
        'ingredients': convertedList,
        'recipeName': recipeName,
        'rating': '5',
        'foodRestriction': foodRestriction,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);

      await addRemoveRecipeManager.deleteRecipe(recipeName, [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'}
      ]);

      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc(null)
          .collection("UserRecipes")
          .get();

      // Fetching all ingredients
      final storedIngredients =
          storedDocument.docs.map((doc) => doc.data()).toList();

      expect([], storedIngredients);
    });

    test('Recipe Successfully Deleted', () async {
      final convertedList = ['ingredient1', 'ingredient2', 'ingredient3'];
      const recipeName = 'Example Recipe';
      const foodRestriction = 'None';

      // Add a recipe to Firestore
      final newRecipeRef = await fakeFirestore
          .collection("Recipes")
          .doc("dummyUID")
          .collection("UserRecipes")
          .add({
        'ingredients': convertedList,
        'recipeName': recipeName,
        'rating': '5',
        'foodRestriction': foodRestriction,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Arrange
      when(mockAuth.currentUser).thenReturn(MockUser(uid: "dummyUID"));

      // Act
      await addRemoveRecipeManager.deleteRecipe(recipeName, [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'}
      ]);

      // Verify
      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc("dummyUID")
          .collection("UserRecipes")
          .doc(newRecipeRef.id) // Use the reference from the added recipe
          .get();

      // Assert
      expect(!storedDocument.exists, false);
    });

    test('Recipe Successfully Deleted', () async {
      final convertedList = [
        'ingredient1',
        'ingredient2',
        'ingredient3',
        'ingredient4'
      ];
      const recipeName = 'Example Recipe';
      const foodRestriction = 'Vegan';

      // Add a recipe to Firestore
      final newRecipeRef = await fakeFirestore
          .collection("Recipes")
          .doc("dummyUID")
          .collection("UserRecipes")
          .add({
        'ingredients': convertedList,
        'recipeName': recipeName,
        'rating': '5',
        'foodRestriction': foodRestriction,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Arrange
      when(mockAuth.currentUser).thenReturn(MockUser(uid: "dummyUID"));

      // Act
      await addRemoveRecipeManager.deleteRecipe(recipeName, [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'},
        {'ingredient': 'ingredient2', 'quantity': 'quantity2'}
      ]);

      // Verify
      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc("dummyUID")
          .collection("UserRecipes")
          .doc(newRecipeRef.id) // Use the reference from the added recipe
          .get();

      // Assert
      expect(!storedDocument.exists, false);
    });
  });

  group('addRemoveRecipeManager Test: saveRecipe()', () {
    test('Recipe saved successfully check ingredients', () async {
      // Arrange
      final ingredients = [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'},
        {'ingredient': 'ingredient2', 'quantity': 'quantity2'}
      ];
      const recipeName = 'Example Recipe';
      const foodRestiction = 'None';

      // Mock the behavior of userManager.getCurrentUserUID()
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Act
      await addRemoveRecipeManager.saveRecipe(
          ingredients, recipeName, foodRestiction);

      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc('dummyUid')
          .collection("UserRecipes")
          .get();

      final storedIngredients = storedDocument.docs
          .map((doc) => doc.data()['ingredients'])
          .toList(); // Fetching all ingredients

      // Assert
      expect(storedIngredients, [
        [
          {"ingredient": "ingredient1", "quantity": "quantity1"},
          {"ingredient": "ingredient2", "quantity": "quantity2"}
          // Add more expected ingredients as needed
        ]
      ]);
    });

    test('Recipe saved successfully check foodRestriction', () async {
      // Arrange
      final ingredients = [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'},
        {'ingredient': 'ingredient2', 'quantity': 'quantity2'}
      ];
      const recipeName = 'Example Recipe';
      const foodRestiction = 'None';

      // Mock the behavior of userManager.getCurrentUserUID()
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Act
      await addRemoveRecipeManager.saveRecipe(
          ingredients, recipeName, foodRestiction);

      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc('dummyUid')
          .collection("UserRecipes")
          .get();

      final storedIngredients = storedDocument.docs
          .map((doc) => doc.data()['foodRestriction'])
          .toList(); // Fetching all ingredients

      // Assert
      expect(storedIngredients, ['None']);
    });

    test('Recipe saved successfully check recipeName', () async {
      // Arrange
      final ingredients = [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'},
        {'ingredient': 'ingredient2', 'quantity': 'quantity2'}
      ];
      const recipeName = 'Example Recipe';
      const foodRestiction = 'None';

      // Mock the behavior of userManager.getCurrentUserUID()
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Act
      await addRemoveRecipeManager.saveRecipe(
          ingredients, recipeName, foodRestiction);

      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc('dummyUid')
          .collection("UserRecipes")
          .get();

      final storedIngredients = storedDocument.docs
          .map((doc) => doc.data()['recipeName'])
          .toList(); // Fetching all ingredients

      // Assert
      expect(storedIngredients, ['Example Recipe']);
    });

    test('Recipe unsaved due to unauthorisation should return []', () async {
      // Arrange
      final ingredients = [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'},
        {'ingredient': 'ingredient2', 'quantity': 'quantity2'}
      ];
      const recipeName = 'Example Recipe';
      const foodRestiction = 'None';

      // Mock the behavior of userManager.getCurrentUserUID()
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      await addRemoveRecipeManager.saveRecipe(
          ingredients, recipeName, foodRestiction);

      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc(null)
          .collection("UserRecipes")
          .get();

      final storedIngredients = storedDocument.docs
          .map((doc) => doc.data())
          .toList(); // Fetching all ingredients

      // Assert
      expect(storedIngredients, []);
    });

    test('Recipe unsaved due bad UID should return []', () async {
      // Arrange
      final ingredients = [
        {'ingredient': 'ingredient1', 'quantity': 'quantity1'},
        {'ingredient': 'ingredient2', 'quantity': 'quantity2'}
      ];
      const recipeName = 'Example Recipe';
      const foodRestiction = 'None';

      // Mock the behavior of userManager.getCurrentUserUID()
      when(mockAuth.currentUser).thenReturn(MockUser(uid: ''));

      // Act
      await addRemoveRecipeManager.saveRecipe(
          ingredients, recipeName, foodRestiction);

      final storedDocument = await fakeFirestore
          .collection('Recipes')
          .doc('')
          .collection("UserRecipes")
          .get();

      final storedIngredients = storedDocument.docs
          .map((doc) => doc.data())
          .toList(); // Fetching all ingredients

      // Assert
      expect(storedIngredients, []);
    });
  });

  group('addRemoveRecipeManager Test: getAllRecipes()', () {
    test('Unauthenticated so return empty list', () async {
      final convertedList = ['ingredient1', 'ingredient2', 'ingredient3'];
      const recipeName = 'Example Recipe';
      const foodRestriction = 'None';

      // Add a recipe to Firestore
      await fakeFirestore
          .collection("Recipes")
          .doc("dummyUid")
          .collection("UserRecipes")
          .add({
        'ingredients': convertedList,
        'recipeName': recipeName,
        'rating': '5',
        'foodRestriction': foodRestriction,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      final result = await addRemoveRecipeManager.getAllRecipes();

      // Assert
      expect(result, []);
    });
    test('Unauthenticated so return empty list', () async {
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      final result = await addRemoveRecipeManager.getAllRecipes();

      // Assert
      expect(result, []);
    });

    test('Empty UID so return empty list', () async {
      // Arrange
      when(mockAuth.currentUser).thenReturn(MockUser(uid: ''));

      // Act
      final result = await addRemoveRecipeManager.getAllRecipes();

      // Assert
      expect(result, []);
    });

    test('Authenticated User so return snapshotted list', () async {
      final convertedList = ['ingredient1', 'ingredient2', 'ingredient3'];
      const recipeName = 'Example Recipe';
      const foodRestriction = 'None';

      // Add a recipe to Firestore
      await fakeFirestore
          .collection("Recipes")
          .doc("dummyUid")
          .collection("UserRecipes")
          .add({
        'ingredients': convertedList,
        'recipeName': recipeName,
        'rating': '5',
        'foodRestriction': foodRestriction,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Arrange
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Act
      final result = await addRemoveRecipeManager.getAllRecipes();

      // Convert the result into a testable format
      final resultList = result!.map((doc) {
        return {
          'ingredients': doc['ingredients'],
          'recipeName': doc['recipeName'],
          'rating': doc['rating'],
          'foodRestriction': doc['foodRestriction'],
          'createdAt':
              doc['createdAt'].runtimeType, // Get the type of the timestamp
        };
      }).toList();

      // Assert
      expect(resultList, [
        {
          'ingredients': convertedList,
          'recipeName': recipeName,
          'rating': '5',
          'foodRestriction': foodRestriction,
          'createdAt': Timestamp, // Compare against the type Timestamp
        }
      ]);
    });

    test('Authenticated User so return snapshotted list with null categories',
        () async {
      final convertedList = ['potato', 'tomato', 'carrot'];
      const recipeName = 'Josh\'s Recipe';
      const foodRestriction = 'Vegan';

      // Add a recipe to Firestore
      await fakeFirestore
          .collection("Recipes")
          .doc("dummyUid")
          .collection("UserRecipes")
          .add({
        'ingredients': convertedList,
        'recipeName': recipeName,
        'rating': null,
        'foodRestriction': foodRestriction,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Arrange
      when(mockAuth.currentUser).thenReturn(MockUser(uid: 'dummyUid'));

      // Act
      final result = await addRemoveRecipeManager.getAllRecipes();

      // Convert the result into a testable format
      final resultList = result!.map((doc) {
        return {
          'ingredients': doc['ingredients'],
          'recipeName': doc['recipeName'],
          'rating': doc['rating'],
          'foodRestriction': doc['foodRestriction'],
          'createdAt':
              doc['createdAt'].runtimeType, // Get the type of the timestamp
        };
      }).toList();

      // Assert
      expect(resultList, [
        {
          'ingredients': convertedList,
          'recipeName': recipeName,
          'rating': null,
          'foodRestriction': foodRestriction,
          'createdAt': Timestamp, // Compare against the type Timestamp
        }
      ]);
    });
  });
}
