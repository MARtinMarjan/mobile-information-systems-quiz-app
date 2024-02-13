import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/ui/logo.dart';
import '../../widgets/ui/rounded_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: <Widget>[
              const Logo(),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  )),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password')),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  colour: Colors.red, title: 'Log In', onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      await userViewModel.login(email, password).then((value) {
        if (value == "success" && context.mounted) {
          Navigator.pushNamed(context, '/home_screen');
        }
      });
    } catch (e) {
      Text("Login Error: $e");
    }
    setState(() {
      showSpinner = false;
    });
  }
}
