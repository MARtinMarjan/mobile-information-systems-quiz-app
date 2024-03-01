import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/screens/add_quiz/quiz_form_page.dart';

import 'package:quiz_app/screens/auth/login_screen.dart';
import 'package:quiz_app/screens/auth/registration_screen.dart';
import 'package:quiz_app/screens/quiz/start_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/home_page.dart';
import 'package:quiz_app/screens/auth/welcome_screen.dart';
import 'package:quiz_app/screens/onboarding_screen.dart';
import 'package:quiz_app/widgets/streak_testing.dart';

import 'main.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: initScreen == 0 || initScreen == null
          ? "/onboarding_page"
          : "/splash_screen",
      routes: <String, WidgetBuilder>{
        '/splash_screen': (BuildContext context) => const Splashscreen(),
        '/login_screen': (BuildContext context) => const LoginPage(),
        '/registration_screen': (BuildContext context) =>
            const RegistrationPage(),
        // '/home_screen': (BuildContext context) =>
        //     const MyHomePage(title: 'MKLearner App Home Page'),
        '/welcome_screen': (BuildContext context) => const WelcomePage(),
        '/add_quiz': (BuildContext context) => const QuizFormPage(),
        '/streak_screen': (BuildContext context) => const StreakApp(),
        '/home_page': (BuildContext context) => const HomePage(),
        '/profile_screen': (BuildContext context) => const HomePage(),
        '/onboarding_page': (BuildContext context) => const OnboardingPage(),
      },
      // builder: EasyLoading.init(),
    );
  }
}
