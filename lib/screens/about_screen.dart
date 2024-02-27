// TODO

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<void>? _launched;

  @override
  Widget build(BuildContext context) {
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
          "About",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'This app is a simple quiz app that allows users to take quizzes and track their progress. It was built using Flutter and Firebase.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Version: 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Developed by: Dimitrija, Martin & Ivana',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Contact us at:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            GestureDetector(
              onTap: _composeMail1,
              child: const Text(
                'dimitrijatimeskidimitrija@gmail.com',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: _composeMail2,
              child: const Text(
                'Craftmine200@yahoo.com',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: _composeMail3,
              child: const Text(
                'milevska122@gmail.com',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _composeMail1() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'dimitrijatimeskidimitrija@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Subject Here...',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  void _composeMail2() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'Craftmine200@yahoo.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Subject Here...',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  void _composeMail3() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'milevska122@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Subject Here...',
      }),
    );

    launchUrl(emailLaunchUri);
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
