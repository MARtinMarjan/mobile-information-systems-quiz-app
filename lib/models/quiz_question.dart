class QuizQuestion {
  const QuizQuestion(
      this.text, this.answers, this.correctAnswerIndex, this.level,
      {this.category = '', this.topic = ''});

  final String text;
  final List<String> answers;
  final int correctAnswerIndex;
  final int level;
  final String category;
  final String topic;

  List<String> get shuffledAnswers {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }

  bool isAnswerCorrect(int selectedAnswerIndex) {
    return selectedAnswerIndex == correctAnswerIndex;
  }
}
