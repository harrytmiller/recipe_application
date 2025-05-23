// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_log/pages/add_remove_ingredients_page/ingredientManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RecipeService {
  final http.Client client;
  final IngredientManager ingredientManager;

  RecipeService({http.Client? client, IngredientManager? ingredientManager})
      : this.client = client ?? http.Client(),
        this.ingredientManager = ingredientManager ?? IngredientManager();

  Future<List<dynamic>> fetchRecipesBasedOnUserIngredients() async {
    // Retrieve the user's ingredients
    List<List<String>> userIngredients = await ingredientManager.getUserIngredients();
    if (userIngredients.isEmpty) {
      //error handling for no ingredients.
      return[];
    }
    // Extract the names of the ingredients
    List<String> ingredientNames = userIngredients.map((ingredient) => ingredient.first).toList();
    //get recipes from API with ingredients in
    List<dynamic> recipesJson = await fetchRecipesWithBestMatches(ingredientNames);
    return recipesJson.toList();
  }

  Future<List<dynamic>> fetchRecipesWithBestMatches(List<String> ingredients) async {
    const String apiId = '09ddd3f5';
    const String apiKey = '3855b5b2d6fb4ca521613798ddbca7d9';

    Set<String> seenRecipeUris = <String>{}; // Track unique recipes by URI
    List<dynamic> allRecipes = [];

    // Get current Firebase user ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('No Firebase user logged in');
      return [];
    }

    // Start with all ingredients and only decrease size if we don't have enough recipes
    for (int ingredientCount = ingredients.length; ingredientCount >= 1; ingredientCount--) {
      if (allRecipes.length >= 8) break; // Stop when we have enough recipes

      List<List<String>> currentCombinations = _getCombinationsOfSize(ingredients, ingredientCount);
      
      for (List<String> ingredientCombo in currentCombinations) {
        if (allRecipes.length >= 8) break;

        String ingredientQuery = ingredientCombo.join(',');
        String url = 'https://api.edamam.com/api/recipes/v2?type=public&app_id=$apiId&app_key=$apiKey&q=$ingredientQuery&to=20';

        try {
          print('Making request with ${ingredientCount} ingredients: ${ingredientCombo.join(', ')}');
          
          final response = await http.get(
            Uri.parse(url),
            headers: {
              'Edamam-Account-User': userId,
            },
          );
          
          if (response.statusCode == 200) {
            Map<String, dynamic> data = json.decode(response.body);
            List<dynamic> recipes = data['hits'];
            
            // Filter out duplicates and add new recipes
            for (var recipe in recipes) {
              if (allRecipes.length >= 8) break;
              
              String recipeUri = recipe['recipe']['uri'];
              if (!seenRecipeUris.contains(recipeUri)) {
                seenRecipeUris.add(recipeUri);
                
                // Calculate how many user ingredients this recipe uses
                int matchCount = _countMatchingIngredients(recipe['recipe'], ingredients);
                recipe['ingredientMatchCount'] = matchCount;
                
                allRecipes.add(recipe);
              }
            }
          } else {
            print('API returned error for combo ${ingredientCombo.join(',')}: ${response.statusCode}');
          }
        } catch (e) {
          print('Error with ingredient combo ${ingredientCombo.join(',')}: ${e.toString()}');
        }
      }
      
      // Only continue to smaller combinations if we don't have enough recipes yet
      if (allRecipes.length >= 8) break;
      
      print('Found ${allRecipes.length} recipes with $ingredientCount ingredients, trying ${ingredientCount - 1} ingredients...');
    }

    // Sort recipes by number of matching ingredients (descending)
    allRecipes.sort((a, b) => 
      (b['ingredientMatchCount'] as int).compareTo(a['ingredientMatchCount'] as int));

    print('Found ${allRecipes.length} unique recipes');
    return allRecipes.take(8).toList();
  }

  List<List<String>> _getCombinationsOfSize(List<String> ingredients, int size) {
    if (size == 1) {
      return ingredients.map((ingredient) => [ingredient]).toList();
    } else if (size == ingredients.length) {
      return [List.from(ingredients)];
    } else {
      return _generateAllCombinations(ingredients, size);
    }
  }

  List<List<String>> _generateAllCombinations(List<String> ingredients, int size) {
    List<List<String>> combinations = [];
    
    void generateCombos(List<String> current, int start) {
      if (current.length == size) {
        combinations.add(List.from(current));
        return;
      }
      
      for (int i = start; i < ingredients.length; i++) {
        current.add(ingredients[i]);
        generateCombos(current, i + 1);
        current.removeLast();
      }
    }
    
    generateCombos([], 0);
    return combinations;
  }

  int _countMatchingIngredients(Map<String, dynamic> recipe, List<String> userIngredients) {
    List<dynamic> recipeIngredients = recipe['ingredientLines'] ?? [];
    int matchCount = 0;
    
    for (String userIngredient in userIngredients) {
      String userIngredientLower = userIngredient.toLowerCase();
      
      for (String recipeIngredient in recipeIngredients.map((e) => e.toString())) {
        if (recipeIngredient.toLowerCase().contains(userIngredientLower)) {
          matchCount++;
          break; // Count each user ingredient only once per recipe
        }
      }
    }
    
    return matchCount;
  }

  Future<List<String>> getRecipeNames() async {
    List<dynamic> recipes = await fetchRecipesBasedOnUserIngredients();
    List<String> labels = [];

    for (int i = 0; i < recipes.length && i < 8; i++) {
      Map<String, dynamic> recipe = recipes[i]['recipe'];
      labels.add(recipe['label']);
    }
    return labels;
  }

  Future<List<String>> getRecipeUrls() async {
    List<dynamic> recipes = await fetchRecipesBasedOnUserIngredients();
    List<String> urls = [];

    for (int i = 0; i < recipes.length && i < 8; i++) {
      Map<String, dynamic> recipe = recipes[i]['recipe'];
      urls.add(recipe['url']);
    }
    return urls;
  }

  Future<List<String>> getRecipeImage() async {
    List<dynamic> recipes = await fetchRecipesBasedOnUserIngredients();
    List<String> images = [];

    for (int i = 0; i < recipes.length && i < 8; i++) {
      Map<String, dynamic> recipe = recipes[i]['recipe'];
      String originalImageUrl = recipe['image'];
      
      String proxyImageUrl;
      if (kIsWeb) {
        proxyImageUrl = 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(originalImageUrl)}';
      } else {
        proxyImageUrl = originalImageUrl;
      }
      
      images.add(proxyImageUrl);
    }
    return images;
  }
}