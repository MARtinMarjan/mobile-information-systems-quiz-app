import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/screens/level_map/start_button.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import '../../viewmodels/quiz.viewmodel.dart';
import 'level_title_bar.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  late UserViewModel _userViewModel;
  late QuizViewModel _quizViewModel;

  Future<void> _loadCurrentLevel() async {
    if (mounted) {
      await _userViewModel.checkoutActivityStreak();
      await _userViewModel.loadUserData().then((value) {
        _quizViewModel.getQuestionsByLevel(_userViewModel.userData?.level ?? 1);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
  }

  double levelValue = 1.0;
  String title = "???";
  int streak = 0;
  String level = "?";
  DateTime lastOpenedDate = DateTime.now();

  int levelProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<void>(
            future: _loadCurrentLevel(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return Consumer2<UserViewModel, QuizViewModel>(
                  builder: (context, userViewModel, quizViewModel, child) {
                if (mounted) {
                  levelValue = getLevelValue(_userViewModel);
                  title = _quizViewModel.quizLevelTitle;
                  streak = _userViewModel.userData?.streakCount ?? 0;
                  level = _userViewModel.userData?.level.toString() ?? '?';
                  lastOpenedDate =
                      _userViewModel.userData?.lastOpenedDate.toDate() ??
                          DateTime.now();
                  levelProgress = _userViewModel.userData?.levelProgress ?? 0;

                  if (context.watch<UserViewModel>().isLoading ||
                      context.watch<QuizViewModel>().isLoading) {
                    return Container(
                      color: Colors.lightGreen,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                    return context.watch<UserViewModel>().isLoading
                        ? Container(
                            color: Colors.lightGreen,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              _buildLevelMap(levelValue),
                              buildTitleCard(
                                context,
                                title,
                                streak,
                                lastOpenedDate,
                              ),
                              buildStartButton(
                                context,
                                level,
                                levelProgress,
                              ),
                            ],
                          );
                  }
                } else {
                  return Container(
                    color: Colors.lightGreen,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              });
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
    scrollToCurrentLevel: true,
    levelMapParams: LevelMapParams(
      // LevelMapParams configurations...
      pathStrokeWidth: 3,
      firstCurveReferencePointOffsetFactor: const Offset(0.5, 0.5),
      enableVariationBetweenCurves: false,
      levelCount: 50,
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
