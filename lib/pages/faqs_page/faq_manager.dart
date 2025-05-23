import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference question =
  FirebaseFirestore.instance.collection('question');

  // Add question to Firestore
  Future<void> addQuestion(BuildContext context, String note) async {
    // Validate note length
    if (note.length > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FAQ note exceeds 200 characters.'),
          duration: Duration(seconds: 3),
        ),
      );
      throw Exception('FAQ note exceeds 200 characters.');
    }

    // Validate note format
    if (note.runtimeType != String) {
      throw Exception('FAQ note must be of string format.');
    }

    // Add the question to Firestore
    try {
      await question.add({
        'note': note,
        'timestamp': Timestamp.now(),
        'answer': '',
        'TruthVal': false,
      });
    } catch (e) {
      throw Exception('Failed to add FAQ question: $e');
    }
  }

  // Get stream of questions
  Stream<QuerySnapshot> getQuestionStream() {
    // Query documents where 'TruthVal' is true
    final questionStream =
    question.where('TruthVal', isEqualTo: true).snapshots();
    return questionStream;
  }

  // Update question
  Future<void> updateNote(String docId, String newQuestion, String newAnswer) {
    return question.doc(docId).update({
      'note': newQuestion,
      'answer': newAnswer,
    });
  }
}
