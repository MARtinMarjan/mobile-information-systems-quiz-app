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
  late String username = 'N/A';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: ListView(
                  children: <Widget>[
                    const Logo(),
                    const SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your username',
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      ),
                    ),
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
            const FooterAuth(),
          ],
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      await userViewModel.register(email, password, username);
      if (context.mounted) {
        Navigator.pushNamed(context, '/home_page');
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }
}
