import 'package:flutter/material.dart';
import 'package:quiz_app/services/auth_service.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ///color
        backgroundColor: Colors.red,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: const Center(
              child: Text(
                'Welcome to the Quiz App!',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Center(
            child: Text(
              'You are logged in as ${AuthService().getCurrentUserEmail()}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quiz_page');
            },
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}
