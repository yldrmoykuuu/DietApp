// controllers/water_controller.dart

import 'package:flutter/cupertino.dart';

import '../services/water_service.dart';

class WaterController extends ChangeNotifier {
  final WaterService _waterService = WaterService();

  bool isLoading = false;
  double currentWater = 0.0;
  final double goalWater = 2.5;
  final double glassOfWater = 0.25;

  Future<void> fetchTodaysWater() async {
    isLoading = true;
    notifyListeners();

    currentWater = await _waterService.getTodaysWater();

    isLoading = false;
    notifyListeners();
  }


  Future<void> addWater() async {
    if (currentWater < goalWater) {
      currentWater += glassOfWater;
      if (currentWater > goalWater) {
        currentWater = goalWater;
      }

      notifyListeners();

      await _waterService.updateTodaysWater(currentWater);
    }
  }


  Future<void> removeWater() async {
    if (currentWater > 0) {
      currentWater -= glassOfWater;
      if (currentWater < 0) {
        currentWater = 0;
      }


      notifyListeners();


      await _waterService.updateTodaysWater(currentWater);
    }
  }
}