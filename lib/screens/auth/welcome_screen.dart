import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/auth/login_screen.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';

import '../../widgets/ui/footer_auth.dart';
import '../../widgets/ui/logo.dart';

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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      const Logo(),
                      const SizedBox(
                        height: 48.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: SignInButton(
                          // color: Colors.white,
                          // textColor: Colors.black,
                          padding: const EdgeInsets.all(6.0),
                          Buttons.Google,
                          text: 'Sign In with Google',
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            final userViewModel = Provider.of<UserViewModel>(
                                context,
                                listen: false);
                            userViewModel.googleSignUp(context);
                            Navigator.pushNamed(context, '/home_page');
                            // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const HomePage()));
                          },
                          // title: 'Sign In with Google',
                        ),
                      ),
                      const Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          endIndent: 15.0,
                        )),
                        Text("OR"),
                        Expanded(
                            child: Divider(
                          indent: 15.0,
                        )),
                      ]),
                      const Padding(
                        padding: EdgeInsets.only(top: 18.0),
                        child: LoginPage(),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const FooterAuth(),
          ]),
        ));
  }
}
