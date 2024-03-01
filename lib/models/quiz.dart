import 'package:quiz_app/models/question_matcher.dart';
import 'package:quiz_app/models/question_single_choice.dart';

class Quiz {
  final String title;
  final List<QuestionSingleChoice> questions;

  final List<QuestionMatcher> questionsMatcher;
  final int level;

  const Quiz(this.title, this.questions, this.level, this.questionsMatcher);

  factory Quiz.fromMap(Map<String, dynamic> data) {
    return Quiz(
      data['title'] as String? ?? '',
      (data['questions'] as List<dynamic>? ?? []).map((questionData) {
        final questionType = questionData['type'] as String;
        switch (questionType) {
          case 'single_choice':
            return QuestionSingleChoice.fromMap(questionData);
          default:
            throw UnsupportedError('Unsupported question type: $questionType');
        }
      }).toList(),
      data['level'] as int? ?? 0,
      (data['questionsMatcher'] as List<dynamic>? ?? []).map((questionData) {
        return QuestionMatcher.fromMap(questionData);
      }).toList(),
    );
  }
}
