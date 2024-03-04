import 'iquestion.dart';

class QuestionMatcher implements IQuestion {
  QuestionMatcher({
    required this.questions,
    required this.answers,
    required this.areQuestionsImages,
  });

  final List<String> questions;
  final List<String> answers;
  final bool areQuestionsImages;

  //get

  get getQuestions => questions;

  get getAnswers => answers;

  get getAreQuestionsImages => areQuestionsImages;

  factory QuestionMatcher.fromMap(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return QuestionMatcher(
        questions: [],
        answers: [],
        areQuestionsImages: false,
      );
    }
    return QuestionMatcher(
      questions: List<String>.from(data['questions'] as List<dynamic>? ?? []),
      answers: List<String>.from(data['answers'] as List<dynamic>? ?? []),
      areQuestionsImages: data['areQuestionsImages'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questions': questions,
      'answers': answers,
      'areQuestionsImages': areQuestionsImages,
    };
  }
}
