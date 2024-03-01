import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/utils/questions_summary/questions_identifier.dart';

import '../../screens/level_map/answer.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem(this.itemData, {super.key});

  final Answer itemData;

  @override
  Widget build(BuildContext context) {
    return itemData.questionType == QuestionType.singleChoice
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionIdentifier(
                  isCorrectAnswer: itemData.isCorrect,
                  questionIndex: itemData.questionIndex,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(itemData.answer,
                          style: TextStyle(
                            color:
                                itemData.isCorrect ? Colors.green : Colors.red,
                          )),
                      Text(itemData.solution,
                          style: const TextStyle(
                            color: Colors.green,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionIdentifier(
                  isCorrectAnswer: itemData.isCorrect,
                  questionIndex: itemData.questionIndex,
                ),
                const SizedBox(width: 20),
                // JUST SAY CORRECTLY ANSWERED WITH A GREEN CHECK OR RED
                RichText(
                  text: TextSpan(
                    text: itemData.isCorrect
                        ? "Correctly answered"
                        : "Incorrectly answered",
                    style: GoogleFonts.nunito(
                      color: itemData.isCorrect ? Colors.green : Colors.red,
                      fontSize: 22,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
