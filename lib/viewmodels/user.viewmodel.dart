import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';

class UserViewModel extends ChangeNotifier {
  final AuthService _authService;
  final DBService _dbService;

  User? _user;
  QuizUserData? _userData;

  UserViewModel(
      {required AuthService authService, required DBService dbService})
      : _authService = authService,
        _dbService = dbService;

  User? get user => _user;

  QuizUserData? get userData => _userData;

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _authService.login(email, password);
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      print("Login Error: $e");
      rethrow;
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
    notifyListeners();
  }

  bool isLoggedIn() {
    return _authService.isLoggedIn();
  }

  Future<void> loadUserData() async {
    if (_user != null) {
      _userData = await _dbService.getUserData(_user!.uid);
      notifyListeners();
    }
  }

  Future<void> addUserQuizStats(
      int level, int points, int correctAnswers, int incorrectAnswers) async {
    if (_user != null) {
      await _dbService.addUserQuizStats(
        _user!.uid,
        level,
        points,
        correctAnswers,
        incorrectAnswers,
      );
      await loadUserData(); // Reload user data after updating stats
    }
  }
}
