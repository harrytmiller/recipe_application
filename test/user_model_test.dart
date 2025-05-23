import 'package:flutter_log/pages/profile_page/userModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Model Test: toJson()', () {
    test('toJson() method converts UserModel to JSON', () {
      // Create an instance of UserModel
      var user = const UserModel(
          firstName: "John",
          lastName: "Doe",
          username: "johndoe",
          age: "30",
          foodRestriction: "Vegetarian",
          bio: "I love cooking.");

      // Convert UserModel instance to JSON
      var json = user.toJson();

      // Expected JSON representation - now includes bio field
      var expectedJson = {
        "firstName": "John",
        "lastName": "Doe",
        "username": "johndoe",
        "age": "30",
        "foodRestriction": "Vegetarian",
        "bio": "I love cooking.",
      };

      // Compare the generated JSON with the expected JSON
      expect(json, equals(expectedJson));
    });

    test('toJson() method converts UserModel to JSON', () {
      // Create an instance of UserModel with different values
      var user = const UserModel(
          firstName: "Alice",
          lastName: "Smith",
          username: "alice123",
          age: "25",
          foodRestriction: "None",
          bio: "Food lover.");

      // Convert UserModel instance to JSON
      var json = user.toJson();

      // Expected JSON representation for the created UserModel instance - now includes bio field
      var expectedJson = {
        "firstName": "Alice",
        "lastName": "Smith",
        "username": "alice123",
        "age": "25",
        "foodRestriction": "None",
        "bio": "Food lover.",
      };

      // Compare the generated JSON with the expected JSON
      expect(json, equals(expectedJson));
    });

    test('toJson() method handles null id', () {
      // Create an instance of UserModel with null id
      var user = const UserModel(
          id: null,
          firstName: "Bob",
          lastName: "Johnson",
          username: "bob99",
          age: "40",
          foodRestriction: "Vegan",
          bio: "I am a software developer.");

      // Convert UserModel instance to JSON
      var json = user.toJson();

      // Expected JSON representation for the UserModel instance with null id - now includes bio field
      var expectedJson = {
        "firstName": "Bob",
        "lastName": "Johnson",
        "username": "bob99",
        "age": "40",
        "foodRestriction": "Vegan",
        "bio": "I am a software developer.",
      };

      // Compare the generated JSON with the expected JSON
      expect(json, equals(expectedJson));
    });

    test('toJson() method converts UserModel to JSON with null values', () {
      // Create an instance of UserModel with some values as null
      var user = const UserModel(
          id: null,
          firstName: "Jane",
          lastName: "Doe",
          username: '',
          age: "28",
          foodRestriction: '',
          bio: '');

      // Convert UserModel instance to JSON
      var json = user.toJson();

      // Expected JSON representation for the created UserModel instance with null values - now includes bio field
      var expectedJson = {
        "firstName": "Jane",
        "lastName": "Doe",
        "username": '',
        "age": "28",
        "foodRestriction": '',
        "bio": '',
      };

      // Compare the generated JSON with the expected JSON
      expect(json, equals(expectedJson));
    });
  });
}