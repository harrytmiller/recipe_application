// ignore_for_file: avoid_print

import 'package:flutter_log/pages/add_remove_ingredients_page/ingredientManager.dart';

class NotificationManager {
  late IngredientManager ingredientManager = IngredientManager();

  // Returns a list of the expired items that are deleted from the cloud
  Future<List<Map<String, String>>> removeExpiredIngredientsAndNotify() async {
    try {
      DateTime currentDate = DateTime.now();

      // Retrieve user ingredients
      List<List<String>> userIngredients =
          await ingredientManager.getUserIngredients();

      print("userIngredients: $userIngredients");

      // Prepare a list to notify the user about removed ingredients
      List<Map<String, String>> removedIngredients = [];
      List<List<String>> nonExpired = [];

      for (List<String> userIngredient in userIngredients) {
        String name = userIngredient[0];
        String weight = userIngredient[1];
        String expiryDateString = userIngredient[2];

        // Convert expiry date string to DateTime
        DateTime expiryDate = DateTime.parse(expiryDateString);

        // Check if the ingredient has expired
        if (expiryDate.isBefore(currentDate)) {
          // Add the ingredient details to the list
          removedIngredients.add({
            'name': name,
            'expiryDate': expiryDateString,
          });
        } else {
          // Non-Expired ingredients stored
          nonExpired.add([name, weight, expiryDateString]);
        }
      }

      if (removedIngredients.isNotEmpty) {
        ingredientManager.flushUserIngredients(nonExpired);
      } else {
        print('No Expired Ingredients to Return');
      }

      return removedIngredients; // Return the list of removed ingredients
    } catch (e) {
      print('Error removing expired ingredients: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<int> warnEfficiency() async {
    int efficiencyValue = 95; // Efficiency Function Required from Generation
    return efficiencyValue;
  }
}
