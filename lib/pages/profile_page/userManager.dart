// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  UserManager({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth,
        _firestore = firestore;

  Future<String> getCurrentUserUID() async {
    try {
      User? user = _auth?.currentUser;

      if (user != null) {
        return user.uid;
      } else {
        return ''; // You may want to handle the case when there is no user
      }
    } catch (e) {
      print('Error: $e');
      return ''; // Handle errors by returning an empty string or another default value
    }
  }

  Future<String?> getFoodRestriction() async {
    try {
      String? uid = await getCurrentUserUID();
      DocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
          await _firestore?.collection("UserDetails").doc(uid).get();

      if (documentSnapshot!.exists) {
        dynamic foodRestriction = documentSnapshot.data()?["foodRestriction"];
        print("Food Restriction: $foodRestriction");
        return foodRestriction;
      } else {
        print("Food Restriction: Issues Occurred");
        return null;
      }
    } catch (e) {
      print("Issue obtaining food restriction: $e");
      return null;
    }
  }
}
