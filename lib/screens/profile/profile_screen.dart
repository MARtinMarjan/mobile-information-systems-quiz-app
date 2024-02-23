import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/profile/settings_screen.dart';
import 'package:quiz_app/screens/profile/stats_screen.dart';
import 'package:quiz_app/screens/profile/update_profile_screen.dart';
import 'package:quiz_app/viewmodels/user.viewmodel.dart';
import 'package:quiz_app/widgets/profile_menu_widget.dart';
import 'package:quiz_app/widgets/ui/footer_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    var zolta = Colors.orange;
    var bodyText = Theme.of(context).textTheme.bodyMedium;
    return Consumer<UserViewModel>(
      builder: (BuildContext context, UserViewModel value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
                          child: value.userData?.imageLink != null
                              ? Image(
                                  image:
                                      NetworkImage(value.userData!.imageLink),
                                  fit: BoxFit.cover,
                                )
                              : const Placeholder(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${value.userData?.username}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${value.userData?.email}',
                    style: bodyText,
                  ),
                  Text(
                    'Level: ${value.userData?.level}',
                    style: bodyText,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const UpdateProfileScreen(),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: zolta,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: const Text("Edit Profile",
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 0, 1))),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 30),
                  ProfileMenuWidget(
                      title: "Settings",
                      icon: LineAwesomeIcons.cogs,
                      onPress: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const SettingsScreen(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      color: zolta),
                  const SizedBox(height: 30),
                  ProfileMenuWidget(
                      title: "Stats",
                      icon: LineAwesomeIcons.info,
                      // onPress:() => Get.to(() => const StatsScreen()),
                      onPress: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const StatsScreen(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
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
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/welcome_screen");
                        // Navigator.popAndPushNamed(context, "/login_screen");
                      },
                      endIcon: false,
                      color: Colors.red),
                  const SizedBox(height: 30), // Add SizedBox for spacing
                  const FooterAuth()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
