import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../viewmodels/user.viewmodel.dart';

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
              onPressed: () =>
                  Navigator.pushNamed(context, '/home_screen')
              ,
              icon: const Icon(LineAwesomeIcons.angle_left),
            ),
            title: Text(
              "Profile",
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(LineAwesomeIcons.cog),
              ),
            ]
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Profile'),
              Column(
                children: [
                  Text('Name: ${userData?.username}'),
                  Text('Email: ${userData?.email}'),
                  Text('Level: ${userData?.level}'),
                  Text('Points: ${userData?.points}'),
                  Text('Correct Answers: ${userData?.correctAnswers}'),
                  Text('Incorrect Answers: ${userData?.incorrectAnswers}'),
                ],
              ),
            ],
          ),
        )
    );
  }
}
