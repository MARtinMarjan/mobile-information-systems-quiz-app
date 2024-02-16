import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class DBService {
  final CollectionReference userCollection;

  DBService() : userCollection = FirebaseFirestore.instance.collection('users');

  Stream<DocumentSnapshot> userData(String uid) {
    return userCollection.doc(uid).snapshots();
  }

  Future<void> addUserQuizStats(String uid, int level, int points,
      int correctAnswers, int incorrectAnswers) async {
    int currentLevel = await getCurrentLevel(uid);

    try {
      await userCollection.doc(uid).set({
        'level': currentLevel + 1,
        'points': points,
        'correct_answers': correctAnswers,
        'incorrect_answers': incorrectAnswers,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error adding user quiz stats: $e");
      rethrow;
    }
  }

  Future<int> getCurrentLevel(String uid) async {
    try {
      final DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      return userDoc.get('level');
    } catch (e) {
      print("Error getting current level: $e");
      rethrow;
    }
  }

  Future<int> getCurrentPoints(String uid) async {
    try {
      final DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      return userDoc.get('points');
    } catch (e) {
      print("Error getting current points: $e");
      rethrow;
    }
  }

  Future<QuizUserData> getUserData(String uid) async {
    try {
      final DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      return QuizUserData.fromMap(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print("Error getting user data: $e");
      rethrow;
    }
  }

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = storage.ref().child(childName);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(
      {required String username, required Uint8List file, required uid}) async {
    String resp = "Error occured";
    try {
      if (username.isNotEmpty) {
        String imageUrl = await uploadImageToStorage("ProfileImage", file);
        await firestore.collection('users').doc(uid).set({
          'username': username,
          'image_link': imageUrl,
        }, SetOptions(merge: true));
        resp = "success";
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  void resetProgress(String uid) {
    userCollection.doc(uid).set({
      'level': 1,
      'points': 0,
      'correct_answers': 0,
      'incorrect_answers': 0,
    }, SetOptions(merge: true));
  }
}
