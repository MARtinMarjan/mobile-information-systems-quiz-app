enum QuestionType {
  matcher,
  singleChoice,
  multipleChoice,
  trueFalse,
  fillInTheBlank
}

class Answer {
  final String answer;
  final String solution;
  int questionIndex = 0;
  final bool isCorrect;
  final QuestionType questionType;

  Answer({
    required this.answer,
    required this.isCorrect,
    required this.questionType,
    required this.questionIndex,
    required this.solution,
  });
}
