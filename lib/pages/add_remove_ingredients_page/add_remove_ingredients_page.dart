// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'ingredientManager.dart';

class AddRemoveIngredients extends StatefulWidget {
  const AddRemoveIngredients({super.key});

  @override
  _AddRemoveIngredientsState createState() => _AddRemoveIngredientsState();
}

class _AddRemoveIngredientsState extends State<AddRemoveIngredients> {
  List<List<String>> ingredients = [];

  BuildContext? dialogContext;
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  bool shouldFlush = false;
  IngredientManager manager = IngredientManager();

  @override
  void initState() {
    super.initState();
    _loadUserIngredients();
  }

  Future<void> _loadUserIngredients() async {
    List<List<String>> userIngredients = await manager.getUserIngredients();

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        ingredients = userIngredients;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (ingredients.isNotEmpty) {
          // Show confirmation dialog
          return await _showExitConfirmationDialog();
        }
        // If no ingredients, allow navigation
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text('Add and Remove Ingredients Page'),
        ),
        backgroundColor: Colors.green[200],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _addIngredient();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          padding: const EdgeInsets.all(16.0)),
                      child: const Text('Add'),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _flushIngredients();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            padding: const EdgeInsets.all(16.0)),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Card(
                  elevation: 5.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.68,
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        _buildIngredientForm(),
                        const SizedBox(height: 20.0),
                        _buildIngredientsList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientForm() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ingredientController,
            decoration: const InputDecoration(
              hintText: 'Enter ingredient',
            ),
          ),
        ),
        const SizedBox(width: 30.0),
        Expanded(
          child: TextField(
            controller: weightController,
            decoration: const InputDecoration(
              hintText: 'Enter grams',
            ),
          ),
        ),
        const SizedBox(width: 25.0),
        Expanded(
          child: TextField(
            controller: expiryController,
            decoration: const InputDecoration(
              hintText: 'Enter Expiry Date: YYYY-MM-DD',
            ),
          ),
        ),
        const SizedBox(width: 25.0),
      ],
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        if (shouldFlush) // Conditionally render based on the flush action
          const Text(
            'Ingredients Saved!',
            style: TextStyle(color: Colors.red),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredient: ${ingredients[index][0]}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Quantity: ${ingredients[index][1]} g'),
                          Text('Expiry Date: ${ingredients[index][2]}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeIngredient(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Assign the context to the dialogContext variable
        dialogContext = context;
        return const AlertDialog(
          title: Text('Checking Ingredient Validity'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text('Checking...'),
            ],
          ),
        );
      },
    ).then((value) {
      // This block of code will execute after the dialog is dismissed
      print('Dialog dismissed');
      // Perform any other actions here
    });
  }

  void closeDialog() {
    // Close the dialog using the dialogContext
    if (dialogContext != null) {
      Navigator.of(dialogContext!).pop();
      dialogContext = null; // Reset dialogContext after popping the dialog
    }
  }

  // Adds ingredients to the cloud with necessary validation checks
  Future<void> _addIngredient() async {
    final newIngredient = ingredientController.text.trim();
    final newIngredientWeight = weightController.text.trim();
    final newExpiryDate = expiryController.text.trim();

    showMyDialog(context);
    try {
      // Checks if fields aren't filled before the API validation checks
      if (newIngredient.isNotEmpty &&
          newIngredientWeight.isNotEmpty &&
          newExpiryDate.isNotEmpty) {
        bool isValid = await manager.checkIngredientIsValid(
            newIngredient, newIngredientWeight);

        // Ensures matching ingredients and datetimes are combined, Ensures datetimes are in the correct format
        // Potential Improvement: Datetime formats, and the majority of ways to ensure that the datetime is working
        if (isValid &&
            manager.validateQuantity(newIngredientWeight) &&
            manager.checkUserDateTime(newExpiryDate) &&
            manager.checkDateTimeAgainstTodaysDate(newExpiryDate)) {
          print('Passed These Checks');
          int existingIndex = ingredients.indexWhere((ingredient) =>
              ingredient[0] == newIngredient && ingredient[2] == newExpiryDate);

          setState(() {
            if (existingIndex != -1) {
              int existingWeight =
                  int.tryParse(ingredients[existingIndex][1]) ?? 0;
              int newWeight = int.tryParse(newIngredientWeight) ?? 0;
              ingredients[existingIndex][1] =
                  (existingWeight + newWeight).toString();
            } else {
              ingredients
                  .add([newIngredient, newIngredientWeight, newExpiryDate]);
            }
            ingredientController.clear();
            weightController.clear();
            expiryController.clear();
          });
        } else {
          if (!isValid) {
            _showErrorSnackBar('Invalid ingredient! Please check your input.');
          } else if (!manager.validateQuantity(newIngredientWeight)) {
            _showErrorSnackBar('Invalid weight! Please enter a valid weight.');
          } else if (!manager.checkUserDateTime(newExpiryDate)) {
            _showErrorSnackBar(
                'Invalid expiry date! Please enter a valid date.');
          } else if (!manager.checkDateTimeAgainstTodaysDate(newExpiryDate)) {
            _showErrorSnackBar('Expiry date must be in the future.');
          }
        }
      }
    } catch (e) {
      print('Error adding ingredient: $e');
    } finally {
      closeDialog();
    }
  }

  // Shows that there is a loading message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Removes ingredients from the interface
  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  // Saves ingredients into the cloud
  void _flushIngredients() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Ingredients'),
          content: const Text('Are you sure you want to save the ingredients?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performFlush();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Causes a change in the interface when removing the ingredients
  Future<void> _performFlush() async {
    // Call the method directly from the imported file
    await manager.flushUserIngredients(ingredients);

    setState(() {
      ingredients.clear(); // Clear the ingredients list
      shouldFlush = true; // Set the flag to trigger the flush message
    });

    // Reset the flag after a delay (to display the flush message for a moment)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        shouldFlush = false;
      });
    });
  }

  // Removal dialog
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('Do you want to discard unsaved changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Stay on the page
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Leave the page
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
