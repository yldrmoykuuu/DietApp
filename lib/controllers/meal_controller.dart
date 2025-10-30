import 'package:flutter/material.dart';
import '../services/meal_service.dart';

class MealController extends ChangeNotifier {
  final MealService _mealService = MealService();
  bool isLoading = false;

  double toplamKalori = 0;
  double toplamProtein = 0;
  double toplamYag = 0;

  List<Map<String, dynamic>> bugunkuOgunler = [];
  Future<void> kaydet({
    required String yemekAdi,
    required String ogun,
    required double toplamKalori,
    required double toplamProtein,
    required double toplamYag,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _mealService.kaydetYemek(
        yemekAdi: yemekAdi,
        ogun: ogun,
        toplamKalori: toplamKalori,
        toplamProtein: toplamProtein,
        toplamYag: toplamYag,
      );

      await getGunlukVeri();

    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("🔥 Firebase'e kaydetme hatası: $e");
      rethrow;
    }
  }




  Future<void> getGunlukVeri() async {
    try {
      isLoading = true;
      notifyListeners();

      final veri = await _mealService.getGunlukOzet();

      toplamKalori = veri['kalori'] ?? 0;
      toplamProtein = veri['protein'] ?? 0;
      toplamYag = veri['yag'] ?? 0;




      final List<Map<String, dynamic>> hamOgunListesi =
          (veri['ogunler'] as List?)?.cast<Map<String, dynamic>>() ?? [];


      bugunkuOgunler = hamOgunListesi.map((hamOgun) {
        return {
          'isim': hamOgun['yemekAdi'],      // 'yemekAdi' anahtarını 'isim'e çevir
          'ogun': hamOgun['ogun'],
          'kalori': hamOgun['toplamKalori'], // 'toplamKalori' anahtarını 'kalori'ye çevir
          'protein': hamOgun['toplamProtein'],// 'toplamProtein' anahtarını 'protein'e çevir
          'yag': hamOgun['toplamYag']      // 'toplamYag' anahtarını 'yag'a çevir
        };
      }).toList(); // .map() bir 'Iterable' döner, .toList() ile Listeye çeviririz.

      // ------------------- DEĞİŞİKLİK BURADA BİTİYOR -------------------

      isLoading = false;
      notifyListeners(); // Şimdi widget'a "Veri hazır!" diye haber ver
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("🔥 Günlük veri alma hatası: $e");
      rethrow;
    }
  }
}

