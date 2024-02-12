import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/ProfileMenuWidget.dart';

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
  );

  @override
  void initState() {
    super.initState();
    UserViewModel userViewModel = Provider.of<UserViewModel>(
        context, listen: false);
    userViewModel.loadUserData();
    userData = userViewModel.userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/home_screen'),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineAwesomeIcons.cog),
          ),
        ],
      ),
      body: userData != null
          ? ListView(
        children: [
          ProfileMenuWidget(
            title: 'Name: ${userData!.username}',
            icon: LineAwesomeIcons.user,
            onPress: () {},
            color: Colors.blue,
          ),
          ProfileMenuWidget(
            title: 'Email: ${userData!.email}',
            icon: LineAwesomeIcons.envelope,
            onPress: () {},
            color: Colors.green,
          ),
          ProfileMenuWidget(
            title: 'Level: ${userData!.level}',
            icon: LineAwesomeIcons.star,
            onPress: () {},
            color: Colors.yellow,
          ),
          ProfileMenuWidget(
            title: 'Points: ${userData!.points}',
            icon: LineAwesomeIcons.coins,
            onPress: () {},
            color: Colors.orange,
          ),
          ProfileMenuWidget(
            title: 'Correct Answers: ${userData!.correctAnswers}',
            icon: LineAwesomeIcons.check_circle,
            onPress: () {},
            color: Colors.teal,
          ),
          ProfileMenuWidget(
            title: 'Incorrect Answers: ${userData!.incorrectAnswers}',
            icon: LineAwesomeIcons.times_circle,
            onPress: () {},
            color: Colors.red,
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
