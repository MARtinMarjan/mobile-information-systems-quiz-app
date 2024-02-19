import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
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
                    quizData.resetQuiz();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const QuestionsScreen(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
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
    );
  }
}
