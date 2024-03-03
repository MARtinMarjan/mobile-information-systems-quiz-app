import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/lesson.dart';

class LessonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoaded = true;

  Future<List<Lesson>> getAllLessons() async {
    isLoaded = false;
    try {
      final lessons = await _firestore.collection('lessons').get();
      return lessons.docs.map((lesson) {
        return Lesson.toMap(lesson.data());
      }).toList();
    } catch (e) {
      print("Get All Lessons Error: $e");
      rethrow;
    }
    finally {
      isLoaded = true;
    }
  }
}
