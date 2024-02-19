import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/screens/level_map.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../utils/questions_summary/questions_summary.dart';
import '../../viewmodels/user.viewmodel.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> chosenAnswers;

  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
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

  final AuthService auth = AuthService();

  List<Map<String, Object>> getSummaryData(List<Question> questions) {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < widget.chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].questionText,
          'correct_answer':
              questions[i].answers[questions[i].correctAnswerIndex],
          'user_answer': widget.chosenAnswers[i]
        },
      );
      print(summary[i]);
    }

    bool allCorrect = summary.every(
      (data) => data['user_answer'] == data['correct_answer'],
    );
    if (allCorrect) {
      _controllerBottomCenter.play();
    }

    return summary;
  }

  void saveResults(BuildContext context) {
    _saving = true;

    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final questions = quizViewModel.questions;
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = getSummaryData(questions)
        .where(
          (data) => data['user_answer'] == data['correct_answer'],
        )
        .length;

    userViewModel
        .addUserQuizStats(
          quizViewModel.level,
          numCorrectQuestions * 5,
          numCorrectQuestions,
          numTotalQuestions - numCorrectQuestions,
        )
        .then((value) => {
              quizViewModel.resetQuiz(),
              quizViewModel.getQuestionsByLevel(userViewModel.userData!.level)
            });

    userViewModel.updateStreak();
    _saving = false;
  }

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    _saving = true;
    final quizData = Provider.of<QuizViewModel>(context);
    final questions = quizData.questions;
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = getSummaryData(questions)
        .where(
          (data) => data['user_answer'] == data['correct_answer'],
        )
        .length;

    _saving = false;

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
                          Text(
                            'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          QuestionsSummary(getSummaryData(questions)),
                          const SizedBox(height: 30),
                          TextButton.icon(
                            onPressed: () {
                              quizData.resetQuiz();
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Restart Quiz!'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              saveResults(context);

                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();

                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return const HomePage();
                                  },
                                ),
                                (_) => false,
                              );

                              // Navigator.of(context).popUntil(ModalRoute.withName("/level_map"));
                            },
                            icon: const Icon(Icons.navigate_next),
                            label: const Text('Continue!'),
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
}
