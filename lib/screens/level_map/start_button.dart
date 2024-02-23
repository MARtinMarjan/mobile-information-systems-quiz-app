import 'package:flutter/material.dart';

Widget buildStartButton(BuildContext context, String levelNumber) {
  return Container(
      alignment: Alignment.bottomRight,
      margin: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed("/quiz_screen");
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360),
            ),
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "$levelNumber ",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}
