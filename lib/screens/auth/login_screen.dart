import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/auth/forgotten_password_screen.dart';
import 'package:quiz_app/screens/auth/registration_screen.dart';

import '../../viewmodels/user.viewmodel.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: ModalProgressHUD(
    //     inAsyncCall: showSpinner,
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 24.0),
    //       child: Column(
    //         // shrinkWrap: true,
    //         // mainAxisAlignment: MainAxisAlignment.start,
    //         children: <Widget>[
    //           Expanded(
    //             child:
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // const Logo(),
          // const SizedBox(
          //   height: 48.0,
          // ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            onChanged: (value) {
              email = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            obscureText: true,
            textAlign: TextAlign.center,
            onChanged: (value) {
              password = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, '/registration_screen');
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: const ForgottenPasswordPage()));
            },
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Forgot your password? ",
                      style: TextStyle(fontSize: 15.0)),
                  Text(
                    "Reset it!",
                    style: TextStyle(
                      fontSize: 15.0,
                      decoration: TextDecoration.underline,
                      color: Colors.amber,
                      decorationColor: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, '/registration_screen');
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: const RegistrationPage()));
            },
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New to MKLearner? ", style: TextStyle(fontSize: 15.0)),
                  Text(
                    "Create an account!",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.amber,
                      decorationColor: Colors.amber,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RoundedButton(
            color: Colors.red,
            title: 'Log In',
            onPressed: _login,
            textColor: Colors.white,
          ),
        ],
      ),
      // ),
      // ),
      // Visibility(
      //   visible: !keyboardIsOpen,
      //   child: const FooterAuth(),
      // ),
      //         ],
      //       ),
      //     ),
      //   ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        final userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        await userViewModel.login(email, password).then((value) {
          if (value == "success" && context.mounted) {
            Navigator.pushNamed(context, '/home_page');
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
}
