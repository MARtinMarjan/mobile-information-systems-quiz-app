import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

import '../services/questions_service.dart';

class QuizViewModel extends ChangeNotifier {
  List<Question> _questions = [];
  int _level = 1;
  int _currentQuestionIndex = 0;
  final List<String> _chosenAnswers = []; // Added property for chosen answers

  List<Question> get questions => _questions;

  int get level => _level;

  String quizLevelTitle =
      'Welcome to the Quiz!'; // Added property for quiz level title

  int get currentQuestionIndex => _currentQuestionIndex;

  List<String> get chosenAnswers => _chosenAnswers; // Getter for chosen answers

  QuizViewModel() {
    getQuestionsByLevel(_level);
  }

  void getQuestionsByLevel(int level) {
    final questionService = QuestionService();
    questionService.getQuizByLevel(level).then((quiz) {
      _questions = quiz?.questions ?? [];
      quizLevelTitle = quiz!.title; // Set the quiz level title
      notifyListeners();
    });
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
