import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../utils/date_checkers.dart';

class UserViewModel extends ChangeNotifier {
  final AuthService _authService;
  final DBService _dbService;

  User? _user;

  User? get user => _user;
  QuizUserData? _userData;

  QuizUserData? get userData => _userData;
  int _streakCount = 0;

  int get streakCount => _streakCount;
  late DateTime _lastOpenedDate;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserViewModel({
    required AuthService authService,
    required DBService dbService,
  })  : _authService = authService,
        _dbService = dbService;

  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential = await _authService.login(email, password);
      _user = userCredential.user;
      notifyListeners();
      return "success";
    } catch (e) {
      print("Login Error: $e");
      rethrow;
    }
  }

  // if user doesnt exist create a new user
  //I/flutter (28582): Error getting user data: type 'Null' is not a subtype of type 'Map<String, dynamic>' in type cast
  // E/flutter (28582): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: type 'Null' is not a subtype of type 'Map<String, dynamic>' in type cast
  // E/flutter (28582): #0      DBService.getUserData (package:quiz_app/services/db_service.dart:59:50)
  // E/flutter (28582): <asynchronous suspension>
  // E/flutter (28582): #1      UserViewModel.loadUserData (package:quiz_app/viewmodels/user.viewmodel.dart:109:19)
  // E/flutter (28582): <asynchronous suspension>
  // E/flutter (28582): #2      UserViewModel.googleSignUp (package:quiz_app/viewmodels/user.viewmodel.dart:72:9)
  // E/flutter (28582): <asynchronous suspension>
  // E/flutter (28582):
  Future<void> googleSignUp(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await _authService.signInWithCredential(credential);
      _user = userCredential.user;
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _authService.registerGoogleUser(userCredential);
      } else {
        await loadUserData();
      }
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _authService.register(email, password, username);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      print("Registration Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _streakCount = 0;
    _userData = null;

    notifyListeners();
  }

  bool isLoggedIn() {
    return _authService.isLoggedIn();
  }

  Future<void> loadUserData() async {
    // if (isLoading) {
    //   return;
    // }
    if (_user != null) {
      isLoading = true;
      _userData = await _dbService.getUserData(_user!.uid);
      notifyListeners();
      isLoading = false;
    }
  }

  Future<void> addUserQuizStats(
      int level, int points, int correctAnswers, int incorrectAnswers) async {
    if (_user != null) {
      await _dbService.addUserQuizStats(
        _user!.uid,
        level,
        _userData!.points + points,
        _userData!.correctAnswers + correctAnswers,
        _userData!.incorrectAnswers + incorrectAnswers,
      );
      await loadUserData(); // Reload user data after updating stats
    }
    await loadUserData().then((value) => notifyListeners());
  }

  Future<void> saveProfile(String newUsername, Uint8List? image) async {
    if (_user != null) {
      isLoading = true;
      String resp = await _dbService.saveData(
          username: newUsername, file: image, uid: _user!.uid);
      if (resp == "success") {
        _userData = await _dbService.getUserData(_user!.uid);
      }
      notifyListeners();
      isLoading = false;
    }
  }

  void resetProgress() {
    if (_user != null) {
      _dbService.resetProgress(_user!.uid);
      _dbService.updateStreakCount(
          _user!.uid, 0, DateTime.now().subtract(const Duration(days: 1)));
      _streakCount = 0;
      loadUserData();
      notifyListeners();
    }
  }

  Future<void> checkoutActivityStreak() async {
    if (_user != null) {
      isLoading = true;
      _dbService.getLastOpenedDate(_user!.uid).then((value) {
        _lastOpenedDate = value;
        // Check if streak needs to be reset
        if (!isYesterday(_lastOpenedDate, DateTime.now()) &&
            !isToday(_lastOpenedDate, DateTime.now())) {
          _dbService.resetStreakCount(_user!.uid);
          _lastOpenedDate = DateTime.now().subtract(const Duration(days: 1));
          _streakCount = 0;
        }
      });
      notifyListeners();
      isLoading = false;
    }
  }

  Future<void> updateStreak() async {
    if (_user != null) {
      isLoading = true;
      _dbService.getLastOpenedDate(_user!.uid).then((value) {
        _lastOpenedDate = value;
        // Check if streak needs to be reset
        if (!isYesterday(_lastOpenedDate, DateTime.now()) &&
            !isToday(_lastOpenedDate, DateTime.now())) {
          _dbService.resetStreakCount(_user!.uid).then((value) => {
                _dbService.updateStreakCount(_user!.uid, 1,
                    DateTime.now().subtract(const Duration(days: 1))),
              });
          _streakCount = 1;
        }
        // Check if streak needs to be updated
        else if (!isToday(_lastOpenedDate, DateTime.now())) {
          _dbService.updateStreakCount(
              _user!.uid, _streakCount + 1, DateTime.now());
          _streakCount++;
          _lastOpenedDate = DateTime.now();
        }
      });
      notifyListeners();
      isLoading = false;
    }
  }
}
