import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/user.viewmodel.dart';
import '../widgets/ui/logo.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late UserViewModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserViewModel>(context, listen: false);
    Timer(const Duration(seconds: 3), () {
      _checkIfAlreadySignedIn().then((value) {
        if (value) {
          Navigator.pushReplacementNamed(context, '/home_page');
        } else {
          Navigator.pushReplacementNamed(context, '/welcome_screen');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Logo();
  }

  Future<bool> _checkIfAlreadySignedIn() async {
    return user.isAlreadySignedIn();
  }
}
