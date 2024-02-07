import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/quiz.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Quiz?> getQuizByLevel(int level) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('quizzes')
          .where('level', isEqualTo: level)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      // Get the first document and convert it to a Quiz object
      Quiz quiz = Quiz.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      return quiz;
    } catch (error) {
      // Handle errors
      print('Error fetching quiz: $error');
      return null;
    }
  }


}
