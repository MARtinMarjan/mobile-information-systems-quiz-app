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
import 'level_map.dart';

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
  late UserViewModel _userViewModel;
  late QuizViewModel _quizViewModel;

  @override
  void initState() {
    super.initState();
    _saving = true;
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    _userViewModel.checkoutActivityStreak();
    _loadCurrentLevel();
  }

  Future<double> _loadCurrentLevel() async {
    _saving = true;
    await _userViewModel.loadUserData().then((value) => {
          _quizViewModel.getQuestionsByLevel(_userViewModel.userData!.level),
        });
    var level = _userViewModel.userData!.level.toDouble();
    _saving = false;
    return level;
  }

  int currentPageIndex = 0;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        body: <Widget>[
          const LevelMapScreen(),
          const StreakApp(),
          const ProfileScreen(),
        ][currentPageIndex],
        bottomNavigationBar: Consumer<UserViewModel>(
          builder: (BuildContext context, UserViewModel userViewModel,
              Widget? child) {
            return NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              indicatorColor: Colors.amber,
              selectedIndex: currentPageIndex,
              destinations: <Widget>[
                const NavigationDestination(
                  selectedIcon: Icon(Icons.map_rounded),
                  icon: Icon(Icons.map_rounded),
                  label: 'Level Map',
                ),
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Badge(child: Icon(Icons.whatshot_rounded)),
                        ),
                        TextSpan(
                          text: 'Streak ${userViewModel.streakCount}',
                          style: const TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
