import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService auth = AuthService();
  late DBService db;

  QuizUserData? userData = QuizUserData(
    uid: '',
    email: '',
    username: '',
    level: 0,
    points: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
  );

  @override
  void initState() {
    super.initState();
    db = DBService(auth.getCurrentUser().uid);
    db.getUserData().then((value) {
      setState(() {
        userData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
