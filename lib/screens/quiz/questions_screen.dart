import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz_app/models/question.dart';

import '../../ui/answer_button.dart';


class QuestionsScreen extends StatefulWidget {
  List<Question> questions;

  QuestionsScreen({
    super.key,
    required this.onSelectAnswer, required this.questions,
  });

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex++; // increments the value by 1
    });
  }

  @override
  Widget build(context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width,
            lineHeight: 20.0,
            percent: (currentQuestionIndex) /  widget.questions.length,
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
    );
  }
}
