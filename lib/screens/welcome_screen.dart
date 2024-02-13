import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';

import '../widgets/ui/logo.dart';
import '../widgets/ui/rounded_button.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.loadUserData();
    if (userViewModel.user != null) {
      Navigator.pushNamed(context, '/home_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(children: <Widget>[
            const Logo(),
            RoundedButton(
              colour: Colors.red,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, '/login_screen');
              },
            ),
            RoundedButton(
                colour: Colors.redAccent,
                title: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, '/registration_screen');
                }),
          ]),
        ));
  }
}
