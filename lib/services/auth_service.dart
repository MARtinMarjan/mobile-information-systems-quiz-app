import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Login Error: $e");
      rethrow;
    }
  }

  Future<UserCredential> register(String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
        'username': username,

        'level': 1,
        'points': 0,
        'correct_answers': 0,
        'incorrect_answers': 0,
      });

      return userCredential;
    } catch (e) {
      print("Registration Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return user;
      }
    } catch (e) {
      print(e);
    }
    return _auth.currentUser!;
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
