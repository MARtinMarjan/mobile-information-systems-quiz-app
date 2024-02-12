import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/quiz/questions_screen.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';

import '../../viewmodels/user.viewmodel.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizViewModel(),
      child: Consumer<QuizViewModel>(
        builder: (context, quizData, child) {
          return Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.watch<QuizViewModel>().quizLevelTitle),
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
                    child: Text(
                        'Start Level ${context.watch<UserViewModel>().userData?.level}'),
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
