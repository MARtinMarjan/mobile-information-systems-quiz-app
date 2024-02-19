import 'package:cloud_firestore/cloud_firestore.dart';
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
  );

  @override
  void initState() {
    super.initState();
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    userViewModel.loadUserData();
    userData = userViewModel.userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/profile_screen'),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(LineAwesomeIcons.cog),
        //   ),
        // ],
      ),
      body: userData != null
          ? ListView(
              children: [
                ProfileMenuWidget(
                  title: 'Name: ${userData!.username}',
                  icon: LineAwesomeIcons.user,
                  onPress: () {},
                  color: Colors.blue,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Email: ${userData!.email}',
                  icon: LineAwesomeIcons.envelope,
                  onPress: () {},
                  color: Colors.green,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Level: ${userData!.level}',
                  icon: LineAwesomeIcons.star,
                  onPress: () {},
                  color: Colors.yellow,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Streak: ${userData!.streakCount}',
                  icon: LineAwesomeIcons.fire,
                  onPress: () {},
                  color: Colors.red,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Points: ${userData!.points}',
                  icon: LineAwesomeIcons.coins,
                  onPress: () {},
                  color: Colors.orange,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Correct Answers: ${userData!.correctAnswers}',
                  icon: LineAwesomeIcons.check_circle,
                  onPress: () {},
                  color: Colors.teal,
                  endIcon: false,
                ),
                ProfileMenuWidget(
                  title: 'Incorrect Answers: ${userData!.incorrectAnswers}',
                  icon: LineAwesomeIcons.times_circle,
                  onPress: () {},
                  color: Colors.red,
                  endIcon: false,
                ),

              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
