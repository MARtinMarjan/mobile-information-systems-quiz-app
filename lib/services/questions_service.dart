import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/quiz.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getQuizCollectionLength() async {
    try {
      var snapshot = await _firestore.collection('quizzes').count().get();
      return snapshot.count ?? -1;
    } catch (error) {
      return -1;
    }
  }

  addQuiz(Quiz quiz) async {
    try {
      await _firestore.collection('quizzes').add(quiz.toMap());
    } catch (error) {
      print('Error adding quiz: $error');
    }
  }

  Future<Quiz?> getQuizByLevel(int level) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(
              'quizzes') // Make sure this matches your actual collection path
          .where('level', isEqualTo: level)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // No quiz found for the given level
        return null;
      }

      // Get the first document
      var documentSnapshot = querySnapshot.docs.first;

      // Check if document exists
      if (!documentSnapshot.exists) {
        // Document does not exist
        return null;
      }

      print(documentSnapshot.data());

      // Convert document data to a Quiz object
      Quiz quiz = Quiz.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      return quiz;
    } catch (error) {
      // Handle errors
      print('Error fetching quiz: $error');
      return null;
    }
  }
}
