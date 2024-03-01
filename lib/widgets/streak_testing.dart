import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user.viewmodel.dart';

class StreakApp extends StatelessWidget {
  const StreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<UserViewModel>(
          builder: (context, userViewModel, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Streak: ${userViewModel.streakCount}',
                  style: const TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    userViewModel.checkoutActivityStreak();
                  },
                  child: const Text('Increment Streak'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
