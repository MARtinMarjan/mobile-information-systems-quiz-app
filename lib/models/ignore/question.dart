import 'option.dart';

class Question {
  String text;
  List<Option> options;
  Question({ required this.options, required this.text });

  // Question.fromMap(Map data) {
  //   text = data['text'] ?? '';
  //   options = (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
  // }
}