import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

import '../models/quiz.dart';
import '../services/questions_service.dart';

class QuizViewModel extends ChangeNotifier {
  List<Question> _questions = [];

  List<Question> get questions => _questions;

  final List<String> _chosenAnswers = [];

  List<String> get chosenAnswers => _chosenAnswers;

  final int _level = 1;

  int get level => _level;
  int _currentQuestionIndex = 0;

  int get currentQuestionIndex => _currentQuestionIndex;

  String quizLevelTitle = 'Welcome to the Quiz!';

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  QuizViewModel() {
    getQuestionsByLevel(_level)
        .then((value) => {_isLoading = false, notifyListeners()});
    _isLoading = false;
  }

  final QuestionService questionService = QuestionService();

  Future<void> getQuestionsByLevel(int level) async {
    // if (isLoading) {
    //   return;
    // }
    isLoading = true;
    Quiz? quiz = await questionService.getQuizByLevel(level);
    _questions = quiz?.questions ?? [];
    quizLevelTitle = quiz?.title ?? "Welcome to the Quiz!";
    notifyListeners();
    isLoading = false;
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

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _chosenAnswers.clear();
    notifyListeners();
  }

  getChosenAnswers() {
    return _chosenAnswers;
    notifyListeners();
  }
}
