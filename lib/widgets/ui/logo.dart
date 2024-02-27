import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              color: Colors.white,
              child: Center(
                  child: Hero(
                    tag: "logoImage",
                    child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/quiz_logo_2.png'),
                      fit: BoxFit.contain,
                    ),
                ),
              ),
                  ))),
          Column(
            children: [
              Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    "MK",
                    style: GoogleFonts.merriweather(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[800],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    "LEARNER",
                    style: GoogleFonts.merriweather(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
