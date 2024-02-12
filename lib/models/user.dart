class QuizUserData {
  final String uid;
  final String email;
  final String username;
  final int level;
  final int points;
  final int correctAnswers;
  final int incorrectAnswers;
  final String imageLink;

  QuizUserData({
    required this.uid,
    required this.email,
    required this.username,
    required this.level,
    required this.points,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.imageLink,
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
    );
  }
}
