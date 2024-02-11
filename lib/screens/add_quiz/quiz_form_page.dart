import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

class QuizFormPage extends StatefulWidget {
  const QuizFormPage({super.key});

  @override
  _QuizFormPageState createState() => _QuizFormPageState();
}

class _QuizFormPageState extends State<QuizFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _quizTitle;
  final List<Question> _questions = [];
  int _level = 1;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Create a list of maps from questions
        List<Map<String, dynamic>> questionsMapList =
            _questions.map((question) {
          return {
            'questionText': question.questionText,
            'answers': question.answers,
            'correctAnswerIndex': question.correctAnswerIndex,
          };
        }).toList();

        // Add form data to Firebase
        await FirebaseFirestore.instance.collection('quizzes').add({
          'title': _quizTitle,
          'questions': questionsMapList,
          'level': _level,
        });

        // Show success message or navigate to another page
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Quiz submitted successfully!'),
        ));
      } catch (error) {
        // Handle errors
        print('Error submitting quiz: $error');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to submit quiz. Please try again later.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Form'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Quiz Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title for the quiz';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _quizTitle = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Level'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the level';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _level = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Questions:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (int i = 0; i < 4; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Question ${i + 1}'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a question';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _questions.add(Question(value!, [], 0));
                          },
                        ),
                        const SizedBox(height: 10),
                        for (int j = 0; j < 4; j++)
                          Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText:
                                        'Answer ${j + 1} for question ${i + 1}'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a wrong answer';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _questions.last.answers.add(value!);
                                },
                              ),
                            ],
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Correct Answer Index',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the correct answer index';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _questions.last.correctAnswerIndex =
                                int.parse(value!);
                          },
                        ),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
