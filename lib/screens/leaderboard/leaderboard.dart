import 'package:flutter/material.dart';
import 'package:quiz_app/services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Leaderboard",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: FutureBuilder(
        future: _leaderboardService.getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data![index].imageLink),
                  ),
                  title: Text(snapshot.data![index].username),
                  subtitle: Text('Points: ${snapshot.data![index].points}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
