import 'package:flutter/material.dart';
import 'package:modals/modals.dart';

import '../../utils/date_checkers.dart';
import 'streak_screen.dart';

Widget buildTitleCard(
    BuildContext context, String title, int streak, DateTime lastOpenedDate) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 35, left: 10),
          child: ModalAnchor(
            tag: 'anchor',
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: calculateStreakColor(streak, lastOpenedDate),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
              onPressed: () {
                showModal(ModalEntry.anchored(context,
                    barrierDismissible: true,
                    tag: 'anchoredModal',
                    anchorTag: 'anchor',
                    modalAlignment: Alignment.topLeft,
                    anchorAlignment: Alignment.bottomCenter,
                    child: StreakScreen(
                        streak: streak, lastOpenedDate: lastOpenedDate)));
              },
              child: calculateStreakAppropriateWidget(streak, lastOpenedDate),
            ),
          ),
        ),
      ),
      Container(
        width: 250,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 35, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360),
            ),
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

calculateStreakColor(int streak, DateTime lastOpenedDate) {
  DateTime today = DateTime.now();
  int days = daysBetweenDates(lastOpenedDate, today);
  if (days == 1) {
    return Colors.grey;
  } else if (days == 0) {
    return Colors.red;
  } else {
    return Colors.lightBlueAccent;
  }
}

Widget calculateStreakAppropriateWidget(int streak, DateTime lastOpenedDate) {
  DateTime today = DateTime.now();
  int days = daysBetweenDates(lastOpenedDate, today);
  if (days == 1) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$streak ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const WidgetSpan(
            child: Icon(Icons.timer_rounded, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  } else if (days == 0) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$streak ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const WidgetSpan(
            child: Icon(Icons.whatshot_outlined, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  } else {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$streak ",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const WidgetSpan(
            child: Icon(Icons.ac_unit, size: 20, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
