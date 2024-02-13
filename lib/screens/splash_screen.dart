import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/ui/logo.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/welcome_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Logo();
  }
}
