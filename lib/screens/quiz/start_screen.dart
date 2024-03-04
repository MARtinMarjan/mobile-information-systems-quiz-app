import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question_single_choice.dart';
import 'package:quiz_app/screens/quiz/questions_screen.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';

import '../../models/iquestion.dart';
import '../../viewmodels/user.viewmodel.dart';

class QuizStartScreen extends StatefulWidget {
  final int level;

  bool runOnce;

  QuizStartScreen({super.key, required this.level, this.runOnce = false});

  @override
  State<QuizStartScreen> createState() => _QuizStartScreenState();
}

class _QuizStartScreenState extends State<QuizStartScreen> {
  bool isLoaded = false;
  late List<IQuestion> allQuestions;

  @override
  initState() {
    super.initState();
    _initiateData();
  }

  Future<void> _initiateData() async {
    setState(() {
      isLoaded = true;
    });
    QuizViewModel quizData = context.read<QuizViewModel>();
    readData(quizData).then((value) {
      setState(() {
        allQuestions = value;
        isLoaded = false;
      });
    });
  }

  Future<List<IQuestion>> readData(QuizViewModel quizData) async {
    await context.read<QuizViewModel>().getQuestionsByLevel(widget.level);

    List<IQuestion> allQuestions = [];

    List<QuestionSingleChoice> questions = quizData.questions;

    if (questions.isNotEmpty) {
      questions.shuffle();
    }

    // final List<QuestionSingleChoice> questions = quizData.questions;
    final questionsMatcher = quizData.questionsMatcher;

    if (widget.runOnce == false) {
      for (var i = 0; i < questions.length; i++) {
        var correctNumberIndex = questions[i].correctAnswerIndex;
        var correctAnswer = questions[i].answers[correctNumberIndex];
        questions[i].answers.shuffle();
        questions[i].correctAnswerIndex =
            questions[i].answers.indexOf(correctAnswer);
      }
      widget.runOnce = true;
    }

    for (var i = 0; i < questions.length; i++) {
      allQuestions.add(questions[i]);
      if (i < questionsMatcher.length) {
        allQuestions.add(questionsMatcher[i]);
      }
    }

    allQuestions = allQuestions.reversed.toList();

    return allQuestions;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(builder: (context, quizData, child) {
      return CupertinoOnboarding(
          bottomButtonBorderRadius: BorderRadius.lerp(
            BorderRadius.circular(10),
            BorderRadius.circular(20),
            10,
          ),
          bottomButtonChild: isLoaded
              ? const CupertinoActivityIndicator(color: Colors.white,)
              : Text(
                  'Start Level ${context.watch<UserViewModel>().userData?.level}'),
          bottomButtonColor: CupertinoColors.systemRed.resolveFrom(context),
          onPressedOnLastPage: () => {
                quizData.resetQuiz(),
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: QuestionsScreen(allQuestions: allQuestions),
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
