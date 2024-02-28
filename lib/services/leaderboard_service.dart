import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/user.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizUserData>> getLeaderboard() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('points', descending: true)
          .limit(10)
          .get();

      List<QuizUserData> leaderboard = querySnapshot.docs.map((doc) {
        return QuizUserData(
          uid: doc['uid'],
          email: doc['email'],
          username: doc['username'],
          level: doc['level'],
          points: doc['points'],
          correctAnswers: doc['correct_answers'],
          incorrectAnswers: doc['incorrect_answers'],
          imageLink: doc['image_link'],
          lastOpenedDate: doc['last_opened_date'],
          streakCount: doc['streak_count'],
          levelProgress: doc['level_progress'],
        );
      }).toList();

      return leaderboard;
    } catch (error) {
      // Handle errors
      print('Error getting leaderboard: $error');
      return [];
    }
  }
}
