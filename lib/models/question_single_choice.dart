import 'iquestion.dart';

class QuestionSingleChoice implements IQuestion {
  final String questionText;

  final List<String> answers;
  int correctAnswerIndex;

  final String questionType;

  QuestionSingleChoice(this.questionText, this.answers, this.correctAnswerIndex,
      [this.questionType = 'single_choice']);

  List<String> get shuffledAnswers {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }

  bool isAnswerCorrect(int selectedAnswerIndex) {
    return selectedAnswerIndex == correctAnswerIndex;
  }

  factory QuestionSingleChoice.fromMap(
      Map<String, dynamic> data, String questionType) {
    return QuestionSingleChoice(
      data['questionText'] as String? ?? '',
      List<String>.from(data['answers'] as List<dynamic>? ?? []),
      (data['correctAnswerIndex'] as int? ?? 0),
      questionType = questionType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'answers': answers,
      'correctAnswerIndex': correctAnswerIndex,
      'questionType': questionType,
    };
  }
}
