import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class DBService {
  final CollectionReference userCollection;

  DBService() : userCollection = FirebaseFirestore.instance.collection('users');

  Stream<DocumentSnapshot> userData(String uid) {
    return userCollection.doc(uid).snapshots();
  }

  Future<void> addUserQuizStats(String uid, int level, int points,
      int correctAnswers, int incorrectAnswers) async {
    int currentLevel = await getCurrentLevel(uid);

    try {
      await userCollection.doc(uid).set({
        'level': currentLevel + 1,
        'points': points,
        'correct_answers': correctAnswers,
        'incorrect_answers': incorrectAnswers,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error adding user quiz stats: $e");
      rethrow;
    }
  }

  Future<int> getCurrentLevel(String uid) async {
    try {
      final DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      return userDoc.get('level');
    } catch (e) {
      print("Error getting current level: $e");
      rethrow;
    }
  }

  Future<int> getCurrentPoints(String uid) async {
    try {
      final DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      return userDoc.get('points');
    } catch (e) {
      print("Error getting current points: $e");
      rethrow;
    }
  }

  Future<QuizUserData> getUserData(String uid) async {
    try {
      final DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      return QuizUserData.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print("Error getting user data: $e");
      rethrow;
    }
  }
}
