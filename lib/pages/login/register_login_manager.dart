// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

// To Add -> Test that does not store the same email already in firebase
// To Integrate -> Integrate within the original program

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterLoginManager {
  // Sign User In
  static Future<void> signIn(
      String email, String password, BuildContext context) async {
    // Loading Circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    void showErrorMessage(String message) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Incorrect Email Address"),
            );
          });
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add User Details

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop Context
      Navigator.pop(context);
      // Wrong Username
      showErrorMessage(e.code);
    }
  }

  static void showOSError(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Android Users: Sign In with Google"),
          );
        });
  }

  Future<String> signUserUp(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) async {
    final String email = emailController.text.trim();
    final String trimmedPassword = passwordController.text.trim();
    final String trimmedConfirmPassword = confirmPasswordController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    void showErrorMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email Address or Already Signed Up"),
          );
        },
      );
    }

    try {
      if (confirmPassword(trimmedPassword, trimmedConfirmPassword)) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: trimmedPassword,
        );
      } else {
        showErrorMessage("Passwords do not match");
        return "Invalid Sign In";
      }
      Navigator.pop(context);
      return "Valid Sign In";
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
      return "Invalid Sign In";
    }
  }

  bool checkEmailValidity(final String email) {
    if (email.length >= 3 && email.length < 254 && email.contains('@')) {
      var atIndex = email.indexOf('@');
      // Split the email string by "@" and check if there are exactly two parts
      return atIndex >= 3 && email.split('@').length == 2;
    }
    return false;
  }

  bool checkNullEntry(String? stringOne, String? stringTwo) {
    // Check if both strings are not null and not empty
    return stringOne != null &&
        stringOne.isNotEmpty &&
        stringTwo != null &&
        stringTwo.isNotEmpty;
  }

  bool confirmPassword(final String passwordOne, final String passwordTwo) {
    if (samePassword(passwordOne, passwordTwo) &&
        passwordLengthCheck(passwordOne)) {
      return true;
    }
    return false;
  }

  bool samePassword(final String passwordOne, final String passwordTwo) {
    if (passwordOne == passwordTwo) {
      return true;
    }
    return false;
  }

  bool passwordLengthCheck(final String passwordOne) {
    if ((passwordOne.length >= 6 && passwordOne.length <= 200) &&
        containsSymbol(passwordOne)) {
      return true;
    }
    return false;
  }

  bool containsSymbol(String input) {
    // Converts input to unicode
    for (var char in input.runes) {
      if (!isAlphaNumeric(char) && !isWhitespace(char)) {
        return true;
      }
    }
    return false;
  }

  bool isAlphaNumeric(int charCode) {
    return (charCode >= 48 && charCode <= 57) || // 0-9
        (charCode >= 65 && charCode <= 90) || // A-Z
        (charCode >= 97 && charCode <= 122); // a-z
  }

  bool isWhitespace(int charCode) {
    return charCode == 32; // space
  }
}
