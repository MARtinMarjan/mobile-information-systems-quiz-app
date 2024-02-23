import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
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
  // @override
  // Widget build(BuildContext context) {
  //   return Consumer<QuizViewModel>(
  //     builder: (context, quizData, child) {
  //       return Scaffold(
  //           body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(context.watch<QuizViewModel>().quizLevelTitle),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   quizData.resetQuiz();
  //                   PersistentNavBarNavigator.pushNewScreen(
  //                     context,
  //                     screen: const QuestionsScreen(),
  //                     withNavBar: true, // OPTIONAL VALUE. True by default.
  //                     pageTransitionAnimation: PageTransitionAnimation.sizeUp,
  //                   );
  //                 },
  //                 child: Text(
  //                     'Start Level ${context.watch<UserViewModel>().userData?.level}'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(builder: (context, quizData, child) {
      return CupertinoOnboarding(
          bottomButtonChild: Text(
              'Start Level ${context.watch<UserViewModel>().userData?.level}'),
          bottomButtonColor: CupertinoColors.systemRed.resolveFrom(context),
          onPressedOnLastPage: () => {
                quizData.resetQuiz(),
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: const QuestionsScreen(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                )
              },
          pages: [
            WhatsNewPage(
                // scrollPhysics: const BouncingScrollPhysics(),
                title: Text(context.watch<QuizViewModel>().quizLevelTitle),
                features: [
                  // Feature's type must be `WhatsNewFeature`
                  WhatsNewFeature(
                    icon: Icon(
                      CupertinoIcons.question_circle,
                      color: CupertinoColors.systemRed.resolveFrom(context),
                    ),
                    title: const Text('Read the questions and answer'),
                    description: const Text(
                      'Answer the questions and see if you got them right!',
                    ),
                  ),
                  WhatsNewFeature(
                    icon: Icon(
                      //fire
                      CupertinoIcons.sparkles,
                      color: CupertinoColors.systemRed.resolveFrom(context),
                    ),
                    title: const Text("Get them all correct!"),
                    description: const Text(
                      "If you get all the questions right, you'll get x2 points!",
                    ),
                  ),
                  // Leaderboard
                  WhatsNewFeature(
                    icon: Icon(
                      CupertinoIcons.return_icon,
                      color: CupertinoColors.systemRed.resolveFrom(context),
                    ),
                    title: const Text('Retry!'),
                    description: const Text(
                      'If you get any questions wrong, you can retry the quiz!',
                    ),
                  ),
                ])
          ]);
    });
  }
}
