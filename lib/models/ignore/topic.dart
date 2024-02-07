import '../../screens/quiz/quiz.dart';

class Topic {
  final String id;
  final String title;
  final String description;
  final String img;
  final List<Quiz> quizzes;

  Topic(
      {required this.id,
      required this.title,
      required this.description,
      required this.img,
      required this.quizzes});

// factory Topic.fromMap(Map data) {
//   return Topic(
//     id: data['id'] ?? '',
//     title: data['title'] ?? '',
//     description: data['description'] ?? '',
//     img: data['img'] ?? 'default.png',
//     quizzes:  (data['quizzes'] as List ?? []).map((v) => Quiz.fromMap(v)).toList(), //data['quizzes'],
//   );
// }
}
