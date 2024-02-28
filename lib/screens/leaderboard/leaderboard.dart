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
                return Container(
                  decoration: index == 0
                      ? BoxDecoration(
                          color: Colors.yellowAccent[100],
                          borderRadius: BorderRadius.circular(10),
                        )
                      : index == 1
                          ? BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            )
                          : index == 2
                              ? BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                  child: ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    title: Text(snapshot.data![index].username),
                    subtitle: Row(
                      children: [
                        Text('Points: ${snapshot.data![index].points}'),
                        const SizedBox(width: 8),
                        Text('Streak: ${snapshot.data![index].streakCount}'),
                      ],
                    ),
                    trailing: snapshot.data?[index].imageLink != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data![index].imageLink))
                        : const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
