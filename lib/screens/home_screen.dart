import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/screens/profile/profile_screen.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/screens/welcome_screen.dart';

import '../ui/rounded_button.dart';
import '../viewmodels/quiz.viewmodel.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, _) {
        return userViewModel.user != null
            ? _AuthenticatedHomePage()
            : const WelcomePage();
      },
    );
  }
}

class _AuthenticatedHomePage extends StatefulWidget {
  @override
  State<_AuthenticatedHomePage> createState() => _AuthenticatedHomePageState();
}

class _AuthenticatedHomePageState extends State<_AuthenticatedHomePage> {
  double currentLevel = 1;
  late String userId;

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userId = userViewModel.user!.uid;
    _loadCurrentLevel();
  }

  Future<void> _loadCurrentLevel() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    await userViewModel.loadUserData();
    quizViewModel.getQuestionsByLevel(userViewModel.userData!.level);
    setState(() {
      currentLevel = userViewModel.userData!.level.toDouble();
    });
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.red,
        //   title: const Text(
        //     "MKLearner",
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   leading: IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       final userViewModel =
        //           Provider.of<UserViewModel>(context, listen: false);
        //       userViewModel.signOut();
        //     },
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.add_comment_sharp),
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/add_quiz');
        //       },
        //     ),
        //   ],
        // ),
        body: <Widget>[
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
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
                        currentLevel: context
                                    .watch<UserViewModel>()
                                    .userData!
                                    .level
                                    .toDouble() +
                                0.5 ??
                            1,
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
                          path: "assets/level_map/start_level_image.png",
                          size: const Size(100, 100),
                        ),
                        pathEndImage: ImageParams(
                          path: "assets/level_map/BoyGraduation.png",
                          size: const Size(60, 60),
                        ),
                        bgImagesToBePaintedRandomly: [
                          ImageParams(
                              path: "assets/level_map/random_images/grass.png",
                              size: const Size(30, 30),
                              repeatCountPerLevel: 0.5),
                          ImageParams(
                              path: "assets/level_map/random_images/grass2.png",
                              size: const Size(30, 30),
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
                              repeatCountPerLevel: 0.1),
                          ImageParams(
                              path: "assets/level_map/random_images/denar.png",
                              size: const Size(40, 40),
                              repeatCountPerLevel: 0.1),
                          ImageParams(
                              path: "assets/level_map/random_images/bridge.png",
                              size: const Size(80, 80),
                              repeatCountPerLevel: 0.05),
                          ImageParams(
                              path:
                                  "assets/level_map/random_images/flag-on-pole.png",
                              size: const Size(80, 80),
                              repeatCountPerLevel: 0.1),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          _loadCurrentLevel();
                          Navigator.pushNamed(context, '/quiz_screen');
                        },
                        child: RoundedButton(
                            colour: Colors.red,
                            title:
                                'Start Level ${context.watch<UserViewModel>().userData!.level.toString()}',
                            onPressed: null),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Center(
            child: Text('Notifications'),
          ),
          const ProfileScreen(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.notifications_sharp)),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
