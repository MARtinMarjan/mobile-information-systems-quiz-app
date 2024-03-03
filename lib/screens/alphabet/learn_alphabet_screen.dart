import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quiz_app/screens/alphabet/letter.dart';

import '../quiz/questions_screen.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  bool capitalLetterSwitch = true;

  @override
  initState() {
    super.initState();
    initTts();
  }

  @override
  Widget build(BuildContext context) {
    //macedonian alphabet
    List<Letter> alphabet = [
      Letter('А', 'A'),
      Letter('Б', 'B'),
      Letter('В', 'V'),
      Letter('Г', 'G'),
      Letter('Д', 'D'),
      Letter('Ѓ', 'Gj'),
      Letter('Е', 'E'),
      Letter('Ж', 'Ž'),
      Letter('З', 'Z'),
      Letter('Ѕ', 'Dz'),
      Letter('И', 'I'),
      Letter('Ј', 'J'),
      Letter('К', 'K'),
      Letter('Л', 'L'),
      Letter('Љ', 'Lj'),
      Letter('М', 'M'),
      Letter('Н', 'N'),
      Letter('Њ', 'Nj'),
      Letter('О', 'O'),
      Letter('П', 'P'),
      Letter('Р', 'R'),
      Letter('С', 'S'),
      Letter('Т', 'T'),
      Letter('Ќ', 'Kj'),
      Letter('У', 'U'),
      Letter('Ф', 'F'),
      Letter('Х', 'H'),
      Letter('Ц', 'C'),
      Letter('Ч', 'Č'),
      Letter('Џ', 'Dž'),
      Letter('Ш', 'Š'),
    ];

    return Center(
      child: ListView(
        children: [
          // const SizedBox(height: 10),
          const Center(
            child: Text(
              'Macedonian Alphabet',
              style: TextStyle(fontSize: 30),
            ),
          ),
          GridView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              children: [
                for (var i = 0; i < 31; i++)
                  GestureDetector(
                    onTap: () {
                      _readAnswer(alphabet[i].cyrillic);
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              //light shadow
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset:
                                    const Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber,
                                Colors.amberAccent,
                              ],
                            ),
                          ),
                          // color: Colors.amber,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  capitalLetterSwitch
                                      ? alphabet[i].cyrillic
                                      : alphabet[i].cyrillic.toLowerCase(),
                                  style: const TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  capitalLetterSwitch
                                      ? alphabet[i].latinCounterpart
                                      : alphabet[i]
                                          .latinCounterpart
                                          .toLowerCase(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Image of quiz_logo_2.png
                GestureDetector(
                  onTap: () {
                    setState(() {
                      capitalLetterSwitch = !capitalLetterSwitch;
                    });
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        // color: Colors.amber,
                        child: Center(
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ],
      ),
    );
  }

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWindows => !kIsWeb && Platform.isWindows;

  bool get isWeb => kIsWeb;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {}
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {}
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {});
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.getLanguages.then((value) => {
          print(value),
        });
    setState(() {
      // getLanguageDropDownMenuItems(languages);
      flutterTts.setLanguage("bg-BG");
      // flutterTts.setLanguage("sr-SR");
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled("bg-BG")
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }

  Future<void> _readAnswer(String word) async {
    var result = await flutterTts.speak(word);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }
}
