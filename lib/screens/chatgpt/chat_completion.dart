import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/chatgpt/question_answer.dart';
import 'package:quiz_app/screens/chatgpt/start_ai_screen.dart';
import 'package:quiz_app/services/questions_service.dart';
import 'package:quiz_app/widgets/ui/answer_button.dart';

import '../../models/quiz.dart';

class ChatCompletionPage extends StatefulWidget {
  const ChatCompletionPage({super.key});

  @override
  State<ChatCompletionPage> createState() => _ChatCompletionPageState();
}

class _ChatCompletionPageState extends State<ChatCompletionPage> {
  QuestionService questionService = QuestionService();
  String questionTest = '''{
  "title": "Colors Around Us",
  "questions": [
    {
      "questionText": "Coffee, please!",
      "type": "single_choice",
      "answers": [
        "Кафе, ве молам!",
        "Вода, ве молам!",
        "Да, океј",
        "Благодарам"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "I like milk",
      "type": "single_choice",
      "answers": [
        "Јас сакам млеко",
        "Јас сакам кафе",
        "Јас сакам чај",
        "Здраво!"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "Tea",
      "type": "single_choice",
      "answers": [
        "Чај",
        "Здраво",
        "Кафе",
        "Млеко"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "Good Afternoon",
      "type": "single_choice",
      "answers": [
        "Добар Ден",
        "Добро Вечер",
        "Добро Утро",
        "Добра Ноќ"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "Здраво!",
      "type": "listen_and_answer",
      "answers": [
        "Здраво!",
        "Чао!",
        "Добар ден!",
        "Добро вечер!"
      ],
      "correctAnswerIndex": 0
    }
  ],
  "questionsMatcher": [
    {
      "questions": [
        "Man",
        "Woman"
      ],
      "answers": [
        "Маж",
        "Жена"
      ],
      "areQuestionsImages": false
    },
    {
      "questions": [
        "Dog",
        "Cat"
      ],
      "answers": [
        "Куче",
        "Маче"
      ],
      "areQuestionsImages": false
    }
  ]
}
  ''';

  late ChatGpt chatGpt;
  String? answer;
  bool loading = false;
  final List<QuestionAnswer> questionAnswers = [];

  late TextEditingController textEditingController;

  StreamSubscription<CompletionResponse>? streamSubscription;
  StreamSubscription<StreamCompletionResponse>? chatStreamSubscription;

  bool didReceiveData = false;

  bool didAskQuestion = false;

