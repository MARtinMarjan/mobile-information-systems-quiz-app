import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

import '../models/quiz.dart';
import '../services/questions_service.dart';

class QuizViewModel extends ChangeNotifier {
  List<Question> _questions = [];
  int _level = 1;
  int _currentQuestionIndex = 0;
  final List<String> _chosenAnswers = [];

  List<Question> get questions => _questions;

  int get level => _level;

  String quizLevelTitle = 'Welcome to the Quiz!';

  int get currentQuestionIndex => _currentQuestionIndex;

  List<String> get chosenAnswers => _chosenAnswers;

  QuizViewModel() {
    getQuestionsByLevel(_level);
  }

  final QuestionService questionService = QuestionService();

  Future<void> getQuestionsByLevel(int level) async {
    Quiz? quiz = await questionService.getQuizByLevel(level);
    _questions = quiz?.questions ?? [];
    quizLevelTitle = quiz?.title ?? "Welcome to the Quiz!";
    notifyListeners();
  }

  void answerQuestion(String selectedAnswer) {
    _chosenAnswers
        .add(selectedAnswer); // Add the selected answer to chosenAnswers
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      // Handle end of quiz
    }
    notifyListeners();
  }

  void updateLevel(int newLevel) {
    _level = newLevel;
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _chosenAnswers.clear();
    notifyListeners();
  }

  getChosenAnswers() {
    return _chosenAnswers;
  }

  getTitle() {
    return quizLevelTitle;
  }
}
