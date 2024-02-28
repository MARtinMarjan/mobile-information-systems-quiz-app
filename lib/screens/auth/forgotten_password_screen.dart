import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/user.viewmodel.dart';

import '../../widgets/ui/logo.dart';
import '../../widgets/ui/rounded_button.dart';

class ForgottenPasswordPage extends StatefulWidget {
  const ForgottenPasswordPage({super.key});

  @override
  State<ForgottenPasswordPage> createState() => _ForgottenPasswordPageState();
}

class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  late String email;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  late Timer _timer;

  int _counter = 10;

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_counter == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _counter--;
          });
        }
      },
    );
  }

  bool isAbleToResetPassword = true;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const pauseDuration = Duration(seconds: 10); // Adju
    startCountdown(); // st as needed
    _timer = Timer(pauseDuration, () {
      setState(() {
        isAbleToResetPassword = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      const Logo(),
                      const SizedBox(
                        height: 40.0,
                      ),
                      isAbleToResetPassword
                          ? const Center(
                              child: Text(
                                  'Enter your email to reset your password ',
                                  style: TextStyle(fontSize: 16)),
                            )
                          : Center(
                              child: Text(
                                  'Please wait for $_counter seconds before trying again',
                                  style: const TextStyle(fontSize: 16)),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
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
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      isAbleToResetPassword
                          ? RoundedButton(
                              color: Colors.red,
                              title: 'Reset Password',
                              onPressed: _login,
                              textColor: Colors.white,
                            )
                          : const RoundedButton(
                              color: Colors.grey,
                              title: 'Reset Password',
                              onPressed: null,
                              textColor: Colors.white,
                            ),
                      // Visibility(
                      //   visible: !keyboardIsOpen,
                      //   child: const FooterAuth(),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        await userViewModel.resetForgottenPassword(email);
        setState(() {
          isAbleToResetPassword = false;
          _counter = 10;
        });
        _startTimer();
      } catch (e) {
        Text("Email Error: $e");
      }
      setState(() {
        showSpinner = false;
      });
    }
  }
}
