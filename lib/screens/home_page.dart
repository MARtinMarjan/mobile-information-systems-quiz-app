import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedinUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
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
              _auth.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
              //Implement logout functionality
            }),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            // margin: const EdgeInsets.only(top: 20),
            child: const Center(
              child: Text(
                'Welcome to the Quiz App!',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Center(
            child: Text(
              'You are logged in as ${loggedinUser.email}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          // Procceed to quiz
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
