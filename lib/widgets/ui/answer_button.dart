import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final double height;

  final double width;

  final double fontSize;

  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onTap,
    required this.color,
    this.height = 20,
    this.width = 20,
    this.fontSize = 16,
  });

  final String answerText;

  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 40,
        ),
        // backgroundColor: const Color.fromARGB(255, 33, 1, 95),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        answerText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
