import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/widgets/ui/footer_auth.dart';

import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/ui/logo.dart';
import '../../widgets/ui/rounded_button.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String email;
  late String password;
  late String username = '';
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

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
                    children: <Widget>[
                      const Logo(),
                      const SizedBox(
                        height: 48.0,
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your username',
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
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
                          setState(() {
                            password = value;
                          });
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
                      RoundedButton(
                        colour: Colors.red,
                        title: 'Register',
                        onPressed: _register,
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !keyboardIsOpen,
                child: const FooterAuth(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        final userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        await userViewModel.register(email, password, username);
        if (context.mounted) {
          Navigator.pushNamed(context, '/home_page');
        }
      } catch (e) {
        print('Registration Error: $e');
      }
      setState(() {
        showSpinner = false;
      });
    }
  }
}
