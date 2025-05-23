// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_log/pages/home_page/food_notifications/notifications.dart';
import 'package:flutter_log/pages/home_page/components/video_player.dart';
import 'package:flutter_log/pages/home_page/components/appdraw.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  NotificationManager notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();

    // Call the function to notify expired ingredients when the page is loaded
    _notifyExpiredIngredients();
    _NotifyInefficiency();
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _notifyExpiredIngredients() async {
    // Call the function to remove expired ingredients and get the details
    List<Map<String, String>> removedIngredients =
        await notificationManager.removeExpiredIngredientsAndNotify();

    if (removedIngredients.isNotEmpty) {
      // Display a pop-up with the names and expiry dates of removed expired ingredients
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Expired Ingredients Removed'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: removedIngredients
                    .map(
                      (ingredientDetails) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${ingredientDetails['name']} - Expiry Date: ${ingredientDetails['expiryDate']}',
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _NotifyInefficiency() async {
    // Call the function to obtain generation efficiency
    int efficiencyVal = await notificationManager.warnEfficiency();

    if (efficiencyVal < 90) {
      // Display a pop-up with the names and expiry dates of removed expired ingredients
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('System Inefficiency Warning'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The system efficiency is below optimal levels. Algorithm Efficiency: $efficiencyVal%',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10), // Add some spacing
                  Text(
                    'Please take necessary caution to when dealing with food restriction.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('', style: TextStyle(fontSize: 30)),
          backgroundColor: Colors.green[700],
          toolbarHeight: MediaQuery.of(context).size.height * 0.06,
          shape: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
        ),
        drawer: AppDrawer(_signOut),
        backgroundColor: Colors.green[200],
        body: Center(
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.11,
            ),
            Image(
              width: 310,
              image: AssetImage(
                'assets/images/logo/logo.png',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                "Welcome to WasteAway",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.white,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    'To get started click on the icon on the top left or watch the introductory video below'),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPlayerWidget()));
                  },
                  child: Text('Watch Introductory Video'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
