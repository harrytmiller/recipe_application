// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_log/pages/profile_page/userManager.dart';
import 'package:flutter_log/pages/profile_page/userModel.dart';

class ProfileManager {
  late UserManager userManager;
  late FirebaseAuth? auth = FirebaseAuth.instance;
  late FirebaseFirestore firestore = FirebaseFirestore.instance;

  ProfileManager({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    this.auth = auth ?? FirebaseAuth.instance;
    this.firestore = firestore ?? FirebaseFirestore.instance;
    userManager = UserManager(auth: this.auth!, firestore: this.firestore);
  }

  bool checkInputLength(final String input) {
    return input.length <= 200;
  }

  Future<void> storeUserDetails(UserModel user) async {
    try {
      String? uid = await userManager.getCurrentUserUID();
      await firestore.collection("UserDetails").doc(uid).set(user.toJson());
      print('User details stored successfully');
    } catch (e) {
      print("Error storing user details: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      String? uid = await userManager.getCurrentUserUID();
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection("UserDetails").doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print("Error retrieving user details: $e");
    }
    return null;
  }

  Future<void> deleteUserDetails() async {
    try {
      String? uid = await userManager.getCurrentUserUID();

      // Reference to the user document in the "UserDetails" collection
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('UserDetails').doc(uid);

      // Set all fields to "N/A"
      Map<String, dynamic> newData = {
        'age': 'N/A',
        'username': 'N/A',
        'firstName': 'N/A',
        'lastName': 'N/A',
        'foodRestriction': 'N/A',
        'bio': 'N/A'
      };

      // Update the user document with the new values
      await userRef.set(newData);

      // Optionally, you might want to update the local user information (e.g., clear currentUser)
      // currentUser = null;
      print('Deleted info');
    } catch (e) {
      print("Error deleting user details: $e");
    }
  }
}
