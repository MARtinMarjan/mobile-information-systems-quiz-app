import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/quiz/questions_screen.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(quizViewModel.quizLevelTitle),
          Center(
            child: ElevatedButton(
              onPressed: () {
                quizViewModel.getQuestionsByLevel(quizViewModel.level);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionsScreen(),
                  ),
                );
              },
              child: Text('Start Level ${quizViewModel.level}'),
            ),
          ),
        ],
      ),
    );
  }
}
