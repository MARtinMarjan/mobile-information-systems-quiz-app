import 'package:flutter/material.dart';
import 'package:quiz_app/screens/auth/login_screen.dart';
import 'package:quiz_app/screens/auth/registration_screen.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/quiz/quiz.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/auth/welcome_screen.dart';

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
        '/quiz_page': (BuildContext context) => const Quiz(),
        '/login_page': (BuildContext context) => const LoginPage(),
        '/registration_page': (BuildContext context) =>
            const RegistrationPage(),
        '/home_page': (BuildContext context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
        '/welcome_page': (BuildContext context) => const WelcomePage(),
      },
    );
  }
}
