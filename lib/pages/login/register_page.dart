// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log/auth/appleSignIn.dart';
import 'package:flutter_log/auth/googleSignIn.dart';
import 'package:flutter_log/pages/home_page/home_page.dart';
import 'package:flutter_log/pages/login/register_login_manager.dart';
import 'package:flutter_log/pages/login/ui_components/button_forget.dart';
import 'package:flutter_log/pages/login/ui_components/login_tile.dart';
import 'package:flutter_log/pages/login/ui_components/logo_tile.dart';
import 'package:flutter_log/pages/login/ui_components/text_fields.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final RegisterLoginManager _registrationManager = RegisterLoginManager();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GoogleSignInHandler _googleSignInHandler = GoogleSignInHandler();
  final AppleSignInHandler _appleSignInHandler = AppleSignInHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const LogoTiling(imagePath: 'assets/images/logo/logo.png'),
                const SizedBox(height: 25),
                Text(
                  'Let\'s create your account!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  control: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  control: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  control: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                ButtonForget(
                  onTap: () => _registrationManager.signUserUp(
                      context,
                      emailController,
                      passwordController,
                      confirmPasswordController),
                  text: 'Sign Up',
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogTile(
                      onTap: () => _googleSignInHandler.handleSignIn(context),
                      imagePath: 'lib/fitnessImage/GoogleLogo.png',
                    ),
                    const SizedBox(width: 25),
                    LogTile(
                      onTap: () async => {
                        if (Platform.isIOS)
                          {
                            await _appleSignInHandler.handleSignIn(context),
                            if (FirebaseAuth.instance.currentUser != null)
                              {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                ),
                              }
                          }
                        else
                          {RegisterLoginManager.showOSError(context)}
                      },
                      imagePath: 'lib/fitnessImage/AppleLogo.png',
                    )
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
