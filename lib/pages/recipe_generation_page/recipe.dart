import 'dart:convert';

class Recipe {
  String label;
  String image;
  String source;
  String url;
  String shareAs;
  int yield;
  List<String> dietLabels;
  List<String> healthLabels;
  List<String> cautions;
  List<String> ingredientLines;
  List<Ingredient> ingredients;
  String cuisineType;
  String mealType;
  List<String> dishType;
  String totalTime;
  String recipeYield;
  List<String> calories;
  List<String> totalWeight;
  List<String> totalNutrients;
  List<String> totalDaily;

  Recipe({
    required this.label,
    required this.image,
    required this.source,
    required this.url,
    required this.shareAs,
    required this.yield,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredientLines,
    required this.ingredients,
    this.cuisineType = '',
    this.mealType = '',
    this.dishType = const [],
    this.totalTime = '',
    this.recipeYield = '',
    this.calories = const [],
    this.totalWeight = const [],
    this.totalNutrients = const [],
    this.totalDaily = const [],
  });

  factory Recipe.fromJson(String json) {
    final parsed = jsonDecode(json)['recipe'] as Map<String, dynamic>;
    return Recipe(
      label: parsed['label'],
      image: parsed['image'],
      source: parsed['source'],
      url: parsed['url'],
      shareAs: parsed['shareAs'],
      yield: parsed['yield'],
      dietLabels: List<String>.from(parsed['dietLabels']),
      healthLabels: List<String>.from(parsed['healthLabels']),
      cautions: List<String>.from(parsed['cautions']),
      ingredientLines: List<String>.from(parsed['ingredientLines']),
      ingredients: (parsed['ingredients'] as List<dynamic>)
          .map((ingredient) => Ingredient.fromJson(ingredient))
          .toList(),
      cuisineType: parsed['cuisineType'] ?? '',
      mealType: parsed['mealType'] ?? '',
      dishType: List<String>.from(parsed['dishType'] ?? []),
      totalTime: parsed['totalTime'] ?? '',
      recipeYield: parsed['recipeYield'] ?? '',
      calories: List<String>.from(parsed['calories'] ?? []),
      totalWeight: List<String>.from(parsed['totalWeight'] ?? []),
      totalNutrients: List<String>.from(parsed['totalNutrients'] ?? []),
      totalDaily: List<String>.from(parsed['totalDaily'] ?? []),
    );
  }
}

class Ingredient {
  String text;
  String quantity;
  String unit;
  String food;

  Ingredient({
    required this.text,
    required this.quantity,
    required this.unit,
    required this.food,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      text: json['text'],
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
      food: json['food'],
    );
  }
}