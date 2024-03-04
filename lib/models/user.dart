import 'package:cloud_firestore/cloud_firestore.dart';

class QuizUserData {
  final String uid;
  final String email;
  final String username;
  final int level;
  final int points;
  final int correctAnswers;
  final int incorrectAnswers;
  final String imageLink;
  final Timestamp lastOpenedDate;
  final String role;
  final int levelProgress;
  final int streakCount;

  QuizUserData({
    required this.uid,
    required this.email,
    required this.username,
    required this.level,
    required this.points,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.imageLink,
    required this.lastOpenedDate,
    required this.streakCount,
    required this.levelProgress,
    required this.role,
  });

  factory QuizUserData.fromMap(Map<String, dynamic> data) {
    return QuizUserData(
      uid: data['uid'] as String? ?? '',
      email: data['email'] as String? ?? '',
      username: data['username'] as String? ?? '',
      level: data['level'] as int? ?? 0,
      points: data['points'] as int? ?? 0,
      correctAnswers: data['correct_answers'] as int? ?? 0,
      incorrectAnswers: data['incorrect_answers'] as int? ?? 0,
      imageLink: data['image_link'] as String? ?? '',
      lastOpenedDate: data['last_opened_date'] as Timestamp? ?? Timestamp.now(),
      streakCount: data['streak_count'] as int? ?? 0,
      levelProgress: data['level_progress'] as int? ?? 0,
      role: data['role'] as String? ?? 'user',
    );
  }
}
