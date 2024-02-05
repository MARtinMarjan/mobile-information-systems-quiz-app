
import 'package:flutter/material.dart';

import '../ui/logo.dart';
import '../ui/rounded_button.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Logo(),
                RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () {
                    // Navigator.of(context, rootNavigator: true).pushNamed('/login_page');
                    Navigator.pushNamed(context, '/login_page');
                  },
                ),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: 'Register',
                    onPressed: () {
                      // Navigator.of(context, rootNavigator: true).pushNamed('/registration_screen');
                      Navigator.pushNamed(context, '/registration_page');
                    }),
              ]),
        ));
  }
}