import 'package:flutter/material.dart';
import 'package:healty/models/UserProfile.dart';
import 'package:healty/services/goal_service.dart';

import '../models/WeightEntry.dart';
import 'auth_service.dart';  // Grafik stream'i için

class GoalController with ChangeNotifier {
  final AuthService _authService = AuthService();
  final GoalService _goalService = GoalService();

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  Stream<List<WeightEntry>>? _historyStream;
  Stream<List<WeightEntry>>? get historyStream => _historyStream;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;


  GoalController() {

    loadData();
  }


  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      _userProfile = await _authService.getUserProfile();
      if (_userProfile == null) {
        _error = "Kullanıcı profili bulunamadı";
      }


      _historyStream = _goalService.getWeightHistoryStream();

    } catch (e) {
      _error = "Bir hata oluştu: $e";
    }

    _isLoading = false;
    notifyListeners();
  }


}