  int lastLevel = 0;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    // API KEY HERE!!!
    chatGpt =
        ChatGpt(apiKey: "/");
    getLastLevel();
  }

  getLastLevel() async {
    lastLevel = await questionService.getQuizCollectionLength() + 1;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    chatStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!didReceiveData && didAskQuestion)
                const LinearProgressIndicator(),
              Image.asset('assets/images/quiz_logo_5_ai.png'),
              const SizedBox(height: 16),
              const Text(
                'Let Miki make a quiz for you!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: !didAskQuestion ? false : true,
                      controller: textEditingController,
                      decoration: const InputDecoration(hintText: 'Quiz Topic'),
                      onFieldSubmitted: (_) => _sendChatMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 16),
              didReceiveData
                  ? _parseJsonAnswer(questionAnswers.last.answer.toString())
                  : !didAskQuestion
                      ? AnswerButton(
                          answerText: 'Generate Quiz',
                          onTap: _sendChatMessage,
                          color: Colors.red,
                        )
                      : AnswerButton(
                          answerText: 'Generate Quiz',
                          onTap: () {},
                          color: Colors.grey,
                        ),
              const SizedBox(height: 16),
              AnswerButton(
                answerText: 'Go Back',
                onTap: () => Navigator.of(context).pop(),
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendChatMessage() async {
    final topic = textEditingController.text;
    didAskQuestion = true;
    didReceiveData = false;
    String question =
        '''You are an English to Macedonian Teacher.The questionText IS A WORD OR A VERY SHORT PHRASE IN ENGLISH and answers are TRANSLATIONS. Users will use this to help learn MACEDONIAN WORDS and SHORT PHRASES.  SPEAK MACEDONIAN STANDARD LANGUAGE USING MACEDONIAN GRAMMAR. You MUST NOT speak in Bulgarian or Serbian NEVER DO THAT.,  IT MUST BE MACEDONIAN Invent NEW QUESTIONS IN JSON using this format. STAY TO THE TOPIC $topic. The topic of the questions must be $topic. The level is $lastLevel. MAKE NEW QUESTIONS (RELATED TO THE TOPIC $topic).  DO NOT BREAK THE STRUCTURE OF THE QUIZ.  "areQuestionsImages": is ALWAYS FALSE.   "correctAnswerIndex": IS ALWAYS 0. Question Matchers ALWAYS HAVE SAME AMOUNT OF QUESTIONS AND ANSWERS. Make IT SIMPLE MEANT TO LEARN THE LANGUAGE, NOT A TRIVIA QUIZ. DO NOT SAY ANYTHING IF ITS INAPPROPRIATE OR NSFW. Questions that are of type "listen_and_answer" have one of the answers as the question in macedonian too, nothing else. Make the "title" catchy Structure:
    { 
  "title": "Colors Around Us",
  "questions": [
    {
      "questionText": "Coffee, please!",
      "type": "single_choice",
      "answers": [
        "Кафе, ве молам!",
        "Вода, ве молам!",
        "Да, океј",
        "Благодарам"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "I like milk",
      "type": "single_choice",
      "answers": [
        "Јас сакам млеко",
        "Јас сакам кафе",
        "Јас сакам чај",
        "Здраво!"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "Tea",
      "type": "single_choice",
      "answers": [
        "Чај",
        "Здраво",
        "Кафе",
        "Млеко"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "Good Afternoon",
      "type": "single_choice",
      "answers": [
        "Добар Ден",
        "Добро Вечер",
        "Добро Утро",
        "Добра Ноќ"
      ],
      "correctAnswerIndex": 0
    },
    {
      "questionText": "Здраво!",
      "type": "listen_and_answer",
      "answers": [
        "Здраво!",
        "Чао!",
        "Добар ден!",
        "Добро вечер!"
      ],
      "correctAnswerIndex": 0
    }
  ],
  "questionsMatcher": [
    {
      "questions": [
        "Man",
        "Woman"
      ],
      "answers": [
        "Маж",
        "Жена"
      ],
      "areQuestionsImages": false
    },
    {
      "questions": [
        "Dog",
        "Cat"
      ],
      "answers": [
        "Куче",
        "Маче"
      ],
      "areQuestionsImages": false
    }
  ],
    "level": $lastLevel
}
  ''';

    setState(() {
      textEditingController.clear();
      loading = true;
      questionAnswers.add(
        QuestionAnswer(
          question: question,
          answer: StringBuffer(),
        ),
      );
    });
    final testRequest = ChatCompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: [Message(role: Role.user.name, content: question)],
      model: ChatGptModel.gpt35Turbo,
    );
    await _chatStreamResponse(testRequest);

    setState(() => loading = false);
  }

  _chatStreamResponse(ChatCompletionRequest request) async {
    chatStreamSubscription?.cancel();
    try {
      final stream = await chatGpt.createChatCompletionStream(request);
      chatStreamSubscription = stream?.listen(
        (event) => setState(
          () {
            if (event.streamMessageEnd) {
              chatStreamSubscription?.cancel();
              didReceiveData = true;
              // didAskQuestion = false;
            } else {
              return questionAnswers.last.answer.write(
                event.choices?.first.delta?.content,
              );
            }
          },
        ),
      );
    } catch (error) {
      setState(() {
        loading = false;
        questionAnswers.last.answer.write("Error");
      });
      log("Error occurred: $error");
    }
  }

  bool isAdded = false;

  Widget _parseJsonAnswer(String answer) {
    print(answer);
    try {
      final json = jsonDecode(answer);
      final quiz = Quiz.fromMap(json as Map<String, dynamic>);
      if (!isAdded) {
        isAdded = true;
        questionService.addQuiz(quiz);
      }
      return AnswerButton(
        answerText: 'Start Quiz',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AIQuizStartScreen(
                quiz: quiz,
              ),
            ),
          );
        },
        color: Colors.red,
      );
    } catch (error) {
      return Text("Error occurred: $error");
    }
  }
}
