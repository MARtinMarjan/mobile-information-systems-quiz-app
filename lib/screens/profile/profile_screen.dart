import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/screens/profile/update_profile_screen.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/widgets/ProfileMenuWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  QuizUserData? userData = QuizUserData(
    uid: '',
    email: '',
    username: '',
    level: 0,
    points: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
    imageLink: '',
  );

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
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
          onPressed: () => Navigator.pushNamed(context, '/home_screen'),
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
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image: NetworkImage(userData?.imageLink ?? ''),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: zolta,
                        ),
                        child: const Icon(LineAwesomeIcons.alternate_pencil,
                            size: 20.0, color: Colors.black),
                      ),
                    ),
                  ],
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
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const UpdateProfileScreen()),
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
                    // onPress:() => Get.to(() => const StatsScreen()),
                    onPress: () {
                      Navigator.pushNamed(context, '/stats_screen');
                    },
                    color: zolta),
                const SizedBox(height: 30),
                ProfileMenuWidget(
                    title: "Logout",
                    icon: LineAwesomeIcons.alternate_sign_out,
                    onPress: () {
                      final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);
                      userViewModel.signOut();
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
