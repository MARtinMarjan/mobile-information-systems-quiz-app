import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/services/auth_service.dart';

import '../services/db_service.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentLevel = 1;
  late String userId;
  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    userId = auth.getCurrentUser().uid;
    _loadCurrentLevel();
  }

  Future<void> _loadCurrentLevel() async {
    final DBService db = DBService(userId);
    final level = await db.getCurrentLevel();
    setState(() {
      currentLevel = level.toDouble();
    });
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "MKLearner",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                auth.signOut();
                Navigator.pushNamed(context, '/welcome_screen');
              }),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_comment_sharp),
              onPressed: () {
                Navigator.pushNamed(context, '/add_quiz');
              },
            ),
          ],
        ),
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
                      backgroundColor: Colors.limeAccent,
                      levelMapParams: LevelMapParams(
                        levelCount: 20,
                        currentLevel: currentLevel,
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
