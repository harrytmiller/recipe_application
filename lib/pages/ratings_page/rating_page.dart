import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Rating Page'),
      ),
      backgroundColor: Colors.green[200],
      body: const Center(
        child: Text(
          'This is a basic Ratings page.',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
