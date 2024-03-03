import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
                      leading: SizedBox(
                        width: 50,
                        child: Text(
                          _leaderboardIndex(index + 1),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(snapshot.data![index].username),
                      // subtitle: Row(
                      //   children: [
                      //     Text('🪙: ${snapshot.data![index].points}'),
                      //     const SizedBox(width: 8),
                      //     Text('🔥: ${snapshot.data![index].streakCount}'),
                      //   ],
                      // ),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(Icons.whatshot_outlined,
                                          size: 20, color: Colors.redAccent),
                                    ),
                                    TextSpan(
                                      text: "${snapshot.data![index].streakCount}",
                                      style: const TextStyle(
                                        // fontSize: 20,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(LineAwesomeIcons.coins,
                                        size: 20, color: Colors.amber),
                                  ),
                                  TextSpan(
                                    text: "${snapshot.data![index].points} ",
                                    style: const TextStyle(
                                      // fontSize: 20,
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      trailing: snapshot.data?[index].imageLink != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data?[index].imageLink ?? ''),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            )),
                );
              },
            );
          }
        },
      ),
    );
  }

  String _leaderboardIndex(int i) {
    if (i == 1) {
      return '$i🥇';
    } else if (i == 2) {
      return '$i🥈';
    } else if (i == 3) {
      return '$i🥉';
    } else {
      return '$i';
    }
  }
}
