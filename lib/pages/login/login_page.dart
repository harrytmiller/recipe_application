// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log/auth/appleSignIn.dart';
import 'package:flutter_log/auth/googleSignIn.dart';
import 'package:flutter_log/pages/login/auth_page.dart';
import 'package:flutter_log/pages/login/register_login_manager.dart';
import 'package:flutter_log/pages/login/ui_components/button_forget.dart';
import 'package:flutter_log/pages/login/ui_components/login_tile.dart';
import 'package:flutter_log/pages/login/ui_components/logo_tile.dart';
import 'package:flutter_log/pages/login/ui_components/text_fields.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// DO NOT TOUCH THIS CODE
class _LoginPageState extends State<LoginPage> {
  // Text Editing Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Apple and Google Sign In
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
              mainAxisAlignment:
                  MainAxisAlignment.center, //Aligned for iOS phones
              children: [
                const SizedBox(height: 50),
                // Logo Textfield
                const LogoTiling(imagePath: 'assets/images/logo/logo.png'),

                const SizedBox(height: 50),

                Text(
                  'Welcome Back! You\'ve been missed',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Username TextField
                MyTextField(
                  control: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password TextField
                MyTextField(
                  control: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Forgot Password

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // Sign In Button
                ButtonForget(
                  onTap: () {
                    RegisterLoginManager.signIn(
                        emailController.text, passwordController.text, context);
                  },
                  text: 'Sign In',
                ),

                const SizedBox(height: 50),

                //Google + Apple Sign In Prompt
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
                // Google + Apple sign in buttons

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    LogTile(
                        onTap: () => _googleSignInHandler.handleSignIn(context),
                        imagePath: 'lib/fitnessImage/GoogleLogo.png'),

                    const SizedBox(width: 25),

                    //Apple Button
                    LogTile(
                        onTap: () async => {
                              if (Platform.isIOS)
                                {
                                  await _appleSignInHandler
                                      .handleSignIn(context),
                                  if (FirebaseAuth.instance.currentUser != null)
                                    {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AuthPage(),
                                        ),
                                      )
                                    }
                                }
                              else
                                {RegisterLoginManager.showOSError(context)}
                            },
                        imagePath: 'lib/fitnessImage/AppleLogo.png')
                  ],
                ),

                const SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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
