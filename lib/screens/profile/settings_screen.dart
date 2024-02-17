import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../viewmodels/user.viewmodel.dart';
import '../../widgets/profile_menu_widget.dart';

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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile_screen'),
            icon: const Icon(LineAwesomeIcons.angle_left),
          ),
          title: Text(
            "Profile",
            style: Theme
                .of(context)
                .textTheme
                .headlineMedium,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(LineAwesomeIcons.cog),
            ),
          ],
        ),
        body: ListView(
          children: [
            ProfileMenuWidget(
              title: 'Reset Progress',
              icon: LineAwesomeIcons.times_circle,
              onPress: () {
                UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
                userViewModel.resetProgress();
                Navigator.pushNamed(context, '/profile_screen');
              },
              color: Colors.red,
              endIcon: false,
            ),
            ProfileMenuWidget(
              title: 'Change Password',
              icon: LineAwesomeIcons.key,
              onPress: () {},
              endIcon: false,
              color: Colors.red,
            ),
            ProfileMenuWidget(
              title: 'Delete Account',
              icon: LineAwesomeIcons.trash,
              onPress: () {},
              color: Colors.red,
              endIcon: false,
            ),
          ],
        )
    );
  }
}
