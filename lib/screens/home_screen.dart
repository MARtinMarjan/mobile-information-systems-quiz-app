import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/services/auth_service.dart';

import '../services/db_service.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? currentLevel;
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = AuthService().getCurrentUser().uid;
    _loadCurrentLevel();
  }

  Future<void> _loadCurrentLevel() async {
    final level = await DBService().getCurrentLevel(userId);
    setState(() {
      currentLevel = level.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService().signOut();
                Navigator.pushNamed(context, '/welcome_screen');
              }),
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: const Center(
                child: Text(
                  'Welcome to the Quiz App!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            // Center(
            //   child: Text(
            //     'You are logged in as ${AuthService().getCurrentUserEmail()}',
            //     style: const TextStyle(fontSize: 20),
            //   ),
            // ),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  LevelMap(
                    backgroundColor: Colors.limeAccent,
                    levelMapParams: LevelMapParams(
                      levelCount: 20,
                      currentLevel: currentLevel as double,
                      pathColor: Colors.black,
                      currentLevelImage: ImageParams(
                        path: "assets/level_map/current_black.png",
                        size: const Size(40, 47),
                      ),
                      lockedLevelImage: ImageParams(
                        path: "assets/level_map/locked_black.png",
                        size: const Size(40, 42),
                      ),
                      completedLevelImage: ImageParams(
                        path: "assets/level_map/completed_black.png",
                        size: const Size(40, 42),
                      ),
                      startLevelImage: ImageParams(
                        path: "assets/level_map/BoyStudy.png",
                        size: const Size(60, 60),
                      ),
                      pathEndImage: ImageParams(
                        path: "assets/level_map/BoyGraduation.png",
                        size: const Size(60, 60),
                      ),
                      bgImagesToBePaintedRandomly: [
                        // ImageParams(
                        //     path: "assets/level_map/EnergyEquivalency.png",
                        //     size: const Size(80, 80),
                        //     repeatCountPerLevel: 0.25),
                        ImageParams(
                            path: "assets/level_map/Astronomy.png",
                            size: const Size(80, 80),
                            repeatCountPerLevel: 0.15),
                        ImageParams(
                            path: "assets/level_map/Atom.png",
                            size: const Size(80, 80),
                            repeatCountPerLevel: 0.15),
                        ImageParams(
                            path: "assets/level_map/Certificate.png",
                            size: const Size(80, 80),
                            repeatCountPerLevel: 0.15),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/quiz_screen');
                      },
                      child: const Text('Start Level'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
