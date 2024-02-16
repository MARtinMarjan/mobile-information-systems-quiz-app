import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import '../../widgets/ui/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Timer _timer;
  bool _isQuizPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const pauseDuration = Duration(seconds: 10); // Adjust as needed
    _timer = Timer(pauseDuration, () {
      setState(() {
        _isQuizPaused = true;
      });
    });
  }

  void _resumeQuiz() {
    // Cancel the timer and resume the quiz
    _timer.cancel();
    setState(() {
      _isQuizPaused = false;
    });
    _startTimer(); // Restart the timer
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resumeQuiz, // Resume the quiz on any tap
      onPanDown: (_) => _resumeQuiz, // Resume the quiz on pan down
      child: Consumer<QuizViewModel>(
        builder: (context, quizData, _) {
          final questions = quizData.questions;
          final currentQuestionIndex = quizData.currentQuestionIndex;

          void answerQuestion(String selectedAnswer) {
            _timer.cancel(); // Cancel the timer when answering a question
            quizData.answerQuestion(selectedAnswer);
            if (currentQuestionIndex == questions.length - 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(
                    chosenAnswers: quizData.getChosenAnswers(),
                  ),
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
                    percent: (currentQuestionIndex) / questions.length,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.green,
                    barRadius: const Radius.circular(16),
                  ),
                ),
                if (!_isQuizPaused)
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
                            style: const TextStyle(
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
                  )
                else
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Quiz Paused',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tap anywhere to unpause',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
