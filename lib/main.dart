import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/myapp.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

int? initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseApi().initNotifications();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');

  final authService = AuthService();
  final dbService = DBService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => QuizViewModel(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) =>
              UserViewModel(authService: authService, dbService: dbService),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
