import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/quiz/questions_screen.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/start_screen.dart';

import '../../viewmodels/user.viewmodel.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late int level = 1;

  late String quizLevelTitle = 'Welcome to the Quiz!';

  @override
  void initState() {
    super.initState();
  }

  setupLevel() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    level = userViewModel.userData!.level;
    userViewModel.loadUserData().then((_) {
      quizViewModel.getQuestionsByLevel(level);
      quizLevelTitle = quizViewModel.quizLevelTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    setupLevel();
    return ChangeNotifierProvider(
      create: (context) => QuizViewModel(),
      child: Consumer<QuizViewModel>(
        builder: (context, quizData, child) {
          return Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(quizLevelTitle),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuestionsScreen(),
                        ),
                      );
                    },
                    child: Text('Start Level $level'),
                  ),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
