import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz/questions_screen.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import 'package:quiz_app/screens/quiz/start_screen.dart';

import '../../data/questions.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
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
    Navigator.of(context).pushReplacementNamed('/home_screen');
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(_switchScreen);

    if (_activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: _chooseAnswer,
      );
    }

    if (_activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: _selectedAnswers,
        onRestart: restartQuiz,
        goToHome: goToHome,
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
}
