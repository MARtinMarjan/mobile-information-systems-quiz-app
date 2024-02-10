import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/questions_summary/questions_summary.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';

class ResultsScreen extends StatelessWidget {
  List<Question> questions;

  ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
    required this.goToHome,
    required this.questions,
  });

  final void Function() onRestart;
  final void Function() goToHome;

  final AuthService auth = AuthService();

  final List<String> chosenAnswers;

  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].questionText,
          'correct_answer': questions[i].answers[0],
          'user_answer': chosenAnswers[i]
        },
      );
      print(summary[i]);
    }

    return summary;
  }

  void saveResults() {
    final user = auth.getCurrentUser();
    final db = DBService(user!.uid);

    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData
        .where(
          (data) => data['user_answer'] == data['correct_answer'],
        )
        .length;

    db.addUserQuizStats(
      1,
      numCorrectQuestions,
      numCorrectQuestions,
      numTotalQuestions - numCorrectQuestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData
        .where(
          (data) => data['user_answer'] == data['correct_answer'],
        )
        .length;

    return Column(
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
                    // color: const Color.fromARGB(255, 230, 200, 253),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                QuestionsSummary(summaryData),
                const SizedBox(
                  height: 30,
                ),
                TextButton.icon(
                  onPressed: onRestart,
                  style: TextButton.styleFrom(
                      // foregroundColor: Colors.white,
                      ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Quiz!'),
                ),
                TextButton.icon(
                  onPressed: () {
                    saveResults();
                    goToHome();
                  },
                  style: TextButton.styleFrom(
                      // foregroundColor: Colors.white,
                      ),
                  icon: const Icon(Icons.navigate_next),
                  label: const Text('Continue!'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
