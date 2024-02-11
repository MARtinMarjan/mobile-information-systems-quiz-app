import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/db_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService auth = AuthService();
  late DBService db;

  QuizUserData? userData = QuizUserData(
    uid: '',
    email: '',
    username: '',
    level: 0,
    points: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
  );

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    db = DBService();
    userViewModel.loadUserData();
    userData = userViewModel.userData;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Column(
  //       children: [
  //         const Text('Profile'),
  //         Column(
  //           children: [
  //             Text('Name: ${userData?.username}'),
  //             Text('Email: ${userData?.email}'),
  //             Text('Level: ${userData?.level}'),
  //             Text('Points: ${userData?.points}'),
  //             Text('Correct Answers: ${userData?.correctAnswers}'),
  //             Text('Incorrect Answers: ${userData?.incorrectAnswers}'),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var zolta = Colors.yellow;
    var bodyText = Theme.of(context).textTheme.bodyMedium;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(
                        image:
                            AssetImage("assets/level_map/BoyGraduation.png")),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Username: ${userData?.username}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Email: ${userData?.email}',
                  style: bodyText,
                ),
                Text(
                  'Level: ${userData?.level}',
                  style: bodyText,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 500,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: zolta,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text("Edit Profile",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 1))),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 30),
                ProfileMenuWidget(
                    title: "Settings",
                    icon: LineAwesomeIcons.cogs,
                    onPress: () {},
                    color: zolta),
                const SizedBox(height: 30),
                ProfileMenuWidget(
                    title: "Stats",
                    icon: LineAwesomeIcons.info,
                    onPress: () {},
                    color: zolta),
                const SizedBox(height: 30),
                ProfileMenuWidget(
                    title: "Logout",
                    icon: LineAwesomeIcons.alternate_sign_out,
                    onPress: () {
                      if (auth.getCurrentUser() != null) {
                        auth.signOut();
                      }
                      Navigator.pushNamed(context, '/welcome_screen');
                    },
                    endIcon: false,
                    color: Colors.red),
              ],
            )),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    required this.color,
  });

  final MaterialColor color;
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color.withOpacity(0.1),
        ),
        child: Icon(icon),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18.0, color: Colors.grey))
          : null,
    );
  }
}
