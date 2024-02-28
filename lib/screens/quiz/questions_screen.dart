import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import '../../widgets/ui/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Timer _timer;
  bool _isQuizPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    initTts();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const pauseDuration = Duration(seconds: 20); // Adjust as needed
    _timer = Timer(pauseDuration, () {
      setState(() {
        _isQuizPaused = true;
      });
    });
  }

  void _resumeQuiz() {
    // Cancel the timer and resume the quiz
    _timer.cancel();
    setState(() {
      _isQuizPaused = false;
    });
    _startTimer(); // Restart the timer
  }

  late String rememberSelectedAnswer = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resumeQuiz, // Resume the quiz on any tap
      onPanDown: (_) => _resumeQuiz, // Resume the quiz on pan down
      child: Consumer<QuizViewModel>(
        builder: (context, quizData, _) {
          final questions = quizData.questions;
          final currentQuestionIndex = quizData.currentQuestionIndex;

          void answerQuestion(String selectedAnswer) {
            _timer.cancel(); // Cancel the timer when answering a question
            quizData.answerQuestion(selectedAnswer);
            if (currentQuestionIndex == questions.length - 1) {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen:
                    ResultsScreen(chosenAnswers: quizData.getChosenAnswers()),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            }
          }

          final currentQuestion = questions[currentQuestionIndex];

          return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width,
                    lineHeight: 20.0,
                    percent: (currentQuestionIndex) / questions.length,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.green,
                    barRadius: const Radius.circular(16),
                  ),
                ),
                if (!_isQuizPaused)
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _readAnswer(currentQuestion.questionText);
                            },
                            child: Text(
                              currentQuestion.questionText,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ...currentQuestion.answers.map((answer) {
                            return AnswerButton(
                              answerText: answer,
                              onTap: () {
                                _readAnswer(answer);
                                setState(() {
                                  rememberSelectedAnswer = answer;
                                });
                                // answerQuestion(answer);
                              },
                              color: rememberSelectedAnswer == answer
                                  ? Colors.redAccent
                                  : Colors.grey,
                            );
                          }),
                          const SizedBox(height: 30),
                          AnswerButton(
                            answerText: 'Submit',
                            onTap: () {
                              if (rememberSelectedAnswer.isNotEmpty &&
                                  rememberSelectedAnswer != '') {
                                answerQuestion(rememberSelectedAnswer);
                                rememberSelectedAnswer = '';
                              }
                            },
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Quiz Paused',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tap anywhere to unpause',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
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

  String? _newVoiceText;
  int? _inputLength;

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
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
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
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.getLanguages.then((value) => {
          print(value),
        });
    setState(() {
      // getLanguageDropDownMenuItems(languages);
      flutterTts.setLanguage("sk-SK");
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled("sk-SK")
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  Future<void> _readAnswer(String word) async {
    var result = await flutterTts.speak(word);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }
}

enum TtsState { playing, stopped, paused, continued }
