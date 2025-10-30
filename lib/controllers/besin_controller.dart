import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/Meal.dart';


class BesinController extends ChangeNotifier {
  List<Besin> _tumBesinler = [];
  String _aramaSorgusu = "";


  BesinController() {
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    final String rawData = await rootBundle.loadString("assets/recipes.json");
    final Map<String, dynamic> jsonData = json.decode(rawData);

    List<Besin> geciciListe = [];

    final Map<String, dynamic> ingredientData = jsonData['Ingredient'] ?? {};

    ingredientData.forEach((key, value) {
      geciciListe.add(Besin.fromMap(key, value as Map<String, dynamic>));
    });

    _tumBesinler = geciciListe;
    notifyListeners();
  }

  List<Besin> get gosterilecekBesinler {
    if (_aramaSorgusu.isEmpty) return _tumBesinler;
    return _tumBesinler
        .where((besin) =>
        besin.turkceAd.toLowerCase().contains(_aramaSorgusu))
        .toList();
  }

  List<String> get tumBesinTurkceAdlari {
    return _tumBesinler.map((besin) => besin.turkceAd).toList();
  }

  List<Besin> get seciliBesinler {
    return _tumBesinler.where((besin) => besin.isSelected).toList();
  }

  double get toplamKalori =>
      seciliBesinler.fold(0.0, (sum, besin) => sum + besin.kalori);
  double get toplamYag =>
      seciliBesinler.fold(0.0, (sum, besin) => sum + besin.yag);
  double get toplamProtein =>
      seciliBesinler.fold(0.0, (sum, besin) => sum + besin.protein);


  void filtreleBesinleri(String sorgu) {
    _aramaSorgusu = sorgu.toLowerCase().trim();
    notifyListeners();
  }

  void toggleBesinSecimi(Besin besin) {
    besin.isSelected = !besin.isSelected;
    notifyListeners();
  }

  void tumSecimleriTemizle() {
    for (var besin in _tumBesinler) {
      besin.isSelected = false;
    }
    notifyListeners();
  }
}
