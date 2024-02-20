import 'package:flutter/material.dart';

class FooterAuth extends StatelessWidget {
  const FooterAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Center(
        child: Text(
          'Copyright Mobile Information Systems FINKI 2024',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}