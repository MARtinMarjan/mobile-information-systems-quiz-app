import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/models/question_single_choice.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/level_map/answer.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../utils/questions_summary/summary_item.dart';
import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/ui/answer_button.dart';

class ResultsScreen extends StatefulWidget {
  final List<Answer> chosenAnswers;

  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _controllerBottomCenter;

  var numTotalQuestions = 0;
  var numCorrectQuestions = 0;

  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    bool allCorrect = false;
    int counter = 0;
    for (var answer in widget.chosenAnswers) {
      if (answer.isCorrect) {
        counter++;
      }
    }
    if (counter == widget.chosenAnswers.length) {
      allCorrect = true;
    }
    if (allCorrect) {
      _controllerBottomCenter.play();
      pointMultiplier = 2;
    }
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  final AuthService auth = AuthService();

  int pointMultiplier = 1;

  // List<Map<String, Object>> getSummaryData(
  //     List<QuestionSingleChoice> questions) {
  //   final List<Map<String, Object>> summary = [];
  //
  //   for (var i = 0; i < widget.chosenAnswers.length; i++) {
  //     summary.add(
  //       {
  //         'question_index': i,
  //         'question': questions[i].questionText,
  //         'correct_answer':
  //             questions[i].answers[questions[i].correctAnswerIndex],
  //         'user_answer': widget.chosenAnswers[i]
  //       },
  //     );
  //     print(summary[i]);
  //   }
  //
  //   bool allCorrect = summary.every(
  //     (data) => data['user_answer'] == data['correct_answer'],
  //   );
  //
  //   if (allCorrect) {
  //     _controllerBottomCenter.play();
  //     pointMultiplier = 2;
  //   }
  //
  //   return summary;
  // }

  Widget congratulateOrTryAgain() {
    int howGood =
        widget.chosenAnswers.where((answer) => answer.isCorrect).length ==
                widget.chosenAnswers.length
            ? 1
            : widget.chosenAnswers.where((answer) => answer.isCorrect).isEmpty
                ? 0
                : 2;

    switch (howGood) {
      case 1:
        return RichText(
          text: TextSpan(
            text: 'Congratulations!\n',
            style: GoogleFonts.lato(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            children: [
              TextSpan(
                text: 'You answered ',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 500),
                  value: numCorrectQuestions,
                  textStyle: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              TextSpan(
                text: ' out of $numTotalQuestions questions correctly!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      case 0:
        return RichText(
          text: TextSpan(
            text: 'Oh no!\n',
            style: GoogleFonts.lato(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            children: [
              TextSpan(
                text: 'You answered ',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 500),
                  value: numCorrectQuestions,
                  textStyle: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              TextSpan(
                text: ' out of $numTotalQuestions questions correctly!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      default:
        return RichText(
          text: TextSpan(
            text: 'Try Again!\n',
            style: GoogleFonts.lato(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
            children: [
              TextSpan(
                text: 'You answered ',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 500),
                  value: numCorrectQuestions,
                  textStyle: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              TextSpan(
                text: ' out of $numTotalQuestions questions correctly!',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
    }
  }

  Future<void> saveResults(BuildContext context) async {
    _saving = true;

    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final numTotalQuestions = widget.chosenAnswers.length;
    final numCorrectQuestions =
        widget.chosenAnswers.where((answer) => answer.isCorrect).length;

    await userViewModel.addUserQuizStats(
      quizViewModel.level,
      (numCorrectQuestions * 5) * pointMultiplier,
      numCorrectQuestions,
      numTotalQuestions - numCorrectQuestions,
      userViewModel.userData!.levelProgress,
    );

    // await userViewModel.checkoutActivityStreak();
    await userViewModel.updateStreak();

    quizViewModel.resetQuiz();
    await quizViewModel.getQuestionsByLevel(userViewModel.userData!.level);

    _saving = false;
  }

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    numTotalQuestions = widget.chosenAnswers.length;
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        numCorrectQuestions =
            widget.chosenAnswers.where((answer) => answer.isCorrect).length;
      });
    });
    return ModalProgressHUD(
        inAsyncCall: _saving,
        child: Stack(
          children: <Widget>[
            Scaffold(
              body: Column(
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width,
                      lineHeight: 20.0,
                      percent: 1.0,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.green,
                      barRadius: const Radius.circular(16),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          congratulateOrTryAgain(),
                          // const SizedBox(height: 30),
                          // QuestionsSummary(
                          //   chosenAnswers: widget.chosenAnswers,),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView(
                              children: [
                                ...widget.chosenAnswers.map((answer) {
                                  return SummaryItem(answer);
                                }),
                              ],
                            ),
                          ),

                          // ...widget.chosenAnswers.map((answer) {
                          //   return SummaryItem(answer);
                          // }),
                          // const SizedBox(height: 60),
                          TextButton.icon(
                            onPressed: () {
                              // quizData.resetQuiz();

                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            label: const Text(
                              'Restart Quiz!',
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              saveResults(context).then((value) => {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) {
                                          return const HomePage();
                                        },
                                      ),
                                      (_) => false,
                                    ),
                                  });
                            },
                            icon: const Icon(
                              Icons.navigate_next,
                            ),
                            label: const Text(
                              'Continue!',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                  confettiController: _controllerBottomCenter,
                  blastDirectionality: BlastDirectionality.directional,
                  minBlastForce: 60,
                  maxBlastForce: 80,
                  blastDirection: -pi / 2,
                  particleDrag: 0.01,
                  // apply drag to the confetti
                  emissionFrequency: 0.02,
                  // how often it should emit
                  numberOfParticles: 20,
                  // number of particles to emit
                  gravity: 0.2,
                  // gravity - or fall speed
                  shouldLoop: false,
                  colors: const [
                    Colors.red,
                    Colors.yellowAccent,
                    Colors.pink,
                    Colors.yellow,
                    Colors.green
                  ],
                  // manually specify the colors to be used
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                  createParticlePath: drawStar),
            ),
          ],
        ));
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
