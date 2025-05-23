// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log/pages/add_recipe_page/add_recipe_manager.dart';
import 'package:intl/intl.dart';

class ShowRecipePage extends StatefulWidget {
  const ShowRecipePage({super.key});

  @override
  _ShowRecipePageState createState() => _ShowRecipePageState();
}

class _ShowRecipePageState extends State<ShowRecipePage> {
  List<Map<String, dynamic>> recipes = [];
  AddRemoveRecipeManager addRemoveRecipeManager = AddRemoveRecipeManager();

  @override
  void initState() {
    super.initState();
    // Call getAllRecipes function when the page is initialized
    _fetchRecipes();
  }

  // Fetch recipes and update the state
  Future<void> _fetchRecipes() async {
    final fetchedRecipes = await addRemoveRecipeManager.getAllRecipes();
    setState(() {
      recipes = fetchedRecipes ?? [];
    });
  }

  // Function to delete a recipe
  Future<void> _deleteRecipe(
      String recipeName, List<Map<String, dynamic>> ingredients) async {
    try {
      await addRemoveRecipeManager.deleteRecipe(recipeName, ingredients);
      // Update the state to reflect the changes
      await _fetchRecipes();
    } catch (e) {
      print("Error deleting recipe: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Recipes'),
      ),
      backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildRecipesList(),
        ),
      ),
    );
  }

  Widget _buildRecipesList() {
    if (recipes.isEmpty) {
      // Show a popup indicating that there are no recipes
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No recipes available',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Return to the previous page
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final recipeName = recipe['recipeName'] ?? 'Unnamed Recipe';
        final rating = recipe['rating'] is int ? recipe['rating'] : 0;
        final description = recipe['foodRestriction'];
        final List<Map<String, dynamic>> ingredients =
            (recipe['ingredients'] as List<dynamic>)
                .cast<Map<String, dynamic>>();
        final createdAt = recipe['createdAt']
            as Timestamp?; // Assuming you store the timestamp

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              recipeName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Text(
                  'Food Restriction: ${description ?? 'Not specified'}',
                  style: const TextStyle(fontSize: 14),
                ),
                if (createdAt != null)
                  Text(
                    'Date Created: ${_formatDateTime(createdAt.toDate())}',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
            onTap: () {
              _showIngredientsPopup(context, recipeName, ingredients);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Show a confirmation dialog before deleting the recipe
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete the recipe?"),
                      actions: [
                        ElevatedButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        ElevatedButton(
                          child: const Text("Delete"),
                          onPressed: () {
                            // Call the function to delete the recipe
                            _deleteRecipe(recipeName, ingredients);

                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Function to format DateTime
  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  // Function to show a popup with ingredients and quantities
  void _showIngredientsPopup(BuildContext context, String recipeName,
      List<Map<String, dynamic>> ingredients) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingredients for $recipeName'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final ingredient in ingredients)
                Text(
                  '${ingredient['quantity'] ?? 'Quantity not specified'} of ${ingredient['ingredient']}',
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
          actions: [
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
