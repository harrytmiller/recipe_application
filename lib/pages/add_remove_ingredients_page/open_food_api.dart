// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientAPI {
  // Returns a boolean value that determines if the ingredient is valid
  Future<bool> ingredientAPICheck(String ingredientName) async {
    if (ingredientName == '' || ingredientName.isEmpty) {
      return false;
    }

    final String apiUrl =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$ingredientName&search_simple=1&action=process&json=1';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Check if there are products in the response
        if (data['products'] != null && (data['products'] as List).isNotEmpty) {
          print('Product Exists');
          return true; // Ingredient exists
        } else {
          print('Product Doesn\'t Exist');
          return false; // Ingredient doesn't exist
        }
      } else {
        // Handle error if the API request fails
        print('API request failed with status code: ${response.statusCode}');
        return false; // Consider it doesn't exist for simplicity
      }
    } catch (e) {
      // Handle exceptions
      print('Error during API request: $e');
      return false; // Consider it doesn't exist for simplicity
    }
  }
}
