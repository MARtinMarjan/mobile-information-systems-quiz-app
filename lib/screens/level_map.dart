import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/screens/profile/profile_screen.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/screens/welcome_screen.dart';
import 'package:quiz_app/widgets/streak_testing.dart';
import '../viewmodels/quiz.viewmodel.dart';
import '../widgets/ui/rounded_button.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder:
          (BuildContext context, UserViewModel userViewModel, Widget? child) {
        return Consumer<QuizViewModel>(
          builder: (BuildContext context2, QuizViewModel quizViewModel,
              Widget? child2) {

            double currentLevelValue =
                (userViewModel.userData?.level.toDouble() ?? 1.5) - 0.5 <= 1
                    ? 1
                    : (userViewModel.userData?.level.toDouble() ?? 1.5) - 0.5;

            String title = quizViewModel.quizLevelTitle;

            String levelNumber =
                userViewModel.userData?.level.toString() ?? '?';

            return Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      LevelMap(
                        backgroundColor: Colors.lightGreen,
                        levelMapParams: LevelMapParams(
                          pathStrokeWidth: 3,
                          firstCurveReferencePointOffsetFactor:
                              const Offset(0.5, 0.5),
                          enableVariationBetweenCurves: false,
                          levelCount: 20,
                          currentLevel: currentLevelValue,
                          pathColor: Colors.black,
                          currentLevelImage: ImageParams(
                            path: "assets/level_map/current_level.png",
                            size: const Size(40, 40),
                          ),
                          lockedLevelImage: ImageParams(
                            path: "assets/level_map/locked_level.png",
                            size: const Size(45, 45),
                          ),
                          completedLevelImage: ImageParams(
                            path: "assets/level_map/completed_level.png",
                            size: const Size(45, 45),
                          ),
                          startLevelImage: ImageParams(
                            path: "assets/level_map/start_quiz_image.png",
                            size: const Size(100, 100),
                          ),
                          pathEndImage: ImageParams(
                            path: "assets/level_map/end_quiz_image.png",
                            size: const Size(100, 100),
                          ),
                          bgImagesToBePaintedRandomly: [
                            ImageParams(
                              path:
                                  "assets/level_map/random_images/grass.png",
                              size: const Size(30, 30),
                              repeatCountPerLevel: 0.5,
                            ),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/grass2.png",
                                size: const Size(25, 25),
                                repeatCountPerLevel: 0.3),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/lake.png",
                                size: const Size(80, 80),
                                repeatCountPerLevel: 0.05),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/tree.png",
                                size: const Size(50, 50),
                                repeatCountPerLevel: 0.3),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/church.png",
                                size: const Size(80, 80),
                                repeatCountPerLevel: 0.05,
                                imagePositionFactor: 0.4,
                                side: Side.RIGHT),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/denar.png",
                                size: const Size(40, 40),
                                repeatCountPerLevel: 0.1),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/bridge.png",
                                size: const Size(80, 80),
                                repeatCountPerLevel: 0.05,
                                imagePositionFactor: 0.4,
                                side: Side.LEFT),
                            ImageParams(
                                path:
                                    "assets/level_map/random_images/flag-on-pole.png",
                                size: const Size(80, 80),
                                repeatCountPerLevel: 0.1),
                          ],
                        ),
                      ),
                      //we add padding around the text
                      Container(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Card(
                            color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/quiz_screen');
                          },
                          child: RoundedButton(
                              colour: Colors.red,
                              title: 'Start Level $levelNumber',
                              onPressed: null),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
