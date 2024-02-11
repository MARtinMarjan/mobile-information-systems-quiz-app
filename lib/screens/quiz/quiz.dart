import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/start_screen.dart';

import '../../viewmodels/user.viewmodel.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late var level;

  @override
  void initState() {
    super.initState();
  }

  setupLevel() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    level = userViewModel.userData!.level;
    userViewModel.loadUserData().then((_) {
      final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      quizViewModel.getQuestionsByLevel(level);
    });
  }

  @override
  Widget build(BuildContext context) {
    setupLevel();
    return ChangeNotifierProvider(
      create: (context) => QuizViewModel(),
      child: Consumer<QuizViewModel>(
        builder: (context, quizData, child) {
          return const Scaffold(
            body: StartScreen(),
          );
        },
      ),
    );
  }
}
