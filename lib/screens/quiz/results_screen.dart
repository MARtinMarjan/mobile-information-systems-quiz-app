import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../utils/questions_summary/questions_summary.dart';
import '../../viewmodels/user.viewmodel.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> chosenAnswers;

  ResultsScreen({
    super.key,
    required this.chosenAnswers,
  });

  final AuthService auth = AuthService();

  List<Map<String, Object>> getSummaryData(List<Question> questions) {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].questionText,
          'correct_answer':
              questions[i].answers[questions[i].correctAnswerIndex],
          'user_answer': chosenAnswers[i]
        },
      );
      print(summary[i]);
    }

    return summary;
  }

  void saveResults(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final questions = quizViewModel.questions;
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = getSummaryData(questions)
        .where(
          (data) => data['user_answer'] == data['correct_answer'],
        )
        .length;

    userViewModel.addUserQuizStats(
      quizViewModel.level,
      numCorrectQuestions * 5,
      numCorrectQuestions,
      numTotalQuestions - numCorrectQuestions,
    );

    quizViewModel.resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final quizData = Provider.of<QuizViewModel>(context);
    final questions = quizData.questions;
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = getSummaryData(questions)
        .where(
          (data) => data['user_answer'] == data['correct_answer'],
        )
        .length;

    return Scaffold(
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
                      // navigate back to home screen
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
    );
  }
}
