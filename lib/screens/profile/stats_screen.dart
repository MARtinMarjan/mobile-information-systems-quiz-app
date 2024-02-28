import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/profile_menu_widget.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  QuizUserData? userData = QuizUserData(
    uid: '',
    email: '',
    username: '',
    level: 0,
    points: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
    imageLink: '',
    lastOpenedDate: Timestamp.now(),
    streakCount: 0,
    levelProgress: 0,
  );

  @override
  void initState() {
    super.initState();
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    userViewModel.loadUserData();
    userData = userViewModel.userData;
  }

  String tapIndex = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) {
              return route.settings.name == "/profile_screen";
            });
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Statistics",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: userData != null
          ? Column(
              children: [
                (userData!.correctAnswers + userData!.incorrectAnswers) != 0
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: EasyPieChart(
                          gap: 0.05,
                          animateDuration: const Duration(milliseconds: 800),
                          start: 0,
                          size: 180,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          borderWidth: 20,
                          animateFromEnd: true,
                          onTap: (index) {
                            if (index == 0) {
                              tapIndex = "Correct Answers";
                            } else if (index == 1) {
                              tapIndex = "Incorrect Answers";
                            }
                            // tapIndex = index.toString();
                            setState(() {});
                          },
                          pieType: PieType.crust,
                          children: [
                            PieData(
                                value: ((userData!.correctAnswers /
                                        (userData!.correctAnswers +
                                            userData!.incorrectAnswers)))
                                    .toDouble(),
                                color: Colors.green),
                            PieData(
                                value: ((userData!.incorrectAnswers /
                                        (userData!.correctAnswers +
                                            userData!.incorrectAnswers)))
                                    .toDouble(),
                                color: Colors.red),
                          ],
                          child: Center(
                            child: tapIndex == "Correct Answers"
                                ? Text(
                                    tapIndex,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(tapIndex,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text("Play a quiz to see your statistics!", style: TextStyle(fontSize: 18.0)),
                      ),
                ProfileMenuWidget(
                  title: 'Name: ${userData!.username}',
                  icon: LineAwesomeIcons.user,
                  onPress: () {},
                  color: Colors.blue,
                  endIcon: false,
                  hasPressAction: false,
                ),
                ProfileMenuWidget(
                  title: 'Email: ${userData!.email}',
                  icon: LineAwesomeIcons.envelope,
                  onPress: () {},
                  color: Colors.green,
                  endIcon: false,
                  hasPressAction: false,
                ),
                ProfileMenuWidget(
                  title: 'Level: ${userData!.level}',
                  icon: LineAwesomeIcons.star,
                  onPress: () {},
                  color: Colors.yellow,
                  endIcon: false,
                  hasPressAction: false,
                ),
                ProfileMenuWidget(
                  title: 'Streak: ${userData!.streakCount}',
                  icon: LineAwesomeIcons.fire,
                  onPress: () {},
                  color: Colors.red,
                  endIcon: false,
                  hasPressAction: false,
                ),
                ProfileMenuWidget(
                  title: 'Points: ${userData!.points}',
                  icon: LineAwesomeIcons.coins,
                  onPress: () {},
                  color: Colors.orange,
                  endIcon: false,
                  hasPressAction: false,
                ),
                ProfileMenuWidget(
                  title: 'Correct Answers: ${userData!.correctAnswers}',
                  icon: LineAwesomeIcons.check_circle,
                  // onPress: () {
                  //   tapIndex = "Correct Answers";
                  //   setState(() {});
                  // },
                  onPress: () {},
                  hasPressAction: false,
                  color: Colors.green,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Incorrect Answers: ${userData!.incorrectAnswers}',
                  icon: LineAwesomeIcons.times_circle,
                  // onPress: () {
                  //   tapIndex = "Incorrect Answers";
                  //   setState(() {});
                  // },
                  onPress: () {},
                  hasPressAction: false,
                  color: Colors.red,
                  endIcon: false,
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
