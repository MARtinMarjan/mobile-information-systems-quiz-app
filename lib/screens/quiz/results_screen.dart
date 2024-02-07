

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/questions_summary/questions_summary.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';

import '../../data/questions.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
    required this.goToHome,
  });

  final void Function() onRestart;
  final void Function() goToHome;

  final List<String> chosenAnswers;

  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].text,
          'correct_answer': questions[i].answers[0],
          'user_answer': chosenAnswers[i]
        },
      );
      print(summary[i]);
    }

    return summary;
  }

  void saveResults() async {
    final userId = AuthService().getCurrentUser().uid;
    try {
      final currentLevel = await DBService().getCurrentLevel(userId);
      DBService().addUserQuizStats(
        userId,
        currentLevel,
        0,
        summaryData
            .where((data) => data['user_answer'] == data['correct_answer'])
            .length,
        summaryData.length -
            summaryData
                .where((data) => data['user_answer'] == data['correct_answer'])
                .length,
      );
    } catch (e) {
      print("Error saving results: $e");
      // Handle the error gracefully, maybe show a message to the user.
    }
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
                  onPressed: (){
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
