import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:quiz_app/screens/quiz/start_screen.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../models/quiz.dart';

Widget buildStartButton(BuildContext context, String levelNumber,
    [int levelProgress = 0]) {
  ValueNotifier<double> valueNotifier = ValueNotifier(0.0);
  valueNotifier.value = levelProgress.toDouble();
  return Container(
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          // Go directly to Quiz()
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => QuizStartScreen(
          //       level: int.parse(levelNumber),
          //     ),
          //   ),
          // );
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: QuizStartScreen(
              level: int.parse(levelNumber),
            ),
            withNavBar: false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100.0,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SimpleCircularProgressBar(
                  progressStrokeWidth: 15,
                  progressColors: const [Colors.yellow, Colors.amberAccent],
                  backStrokeWidth: 10,
                  mergeMode: true,
                  maxValue: 4,
                  animationDuration: 1,
                  valueNotifier: valueNotifier),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "$levelNumber ",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
}
