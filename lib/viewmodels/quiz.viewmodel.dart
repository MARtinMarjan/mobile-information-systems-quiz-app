import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_single_choice.dart';
import 'package:quiz_app/screens/level_map/answer.dart';

import '../models/question_matcher.dart';
import '../models/quiz.dart';
import '../services/questions_service.dart';

class QuizViewModel extends ChangeNotifier {
  List<QuestionSingleChoice> _questions = [];

  List<QuestionSingleChoice> get questions => _questions;

  // getShuffledQuestions() {
  //   _questions.shuffle();
  //   return _questions;
  // }

  List<QuestionMatcher> _questionsMatcher = [];

  List<QuestionMatcher> get questionsMatcher => _questionsMatcher;

  final List<Answer> _chosenAnswers = [];

  List<Answer> get chosenAnswers => _chosenAnswers;

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
    isLoading = true;
    Quiz quiz = await questionService.getQuizByLevel(level) ??
        const Quiz(
          "Welcome to the Quiz!",
          [],
          1,
          [],
        );
    await getQuestionsFromQuiz(quiz);
    notifyListeners();
    isLoading = false;
  }

  Future<void> getQuestionsFromQuiz(Quiz quiz) async {
    isLoading = true;

    _questions = quiz.questions;
    _questionsMatcher = quiz.questionsMatcher;
    quizLevelTitle = quiz.title;

    // print("getQuestionsFromQuiz($_questions)...");
    // print("getQuestionsFromQuiz($_questionsMatcher)...");
    notifyListeners();
    isLoading = false;
  }

  void answerQuestion(String selectedAnswer, int questionIndex,
      QuestionType type, bool isCorrect, String solution, String question) {
    Answer answer = Answer(
      questionIndex: questionIndex,
      answer: selectedAnswer,
      questionType: type,
      isCorrect: isCorrect,
      solution: solution,
      question: question,
    );
    _chosenAnswers.add(answer);
    notifyListeners();
  }

  void goToNextQuestion() {
    if (_currentQuestionIndex ==
        _questions.length + _questionsMatcher.length - 1) {
      notifyListeners();
    } else {
      _currentQuestionIndex++;
      notifyListeners();
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
