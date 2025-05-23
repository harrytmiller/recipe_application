// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_log/pages/add_recipe_page/add_recipe_manager.dart';
import 'package:flutter_log/pages/add_recipe_page/remove_recipes.dart';
import 'package:flutter_log/pages/add_remove_ingredients_page/ingredientManager.dart';

// Validation Rules e.g., Units, API to check food restriction, Recipe Name checks against previous recipes, Units storage in database, Quantity validation
class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  AddRemoveRecipeManager addRemoveRecipeManager = AddRemoveRecipeManager();
  IngredientManager ingredientManager = IngredientManager();
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _foodRestrictionController = TextEditingController();
  final List<Map<String, dynamic>> _ingredients = [];
  String _selectedUnit = 'Select Unit';
  final List<String> _units = ['Select Unit', 'Cups', 'Grams', 'Pieces'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Add/Remove Recipes'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShowRecipePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 75, 175, 80),
            ),
            child: const Row(
              children: [
                Icon(Icons.cookie_outlined),
                SizedBox(width: 8.0),
                Text('View Recipes'),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRecipeDetailsInput(),
              const SizedBox(height: 16.0),
              _buildHeader('Ingredients:'),
              _buildIngredientInput(),
              const SizedBox(height: 16.0),
              _buildHeader('Recipe Ingredients:'),
              Expanded(
                child: _ingredients.isEmpty
                    ? _buildNoIngredientsWidget()
                    : _buildIngredientsList(),
              ),
              const SizedBox(height: 16.0),
              _buildButtonsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
    );
  }

  Widget _buildRecipeDetailsInput() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader('Recipe Name:'),
              _buildTextField(_recipeNameController, 'Enter recipe name'),
            ],
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader('Food Restriction:'),
              _buildTextField(_foodRestrictionController, 'Enter Food Restriction'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoIngredientsWidget() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'No ingredients added yet.',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget _buildIngredientsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = _ingredients[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.green[200], // Change the card background color
          child: ListTile(
            title: Text(
              ingredient['ingredient'],
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: ingredient['quantity'] != null
                ? Text('Quantity: ${ingredient['quantity']}')
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  _ingredients.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            _saveRecipe();
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          ),
          child: const Text('Save Recipe'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _ingredients.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          ),
          child: const Text('Clear Ingredients'),
        ),
      ],
    );
  }

  Widget _buildIngredientInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ingredientController,
            decoration: const InputDecoration(
              hintText: 'Enter ingredient',
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Quantity',
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        DropdownButton<String>(
          value: _selectedUnit,
          items: _units.map((unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedUnit = value!;
            });
          },
        ),
        const SizedBox(width: 16.0),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _addIngredient();
          },
        ),
      ],
    );
  }

  Future<void> _addIngredient() async {
    String ingredient = _ingredientController.text;
    String quantity = _quantityController.text;

    // Validation: Check if ingredient and quantity are not empty
    if (await _validateIngredient(ingredient, quantity)) {
      setState(() {
        _ingredients.add({
          'ingredient': ingredient,
          'quantity': quantity.isNotEmpty ? '$quantity $_selectedUnit' : null,
        });
        _ingredientController.clear();
        _quantityController.clear();
        _selectedUnit = 'Select Unit';
      });
      print(_ingredients);
    }
  }

  Future<bool> _validateIngredient(String ingredient, String quantity) async {
    if (ingredient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an ingredient.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Show loading indicator while checking ingredient validity
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking ingredient validity...'),
        backgroundColor: Colors.blue,
      ),
    );

    // Simulate an API call to check ingredient validity
    await Future.delayed(const Duration(seconds: 2));

    // Replace the condition with your actual API check for ingredient validity
    if (await ingredientManager.checkIngredientIsValid(ingredient, quantity) ==
        false) {
      // Hide loading indicator and show an error Snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Ingredient not found. Please enter a valid ingredient.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Check if quantity is not zero
    if (quantity.isNotEmpty) {
      double parsedQuantity = double.tryParse(quantity) ?? 0;
      if (parsedQuantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid quantity greater than 0.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    // If everything is valid, return true
    return true;
  }

  Future<void> _saveRecipe() async {
    String recipeName = _recipeNameController.text;
    String foodRestriction = _foodRestrictionController.text;

    // Validation: Check if recipe name and ingredients are not empty
    if (recipeName.isNotEmpty &&
        _ingredients.isNotEmpty &&
        foodRestriction.isNotEmpty) {
      // Save recipe name and ingredients to the system
      await addRemoveRecipeManager.saveRecipe(
          _ingredients, recipeName, foodRestriction);
      setState(() {
        _ingredients.clear();
        _recipeNameController.clear();
        _foodRestrictionController.clear();
      });
      print(_ingredients);
    } else {
      // Display specific error messages for empty fields
      if (recipeName.isEmpty && _ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a recipe name and add ingredients.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (recipeName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a recipe name.'),
            backgroundColor: Colors.red,
          ),
        );
            } else if (foodRestriction.isEmpty) { // This condition is missing in the original code
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a food restriction.'), // This message is missing in the original code
          backgroundColor: Colors.red,
        ),
      );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add ingredients.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
