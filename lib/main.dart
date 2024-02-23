import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/myapp.dart';
import 'package:quiz_app/services/leaderboard_service.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseApi().initNotifications();

  final authService = AuthService();
  final dbService = DBService();
  final leaderboardService = LeaderboardService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => QuizViewModel(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(
              authService: authService,
              dbService: dbService,
              leaderboardService: leaderboardService),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
