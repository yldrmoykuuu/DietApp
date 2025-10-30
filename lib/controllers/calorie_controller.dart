import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // DateUtils için
import 'package:intl/intl.dart'; // DateFormat için

class CalorieController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<Map<DateTime, int>> getCalorieHistory(int daysToFetch) async {
    final String? userId = _userId;
    if (userId == null) {
      print("Kullanıcı giriş yapmamış.");
      return {};
    }

    final Map<DateTime, int> dailyTotals = {};
    final DateTime now = DateUtils.dateOnly(DateTime.now());
    final DateTime startDate = now.subtract(Duration(days: daysToFetch - 1));

    for (int i = 0; i < daysToFetch; i++) {
      final DateTime day = startDate.add(Duration(days: i));
      dailyTotals[day] = 0;
    }

    for (final day in dailyTotals.keys) {
      final String docIdDate = DateFormat('yyyy-MM-dd').format(day);

      final QuerySnapshot mealSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('meals')
          .doc(docIdDate)
          .collection('ogunler')
          .get();

      int totalCaloriesForThisDay = 0;

      for (var mealDoc in mealSnapshot.docs) {
        final data = mealDoc.data() as Map<String, dynamic>;

        if (data.containsKey('toplamKalori')) {
          totalCaloriesForThisDay += (data['toplamKalori'] as num).toInt();
        }
      }

      dailyTotals[day] = totalCaloriesForThisDay;

      if (totalCaloriesForThisDay > 0) {
        print("OKUNDU: $docIdDate için toplam $totalCaloriesForThisDay kalori bulundu.");
      }
    }

    print("Oluşturulan Grafik Verisi: $dailyTotals");
    return dailyTotals;
  }


  Future<Map<String, double>> getMacroTotals(int daysToFetch) async {
    final String? userId = _userId;
    if (userId == null) {
      print("Kullanıcı giriş yapmamış.");
      return {};
    }

    final DateTime now = DateUtils.dateOnly(DateTime.now());
    final DateTime startDate = now.subtract(Duration(days: daysToFetch - 1));

    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;

    for (int i = 0; i < daysToFetch; i++) {
      final DateTime day = startDate.add(Duration(days: i));
      final String docIdDate = DateFormat('yyyy-MM-dd').format(day);

      final QuerySnapshot mealSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('meals')
          .doc(docIdDate)
          .collection('ogunler')
          .get();

      for (var mealDoc in mealSnapshot.docs) {
        final data = mealDoc.data() as Map<String, dynamic>;

        // Alan adlarınıza göre (toplamKalori, toplamProtein, toplamYag)
        if (data.containsKey('toplamKalori')) {
          totalCalories += (data['toplamKalori'] as num).toDouble();
        }
        if (data.containsKey('toplamProtein')) {
          totalProtein += (data['toplamProtein'] as num).toDouble();
        }
        if (data.containsKey('toplamYag')) {
          totalFat += (data['toplamYag'] as num).toDouble();
        }
      }
    }

    final double proteinCalories = totalProtein * 4;
    final double fatCalories = totalFat * 9;

    double carbCalories = totalCalories - (proteinCalories + fatCalories);


    if (carbCalories < 0) {
      carbCalories = 0;
    }


    return {
      'protein': proteinCalories,
      'fat': fatCalories,
      'carbs': carbCalories,
    };
  }

}