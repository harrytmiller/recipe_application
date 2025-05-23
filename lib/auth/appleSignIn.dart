// ignore_for_file: avoid_print, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> handleSignIn(BuildContext context) async {
    try {
      // Show loading indicator

      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        accessToken: result.authorizationCode,
        idToken: result.identityToken,
      );

      await _auth.signInWithCredential(credential);

      // You can now use _auth.currentUser to get the current user

      // Hide loading indicator
    } catch (error) {
      // Hide loading indicator
      // Handle errors, show error messages to the user
      print('Error during Apple Sign In: $error');
    }
  }

  Future<void> handleSignOut() async {
    try {
      // Show loading indicator

      await _auth.signOut();

      // Hide loading indicator
    } catch (error) {
      // Hide loading indicator
      // Handle errors, show error messages to the user
      print('Error during Sign Out: $error');
    }
  }
}
