class Question {
  final String questionText;
  final List<String> answers;
  int correctAnswerIndex;
  Question(this.questionText, this.answers, this.correctAnswerIndex);

  List<String> get shuffledAnswers {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }

  bool isAnswerCorrect(int selectedAnswerIndex) {
    return selectedAnswerIndex == correctAnswerIndex;
  }

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      data['questionText'] as String? ?? '',
      List<String>.from(data['answers'] as List<dynamic>? ?? []),
      (data['correctAnswerIndex'] as int? ?? 0),
    );
  }
}