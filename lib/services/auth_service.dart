import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> login(email, password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> register(email, password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  void signOut() {
    _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  isUserLoggedIn() {
    var user = _auth.currentUser;
    return user != null;
  }
}
