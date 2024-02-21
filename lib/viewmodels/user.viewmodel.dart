import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/leaderboard_service.dart';

class UserViewModel extends ChangeNotifier {
  final AuthService _authService;
  final DBService _dbService;

  User? _user;
  QuizUserData? _userData;
  int _streakCount = 0;
  late DateTime _lastOpenedDate;

  UserViewModel({
    required AuthService authService,
    required DBService dbService,
    required LeaderboardService leaderboardService,
  })  : _authService = authService,
        _dbService = dbService;

  User? get user => _user;

  QuizUserData? get userData => _userData;

  int get streakCount => _streakCount;

  DateTime get lastOpenedDate => _lastOpenedDate;

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
      _userData = await _dbService.getUserData(_user!.uid).then((value) {
        return value;
      });
      notifyListeners();
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

  Future<void> saveProfile(String newUsername, Uint8List image) async {
    if (_user != null) {
      String resp = await _dbService.saveData(
          username: newUsername, file: image, uid: _user!.uid);
      if (resp == "success") {
        _userData = await _dbService.getUserData(_user!.uid);
        notifyListeners();
      }
    }
  }

  void resetProgress() {
    if (_user != null) {
      _dbService.resetProgress(_user!.uid);
      _dbService.updateStreakCount(_user!.uid, _streakCount + 1);
      _streakCount = 0;
      loadUserData();
      notifyListeners();
    }
  }

  Future<void> checkoutActivityStreak() async {
    if (_user != null) {
      _dbService.getLastOpenedDate(_user!.uid).then((value) {
        _lastOpenedDate = value;
        // Check if streak needs to be reset
        if (!isYesterday(_lastOpenedDate, DateTime.now()) &&
            !isToday(_lastOpenedDate, DateTime.now())) {
          _dbService.resetStreakCount(_user!.uid);
          _streakCount = 0;
        }
      });
    }
  }

  Future<void> updateStreak() async {
    if (_user != null) {
      _dbService.getLastOpenedDate(_user!.uid).then((value) {
        _lastOpenedDate = value;
        // Check if streak needs to be reset
        if (!isYesterday(_lastOpenedDate, DateTime.now()) &&
            !isToday(_lastOpenedDate, DateTime.now())) {
          _dbService.resetStreakCount(_user!.uid).then((value) => {
                _dbService.updateStreakCount(_user!.uid, _streakCount + 1),
              });
          _streakCount = 0;
        }
        //if streak has been updated today, don't update it again
        if (!isToday(_lastOpenedDate, DateTime.now())) {
          _dbService.updateStreakCount(_user!.uid, _streakCount + 1);
          _streakCount++;
          _lastOpenedDate = DateTime.now();
        }
      });
    }

    notifyListeners();
  }
}

bool isYesterday(DateTime date1, DateTime date2) {
  return date1.day == date2.day - 1 &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

bool isToday(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}
