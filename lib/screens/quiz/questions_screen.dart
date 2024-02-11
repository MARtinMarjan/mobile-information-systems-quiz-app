import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import 'package:quiz_app/ui/answer_button.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
      builder: (context, quizData, _) {
        final questions = quizData.questions;
        final currentQuestionIndex = quizData.currentQuestionIndex;

        void answerQuestion(String selectedAnswer) {
          quizData.answerQuestion(selectedAnswer);
          if (currentQuestionIndex == questions.length - 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ResultsScreen(chosenAnswers: quizData.getChosenAnswers()),
              ),
            );
          }
        }

        final currentQuestion = questions[currentQuestionIndex];

        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width,
                  lineHeight: 20.0,
                  percent: (currentQuestionIndex + 1) / questions.length,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        currentQuestion.questionText,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ...currentQuestion.shuffledAnswers.map((answer) {
                        return AnswerButton(
                          answerText: answer,
                          onTap: () {
                            answerQuestion(answer);
                          },
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
