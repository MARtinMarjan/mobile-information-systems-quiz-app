import 'package:flutter/material.dart';
import 'package:flutter_quiz_matcher/flutter_quiz_matcher.dart';
import 'package:flutter_quiz_matcher/models/model.dart';

import '../../models/question_matcher.dart';

class MatchQuestion extends StatefulWidget {
  const MatchQuestion({super.key, required this.questionsMatcher});

  final List<QuestionMatcher> questionsMatcher;

  @override
  State<MatchQuestion> createState() => _MatchQuestionState();
}

class _MatchQuestionState extends State<MatchQuestion> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: QuizMatcher(
              questions: [
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                  width: 100,
                  height: 100,
                  // child: Image.asset(listImagesLocations[0]),
                  child: Text(widget.questionsMatcher[0].questions[0]),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                  width: 100,
                  height: 100,
                  child: Text(widget.questionsMatcher[0].questions[1]),
                ),
              ],
              answers: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                  width: 100,
                  height: 100,
                  child: Text(widget.questionsMatcher[0].answers[0]),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                  width: 100,
                  height: 100,
                  child: Text(widget.questionsMatcher[0].answers[1]),
                ),
              ],
              defaultLineColor: Colors.black,
              correctLineColor: Colors.green,
              incorrectLineColor: Colors.red,
              drawingLineColor: Colors.black,
              onScoreUpdated: (UserScore userAnswers) {
                print(userAnswers.questionIndex);
                print(userAnswers.questionAnswer);
              },
              paddingAround: const EdgeInsets.only(top: 100),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.redAccent,
                child: Text(
                  'Match the following questions with the correct answers',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Text(
                'Match the following questions with the correct answers',
                style: TextStyle(fontSize: 20),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
