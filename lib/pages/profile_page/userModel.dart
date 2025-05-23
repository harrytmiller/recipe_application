// ignore_for_file: file_names

class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String username;
  final String age;

  final String foodRestriction;
  final String bio;

  const UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.age,
    required this.foodRestriction,
    required this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "age": age,
      "foodRestriction": foodRestriction,
      "bio": bio,
    };
  }
}
