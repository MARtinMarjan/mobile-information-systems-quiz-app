import 'package:flutter/material.dart';
import 'package:quiz_app/screens/add_quiz/quiz_form_page.dart';

import 'package:quiz_app/screens/auth/login_screen.dart';
import 'package:quiz_app/screens/auth/registration_screen.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/quiz/quiz.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/welcome_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/splash_screen',
      routes: <String, WidgetBuilder>{
        '/splash_screen': (BuildContext context) => const Splashscreen(),
        '/quiz_screen': (BuildContext context) => const Quiz(),
        '/login_screen': (BuildContext context) => const LoginPage(),
        '/registration_screen': (BuildContext context) =>
            const RegistrationPage(),
        '/home_screen': (BuildContext context) =>
            const MyHomePage(title: 'MKLearner App Home Page'),
        '/welcome_screen': (BuildContext context) => const WelcomePage(),
        '/add_quiz': (BuildContext context) => const QuizFormPage(),
      },
    );
  }
}
