import 'package:quiz_app/models/question.dart';

class Quiz {
  final String title;
  final List<Question> questions;
  final int level;

  const Quiz(this.title, this.questions, this.level);

  factory Quiz.fromMap(Map<String, dynamic> data) {
    return Quiz(
      data['title'] as String? ?? '',
      (data['questions'] as List<dynamic>? ?? []).map((questionData) {
        return Question.fromMap(questionData as Map<String, dynamic>);
      }).toList(),
      data['level'] as int? ?? 0,
    );
  }
}
