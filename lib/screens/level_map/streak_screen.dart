// TODO

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:quiz_app/utils/date_checkers.dart';

class StreakScreen extends StatelessWidget {
  final int streak;
  final DateTime lastOpenedDate;

  const StreakScreen(
      {super.key, required this.streak, required this.lastOpenedDate});

  //small
  @override
  Widget build(BuildContext context) {
    return calculateStreak(context, streak, lastOpenedDate);
  }
}

Widget calculateStreak(
    BuildContext context, int streak, DateTime lastOpenedDate) {
  DateTime today = DateTime.now();
  int days = daysBetweenDates(lastOpenedDate, today);

  if (days == 1) {
    return Material(
        type: MaterialType.transparency,
        child: ChatBubble(
            clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
            shadowColor: Colors.black,
            backGroundColor: Colors.grey,
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Play today to extend your streak!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))));
  } else if (days == 0) {
    return Material(
        type: MaterialType.transparency,
        child: ChatBubble(
            shadowColor: Colors.black,
            clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
            backGroundColor: Colors.red,
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Congrats you extended your streak today!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))));
  } else {
    return Material(
        type: MaterialType.transparency,
        child: ChatBubble(
            shadowColor: Colors.black,
            clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
            backGroundColor: Colors.blue,
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "You missed a day and lost your streak!🥶",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))));
  }
}
