// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_log/pages/profile_page/userManager.dart';

// Consideration: Number of Ingredients a Recipe Should Have
// Add a food restriction
// Rating value

class AddRemoveRecipeManager {
  late FirebaseAuth? auth;
  late FirebaseFirestore firestore;
  late UserManager userManager;

  AddRemoveRecipeManager({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    userManager = UserManager(auth: this.auth!, firestore: this.firestore);
  }

  Future<void> saveRecipe(List<Map<String, dynamic>> ingredients,
      String recipeName, String foodRestiction) async {
    userManager = UserManager(firestore: firestore, auth: auth);
    String uid = await userManager.getCurrentUserUID();

    // Add the recipeName to each ingredient map
    List<Map<String, dynamic>> convertedList = ingredients.map((ingredient) {
      return {
        'ingredient': ingredient['ingredient'],
        'quantity': ingredient['quantity'],
      };
    }).toList();

    if (uid.isNotEmpty) {
      try {
        await firestore
            .collection("Recipes")
            .doc(uid)
            .collection(
                "UserRecipes") // Add a subcollection for user-specific recipes
            .add({
          'ingredients': convertedList,
          'recipeName': recipeName,
          'rating': "Null",
          'foodRestriction': foodRestiction,
          'createdAt': FieldValue.serverTimestamp()
        });
        print('Ingredients Stored');
        await getAllRecipes();
      } catch (e) {
        print("Error Ingredients Not Stored: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>?> getAllRecipes() async {
    userManager = UserManager(firestore: firestore, auth: auth);
    String uid = await userManager.getCurrentUserUID();
    List<Map<String, dynamic>>? recipes = [];

    print("uid: $uid");

    if (uid.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await firestore
            .collection("Recipes")
            .doc(uid)
            .collection("UserRecipes")
            .get();

        recipes = querySnapshot.docs
            .map((doc) => doc.data())
            .cast<Map<String, dynamic>>()
            .toList();
      } catch (e) {
        print("Error fetching recipes: $e");
      }
    }
    print(recipes);
    return recipes;
  }

  Future<void> deleteRecipe(
      String recipeName, List<Map<String, dynamic>> ingredients) async {
    userManager = UserManager(auth: auth, firestore: firestore);
    String uid = await userManager.getCurrentUserUID();

    if (uid.isNotEmpty) {
      try {
        // Query for the document to delete based on recipe name and ingredients
        QuerySnapshot querySnapshot = await firestore
            .collection("Recipes")
            .doc(uid)
            .collection("UserRecipes")
            .where('recipeName', isEqualTo: recipeName)
            .where('ingredients', isEqualTo: ingredients)
            .get();

        // Check if any documents match the query
        if (querySnapshot.docs.isNotEmpty) {
          // Delete the first matching document
          await firestore
              .collection("Recipes")
              .doc(uid)
              .collection("UserRecipes")
              .doc(querySnapshot.docs.first.id)
              .delete();

          print('Recipe deleted successfully');
          // Optionally, you can update the UI or perform any other actions after deletion.
          await getAllRecipes();
        } else {
          print('Recipe not found');
        }
      } catch (e) {
        print("Error deleting recipe: $e");
      }
    }
  }
}
