import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:level_map/level_map.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/screens/welcome_screen.dart';

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
    await userViewModel.loadUserData();
    setState(() {
      currentLevel = userViewModel.userData!.level.toDouble();
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
              final userViewModel =
                  Provider.of<UserViewModel>(context, listen: false);
              userViewModel.signOut();
            },
          ),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/quiz_screen');
                        },
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const ElevatedButton(
                            onPressed: null,
                            child: Text('Start Level'),
                          ),
                        ),
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
