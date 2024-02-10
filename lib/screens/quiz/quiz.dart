import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz/questions_screen.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import 'package:quiz_app/screens/quiz/start_screen.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';

import '../../models/question.dart';
import '../../services/questions_service.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  late List<Question> questions = [];

  int _level = 1;

  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();

    final db = DBService(auth.getCurrentUser()!.uid);
    db.getCurrentLevel().then((level) {
      setState(() {
        _level = level;
      });
      getQuestions(level);
    });
  }

  final List<String> _selectedAnswers = [];
  var _activeScreen = 'start-screen';

  void _switchScreen() {
    setState(() {
      _activeScreen = 'questions-screen';
    });
  }

  void _chooseAnswer(String answer) {
    _selectedAnswers.add(answer);

    if (_selectedAnswers.length == questions.length) {
      setState(() {
        _activeScreen = 'results-screen';
      });
    }
  }

  void restartQuiz() {
    setState(() {
      _activeScreen = 'questions-screen';
      _selectedAnswers.clear();
    });
  }

  void goToHome() {
    _level++;
    Navigator.of(context).pushReplacementNamed('/home_screen');
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(_switchScreen, questions);

    if (_activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: _chooseAnswer,
        questions: questions,
      );
    }

    if (_activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: _selectedAnswers,
        onRestart: restartQuiz,
        goToHome: goToHome,
        questions: questions,
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: screenWidget,
        ),
      ),
    );
  }

  void getQuestions(int level) {
    final questionService = QuestionService();
    questionService.getQuizByLevel(level).then((quiz) {
      setState(() {
        questions = quiz?.questions ?? [];
      });
    });
  }
}
