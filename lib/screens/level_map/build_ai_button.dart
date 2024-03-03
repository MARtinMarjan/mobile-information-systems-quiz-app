import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../chatgpt/chat_completion.dart';

Widget buildAIButton(BuildContext context) {
  // CREATE A BUTTON A PIC OF app_icon.png AND A TEXT "Ask Miki AI"
  return Container(
    alignment: Alignment.bottomRight,
    margin: const EdgeInsets.only(bottom: 150),
    child: GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: const ChatCompletionPage(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 30),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 75,
              height: 75.0,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
                color: Colors.amberAccent,
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 50,
                height: 50,
                semanticLabel: 'MIKI AI',
              ),
            ),
            const Positioned(
              bottom: 10,
              child: Text(
                "Miki AI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
