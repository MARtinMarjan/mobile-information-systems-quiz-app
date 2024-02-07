import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/quiz_question.dart';

class DBService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserQuizStats(String userId, int level, int points,
      int correctAnswers, int incorrectAnswers) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'level': level + 1,
        'points': points,
        'correct_answers': correctAnswers,
        'incorrect_answers': incorrectAnswers,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error adding user quiz stats: $e");
      rethrow;
    }
  }

  // get current level
  Future<int> getCurrentLevel(String userId) async {
    try {
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();
      return userDoc.get('level');
    } catch (e) {
      print("Error getting current level: $e");
      throw e;
    }
  }
}
