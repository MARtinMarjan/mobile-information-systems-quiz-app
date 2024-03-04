import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question_matcher.dart';

import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/profile_menu_widget.dart';
import '../add_quiz/quiz_form_page.dart';
import '../chatgpt/chat_completion.dart';
import '../quiz/matcher.dart';
import '../sounds/sound_test.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // PersistentNavBarNavigator.pushNewScreen(
              //   context,
              //   screen: const ProfileScreen(),
              //   withNavBar: true,
              //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
              // );
              Navigator.of(context).popUntil((route) {
                return route.settings.name == "/profile_screen";
              });
            },
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: ListView(
          children: [
            ProfileMenuWidget(
              title: 'Reset Progress',
              icon: LineAwesomeIcons.times_circle,
              onPress: () {
                // UserViewModel userViewModel =
                //     Provider.of<UserViewModel>(context, listen: false);
                //
                // userViewModel.resetProgress();
                //
                // Navigator.of(context).popUntil((route) {
                //   return route.settings.name == "/profile_screen";
                // });
                // modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Reset Progress"),
                      content: const Text(
                          "Are you sure you want to reset your progress?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            user.resetProgress();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Reset',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  },
                );
              },
              color: Colors.red,
              endIcon: false,
            ),
            ProfileMenuWidget(
              title: 'Change Password',
              icon: LineAwesomeIcons.key,
              onPress: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: _resetPassword(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              endIcon: false,
              color: Colors.red,
            ),
            ProfileMenuWidget(
              title: 'Delete Account',
              icon: LineAwesomeIcons.trash,
              onPress: () {
                // show modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text(
                          "Are you sure you want to delete your account?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            user.deleteAccount();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  },
                );
              },
              color: Colors.red,
              endIcon: false,
            ),
            (user.userData!.role == 'admin' || user.userData!.role == 'dev')
                ? ProfileMenuWidget(
                    title: 'DEV: Add New Level',
                    icon: LineAwesomeIcons.plus_circle,
                    onPress: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const QuizFormPage(),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    color: Colors.green,
                    endIcon: false,
                  )
                : Container(),
            (user.userData!.role == 'admin' || user.userData!.role == 'dev')
                ? ProfileMenuWidget(
                    title: 'DEV: Open Quiz Matcher',
                    icon: LineAwesomeIcons.plus_circle,
                    onPress: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: MatchQuestion(questionsMatcher: [
                          QuestionMatcher.fromMap({
                            "questions": ["1", "2"],
                            "answers": ["3", "4"],
                            "areQuestionsImages": false,
                          }),
                        ]),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    color: Colors.green,
                    endIcon: false,
                  )
                : Container(),
            (user.userData!.role == 'admin' || user.userData!.role == 'dev')
                ? ProfileMenuWidget(
                    title: 'DEV: Open ChatGPT',
                    icon: LineAwesomeIcons.robot,
                    onPress: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const ChatCompletionPage(),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    color: Colors.green,
                    endIcon: false,
                  )
                : Container(),
            (user.userData!.role == 'admin' || user.userData!.role == 'dev')
                ? ProfileMenuWidget(
                    title: 'DEV: Test Game Sounds',
                    icon: LineAwesomeIcons.robot,
                    onPress: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const SoundpoolInitializer(),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    color: Colors.green,
                    endIcon: false,
                  )
                : Container(),
          ],
        ));
  }

  _resetPassword() {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      String email = userViewModel.userData!.email;
      userViewModel.resetForgottenPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(bottom: 20.0, left: 12.0, right: 12.0),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Text('Password reset email sent to $email'),
        ),
      );
    } catch (e) {
      Text("Email Error: $e");
    }
  }
}
