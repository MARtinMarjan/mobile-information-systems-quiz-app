import 'package:quiz_app/models/ignore/question.dart';

class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {required this.title,
      required this.questions,
      required this.video,
      required this.description,
      required this.id,
      required this.topic});

// factory Quiz.fromMap(Map data) {
//   return Quiz(
//       id: data['id'] ?? '',
//       title: data['title'] ?? '',
//       topic: data['topic'] ?? '',
//       description: data['description'] ?? '',
//       video: data['video'] ?? '',
//       questions: (data['questions'] as List ?? []).map((v) => Question.fromMap(v)).toList()
//   );
// }
}
