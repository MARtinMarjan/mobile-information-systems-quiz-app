enum QuestionType {
  matcher,
  singleChoice,
  multipleChoice,
  trueFalse,
  fillInTheBlank,

  listenAndAnswer,
}

class Answer {
  final String answer;
  final String solution;
  int questionIndex = 0;
  final bool isCorrect;
  final QuestionType questionType;

  final String question;

  Answer({
    required this.answer,
    required this.isCorrect,
    required this.questionType,
    required this.questionIndex,
    required this.solution,
    required this.question,
  });
}
