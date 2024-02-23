import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import '../viewmodels/quiz.viewmodel.dart';
import '../widgets/ui/rounded_button.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  late UserViewModel _userViewModel;
  late QuizViewModel _quizViewModel;

  @override
  void initState() {
    super.initState();
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    _userViewModel.checkoutActivityStreak();
    _loadCurrentLevel();
  }

  Future<double> _loadCurrentLevel() async {
    await _userViewModel.loadUserData().then((value) {
      _quizViewModel.getQuestionsByLevel(_userViewModel.userData!.level);
    });
    var level = _userViewModel.userData!.level.toDouble();
    return level;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<void>(
            future: _loadCurrentLevel(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.lightGreen,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _buildLevelMap(getLevelValue(_userViewModel)),
                    _buildTitleCard(_quizViewModel.quizLevelTitle),
                    _buildStartButton(
                      context,
                      _userViewModel.userData?.level.toString() ?? '?',
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

double getLevelValue(UserViewModel userViewModel) {
  return (userViewModel.userData?.level.toDouble() ?? 1.5) - 0.5 <= 1
      ? 1
      : (userViewModel.userData?.level.toDouble() ?? 1.5) - 0.5;
}

Widget _buildLevelMap(double currentLevelValue) {
  return LevelMap(
    backgroundColor: Colors.lightGreen,
    levelMapParams: LevelMapParams(
      // LevelMapParams configurations...
      pathStrokeWidth: 3,
      firstCurveReferencePointOffsetFactor: const Offset(0.5, 0.5),
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
          path: "assets/level_map/random_images/grass.png",
          size: const Size(30, 30),
          repeatCountPerLevel: 0.5,
        ),
        ImageParams(
            path: "assets/level_map/random_images/grass2.png",
            size: const Size(25, 25),
            repeatCountPerLevel: 0.3),
        ImageParams(
            path: "assets/level_map/random_images/lake.png",
            size: const Size(80, 80),
            repeatCountPerLevel: 0.05),
        ImageParams(
            path: "assets/level_map/random_images/tree.png",
            size: const Size(50, 50),
            repeatCountPerLevel: 0.3),
        ImageParams(
            path: "assets/level_map/random_images/church.png",
            size: const Size(80, 80),
            repeatCountPerLevel: 0.05,
            imagePositionFactor: 0.4,
            side: Side.RIGHT),
        ImageParams(
            path: "assets/level_map/random_images/denar.png",
            size: const Size(40, 40),
            repeatCountPerLevel: 0.1),
        ImageParams(
            path: "assets/level_map/random_images/bridge.png",
            size: const Size(80, 80),
            repeatCountPerLevel: 0.05,
            imagePositionFactor: 0.4,
            side: Side.LEFT),
        ImageParams(
            path: "assets/level_map/random_images/flag-on-pole.png",
            size: const Size(80, 80),
            repeatCountPerLevel: 0.1),
      ],
    ),
  );
}

Widget _buildTitleCard(String title) {
  return Container(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Card(
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
  );
}

Widget _buildStartButton(BuildContext context, String levelNumber) {
  return Container(
    alignment: Alignment.bottomCenter,
    margin: const EdgeInsets.only(bottom: 20),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed("/quiz_screen");
        // Navigator.pushNamed(context, '/quiz_screen');
        //Undefined name 'context'.
      },
      child: RoundedButton(
        colour: Colors.red,
        title: 'Start Level $levelNumber',
        onPressed: null,
      ),
    ),
  );
}
