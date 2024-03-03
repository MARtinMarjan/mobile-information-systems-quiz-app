import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_matcher/flutter_quiz_matcher.dart';
import 'package:flutter_quiz_matcher/models/model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/iquestion.dart';
import 'package:quiz_app/models/question_single_choice.dart';
import 'package:quiz_app/screens/level_map/answer.dart';
import 'package:quiz_app/viewmodels/quiz.viewmodel.dart';
import 'package:quiz_app/screens/quiz/results_screen.dart';
import 'package:simplytranslate/simplytranslate.dart';
import 'package:soundpool/soundpool.dart';
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

  late Answer _lastAnsweredQuestion;

  bool _showQuestionResultDialog = false;

  late String rememberSelectedAnswer = '';

  int totalMatcherAnswers = 0;
  int totalCorrectMatcherAnswers = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
    initTts();
    if (!kIsWeb) {
      _initPool(_soundpoolOptions);
    }
    _loadSounds();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Soundpool? _pool;
  SoundpoolOptions _soundpoolOptions = const SoundpoolOptions();

  late Future<int> _successId;
  late Future<int> _failureId;

  late Future<int> _congratsId;
  int? _successSoundStreamId;
  int? _failureSoundStreamId;

  void _loadSounds() {
    _successId = _loadSuccessSound();
    _failureId = _loadFailureSound();
    _congratsId = _loadCongratsSound();
  }

  Future<int> _loadSuccessSound() async {
    var asset = await rootBundle.load('assets/sounds/success.mp3');
    return await _pool!.load(asset);
  }

  Future<int> _loadCongratsSound() async {
    var asset = await rootBundle.load('assets/sounds/tada.mp3');
    return await _pool!.load(asset);
  }

  Future<int> _loadFailureSound() async {
    var asset = await rootBundle.load('assets/sounds/error.mp3');
    return await _pool!.load(asset);
  }

  Future<void> _playSuccessSound() async {
    var sound = await _successId;
    _successSoundStreamId = await _pool!.play(sound);
  }

  Future<void> _playCongratsSound() async {
    var sound = await _congratsId;
    _successSoundStreamId = await _pool!.play(sound);
  }

  Future<void> _playFailureSound() async {
    var sound = await _failureId;
    _failureSoundStreamId = await _pool!.play(sound);
  }

  void _initPool(SoundpoolOptions soundpoolOptions) {
    _pool?.dispose();
    setState(() {
      _soundpoolOptions = soundpoolOptions;
      _pool = Soundpool.fromOptions(options: _soundpoolOptions);
      print('pool updated: $_pool');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(builder: (context, quizData, _) {
      int currentQuestionIndex = quizData.currentQuestionIndex;
      IQuestion currentQuestion = widget.allQuestions[currentQuestionIndex];

      void saveAndGoNext(String selectedAnswer, IQuestion currentQuestion) {
        _timer.cancel();

        if (currentQuestion is QuestionSingleChoice) {
          bool correct = currentQuestion.correctAnswerIndex ==
              currentQuestion.answers.indexOf(selectedAnswer);

          _lastAnsweredQuestion = Answer(
            questionIndex: currentQuestionIndex,
            answer: selectedAnswer,
            isCorrect: correct,
            solution:
                currentQuestion.answers[currentQuestion.correctAnswerIndex],
            question: currentQuestion.questionText,
            questionType: QuestionType.singleChoice,
          );

          quizData.answerQuestion(
              selectedAnswer,
              currentQuestionIndex,
              QuestionType.singleChoice,
              correct,
              currentQuestion.answers[currentQuestion.correctAnswerIndex],
              currentQuestion.questionText);
        } else if (currentQuestion is QuestionMatcher) {
          if (totalMatcherAnswers != currentQuestion.questions.length) {
            _lastAnsweredQuestion = Answer(
              questionIndex: currentQuestionIndex,
              answer: selectedAnswer,
              isCorrect: false,
              solution: '',
              question: 'Match The Following',
              questionType: QuestionType.matcher,
            );
            return;
          }
          if (totalCorrectMatcherAnswers == totalMatcherAnswers) {
            _lastAnsweredQuestion = Answer(
              questionIndex: currentQuestionIndex,
              answer: selectedAnswer,
              isCorrect: true,
              solution: '',
              question: 'Match The Following',
              questionType: QuestionType.matcher,
            );
            quizData.answerQuestion(selectedAnswer, currentQuestionIndex,
                QuestionType.matcher, true, '', 'Match The Following');
          } else {
            _lastAnsweredQuestion = Answer(
              questionIndex: currentQuestionIndex,
              answer: selectedAnswer,
              isCorrect: false,
              solution: '',
              question: 'Match The Following',
              questionType: QuestionType.matcher,
            );
            quizData.answerQuestion(selectedAnswer, currentQuestionIndex,
                QuestionType.matcher, false, '', 'Match The Following');
          }

          setState(() {
            totalCorrectMatcherAnswers = 0;
            totalMatcherAnswers = 0;
            currentQuestionIndex = quizData.currentQuestionIndex;
            currentQuestion = widget.allQuestions[currentQuestionIndex];
          });
        }

        if (_lastAnsweredQuestion.isCorrect) {
          _playSuccessSound();
        } else {
          _playFailureSound();
        }

        _showQuestionResultDialog = true;
      }

      if (!_isQuizPaused) {
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
                              if (currentQuestion.questionType ==
                                  "listen_and_answer")
                                Column(children: [
                                  const Text(
                                    'Listen And Select the Correct Answer',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _readAnswer(currentQuestion.questionText);
                                      _resumeQuiz();
                                    },
                                    child: const Icon(
                                      CupertinoIcons.waveform_circle_fill,
                                      size: 100,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ])
                              else
                                GestureDetector(
                                  onTap: () async {
                                    _readAnswer(currentQuestion.questionText);
                                    final gt =
                                        SimplyTranslator(EngineType.google);
                                    String translatedText = await gt.trSimply(
                                        currentQuestion.questionText,
                                        "mk",
                                        'en');
                                    String translatedTextOpposite =
                                        await gt.trSimply(
                                            currentQuestion.questionText,
                                            "en",
                                            'mk');
                                    // show the translated text in a snackbar from the top
                                    Get.snackbar("Translation",
                                        "$translatedText\n$translatedTextOpposite",
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.amber,
                                        colorText: Colors.black,
                                        margin: const EdgeInsets.all(10),
                                        borderRadius: 10,
                                        duration: const Duration(seconds: 5),
                                        isDismissible: true,
                                        // dismissDirection: SnackDismissDirection.HORIZONTAL,
                                        forwardAnimationCurve:
                                            Curves.easeOutBack,
                                        reverseAnimationCurve:
                                            Curves.easeInCirc,
                                        animationDuration:
                                            const Duration(milliseconds: 800),
                                        snackStyle: SnackStyle.FLOATING,
                                        icon: const Icon(Icons.translate,
                                            color: Colors.black),
                                        shouldIconPulse: true,
                                        mainButton: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text(
                                            'Close',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ));

                                    _resumeQuiz();
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
                                    }),
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
                bottom: 45,
                child: AnswerButton(
                  answerText: 'Submit',
                  onTap: () {
                    saveAndGoNext(rememberSelectedAnswer, currentQuestion);
                    _pauseTimer();
                    _showResultDialog(quizData, currentQuestionIndex);
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
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/quiz_logo_4_sleeping.png',
                  width: 200,
                  height: 200,
                ),
                const Text(
                  'Paused',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnswerButton(
                  answerText: 'Resume',
                  onTap: () {
                    _resumeQuiz();
                  },
                  color: Colors.amber,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  fontSize: 20,
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _questionMatcherWidget(QuestionMatcher question) {
    return QuizMatcher(
      questions: [
        ...question.questions.map(
          (question) {
            return GestureDetector(
              onTap: () {
                _readAnswer(question);
                _resumeQuiz();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black)),
                width: 100,
                height: 100,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                _resumeQuiz();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black)),
                width: 100,
                height: 100,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(answer,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
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
    const pauseDuration = Duration(seconds: 10); // Adjust as needed
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

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isQuizPaused = false;
    });
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

  _showResultDialog(QuizViewModel quizData, currentQuestionIndex) {
    // We use _lastAnsweredQuestion here to show the result of the last answered question
    // make it pop out from the bottom and have simillar design as the answer buttons and a button togo to nextr question
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async => false,
            child: FractionallySizedBox(
                heightFactor: 0.3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Question Result',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _lastAnsweredQuestion.isCorrect
                            ? 'Correct ✅'
                            : 'Incorrect ❌',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _lastAnsweredQuestion.isCorrect
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (!_lastAnsweredQuestion.isCorrect &&
                              _lastAnsweredQuestion.questionType !=
                                  QuestionType.matcher)
                          ? FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Correct Answer: ${_lastAnsweredQuestion.solution}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      AnswerButton(
                        answerText: 'Next Question',
                        onTap: () {
                          setState(() {
                            _showQuestionResultDialog = false;
                            rememberSelectedAnswer = '';
                            _lastAnsweredQuestion = Answer(
                              questionIndex: 0,
                              answer: '',
                              isCorrect: false,
                              solution: '',
                              question: '',
                              questionType: QuestionType.singleChoice,
                            );
                            quizData.goToNextQuestion();
                            _resumeQuiz();
                          });
                          var isLastQuestion = currentQuestionIndex >=
                              widget.allQuestions.length - 1;
                          Navigator.of(context).pop();
                          if (isLastQuestion) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ResultsScreen(
                                  chosenAnswers: quizData.getChosenAnswers(),
                                  congratsSound: _playCongratsSound,
                                ),
                              ),
                            );
                          }
                        },
                        color: Colors.amber,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        fontSize: 20,
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}

enum TtsState { playing, stopped, paused, continued }
