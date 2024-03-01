import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_matcher/flutter_quiz_matcher.dart';
import 'package:flutter_quiz_matcher/models/model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/iquestion.dart';
import 'package:quiz_app/models/question_single_choice.dart';
import 'package:quiz_app/screens/level_map/answer.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import '../../models/question_matcher.dart';
import '../../widgets/ui/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.allQuestions});

  final List<IQuestion> allQuestions;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late Timer _timer;
  bool _isQuizPaused = false;

  late String rememberSelectedAnswer = '';

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

  int totalMatcherAnswers = 0;
  int totalCorrectMatcherAnswers = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
      builder: (context, quizData, _) {
        var currentQuestionIndex = quizData.currentQuestionIndex;
        var currentQuestion = widget.allQuestions[currentQuestionIndex];
        //
        // print(
        //     '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% currentQuestionIndex: $currentQuestionIndex');
        // print(
        //     '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% currentQuestion: $currentQuestion');
        //
        // if (currentQuestion is QuestionMatcher) {
        //   print(
        //       '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% currentQuestion is QuestionMatcher');
        //   print(
        //       '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% currentQuestion.questions: ${currentQuestion.questions}');
        //   print(
        //       '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% currentQuestion.answers: ${currentQuestion.answers}');
        //
        //   print(currentQuestion.questions[0]);
        // }

        void answerQuestion(String selectedAnswer, IQuestion currentQuestion) {
          var isLastQuestion =
              currentQuestionIndex >= widget.allQuestions.length - 1;
          _timer.cancel(); // Cancel the timer when answering a question
          if (currentQuestion is QuestionSingleChoice) {
            bool correct = currentQuestion.correctAnswerIndex ==
                currentQuestion.answers.indexOf(selectedAnswer);
            quizData.answerQuestion(
                selectedAnswer,
                currentQuestionIndex,
                QuestionType.singleChoice,
                correct,
                currentQuestion.answers[currentQuestion.correctAnswerIndex]);
          } else if (currentQuestion is QuestionMatcher) {
            if (totalMatcherAnswers != currentQuestion.questions.length) {
              return;
            }
            if (totalCorrectMatcherAnswers == totalMatcherAnswers) {
              quizData.answerQuestion(selectedAnswer, currentQuestionIndex,
                  QuestionType.matcher, true, '');
            } else {
              quizData.answerQuestion(selectedAnswer, currentQuestionIndex,
                  QuestionType.matcher, false, '');
            }
            setState(() {
              totalCorrectMatcherAnswers = 0;
              totalMatcherAnswers = 0;
              currentQuestionIndex = quizData.currentQuestionIndex;
              currentQuestion = widget.allQuestions[currentQuestionIndex];
            });
          }
          if (isLastQuestion) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ResultsScreen(
                  chosenAnswers: quizData.getChosenAnswers(),
                ),
              ),
            );
          }
        }

        return Scaffold(
            body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              currentQuestion is QuestionMatcher
                  ? Flexible(
                      child: _questionMatcherWidget(currentQuestion),
                    )
                  : currentQuestion is QuestionSingleChoice
                      ? Positioned(
                          top: 130,
                          left: 20,
                          right: 20,
                          child: Column(
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
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    ...currentQuestion.answers.map((answer) {
                                      return AnswerButton(
                                        answerText: answer,
                                        onTap: () {
                                          _readAnswer(answer);
                                          setState(() {
                                            _timer.cancel();
                                            rememberSelectedAnswer = answer;
                                          });
                                        },
                                        color: rememberSelectedAnswer == answer
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
              Positioned(
                top: 20,
                left: 0,
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const TextSpan(
                        text: 'Quiz',
                        style: TextStyle(
                          fontSize: 35,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 90,
                child: _showPercentIndicator(
                    currentQuestionIndex, widget.allQuestions.length),
              ),
              Positioned(
                bottom: 50,
                child: AnswerButton(
                  answerText: 'Submit',
                  onTap: () {
                    answerQuestion(rememberSelectedAnswer,
                        currentQuestion); //TODO: rememberSelectedAnswer
                  },
                  color: Colors.amber,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget _questionMatcherWidget(QuestionMatcher question) {
    return QuizMatcher(
      questions: [
        ...question.questions.map(
          (question) {
            return GestureDetector(
              onTap: () {
                _readAnswer(question);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black)),
                width: 100,
                height: 100,
                child: Text(question),
              ),
            );
          },
        ),
      ],
      answers: [
        ...question.answers.map(
          (answer) {
            return GestureDetector(
              onTap: () {
                _readAnswer(answer);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black)),
                width: 100,
                height: 100,
                child: Text(answer),
              ),
            );
          },
        ),
      ],
      defaultLineColor: Colors.black,
      correctLineColor: Colors.green,
      incorrectLineColor: Colors.red,
      drawingLineColor: Colors.black,
      onScoreUpdated: (UserScore userAnswers) {
        print(userAnswers.questionIndex);
        print(userAnswers.questionAnswer);
        _readAnswer(question.answers[userAnswers.questionIndex]);
        userAnswers = userAnswers;
        totalMatcherAnswers++;
        if (userAnswers.questionAnswer == true) {
          totalCorrectMatcherAnswers++;
        }
      },
      paddingAround: const EdgeInsets.only(top: 100, left: 30, right: 30),
    );
  }

  Widget _showPercentIndicator(int currentQuestionIndex, int length) {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width,
      lineHeight: 20.0,
      percent: currentQuestionIndex / length,
      backgroundColor: Colors.grey,
      progressColor: Colors.green,
      barRadius: const Radius.circular(16),
      animateFromLastPercent: true,
      animation: true,
    );
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
      flutterTts.setLanguage("hr-HR"); 
      // flutterTts.setLanguage("sr-SR");
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled("hr-HR")
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }

  Future<void> _readAnswer(String word) async {
    var result = await flutterTts.speak(word);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }
}

enum TtsState { playing, stopped, paused, continued }
