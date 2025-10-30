import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tarihi "yyyy-MM-dd" formatında döndürür
  String _getTodayDocId() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  /// 🔹 Öğünü kaydet — tarih klasörü altına
  Future<void> kaydetYemek({
    required String yemekAdi,
    required String ogun,
    required double toplamKalori,
    required double toplamProtein,
    required double toplamYag,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Kullanıcı oturumu bulunamadı!");

    final todayId = _getTodayDocId();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .doc(todayId) // 🔸 Gün klasörü
        .collection('ogunler') // 🔸 Alt koleksiyon
        .add({
      'yemekAdi': yemekAdi,
      'ogun': ogun,
      'toplamKalori': toplamKalori,
      'toplamProtein': toplamProtein,
      'toplamYag': toplamYag,
      'createdAt': DateTime.now(),
    });
  }

  /// 🔹 Günlük özet (bugünün tarih klasöründen)
  Future<Map<String, dynamic>> getGunlukOzet() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Kullanıcı oturumu bulunamadı!");

    final todayId = _getTodayDocId();

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .doc(todayId)
        .collection('ogunler')
        .get();

    double toplamKalori = 0;
    double toplamProtein = 0;
    double toplamYag = 0;
    List<Map<String, dynamic>> gunlukOgunlerListesi = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      gunlukOgunlerListesi.add(data);

      toplamKalori += (data['toplamKalori'] ?? 0).toDouble();
      toplamProtein += (data['toplamProtein'] ?? 0).toDouble();
      toplamYag += (data['toplamYag'] ?? 0).toDouble();
    }

    return {
      'kalori': toplamKalori,
      'protein': toplamProtein,
      'yag': toplamYag,
      'ogunler': gunlukOgunlerListesi,
    };
  }


  Stream<QuerySnapshot> kullaniciYemekleri() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Kullanıcı oturumu bulunamadı!");

    final todayId = _getTodayDocId();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .doc(todayId)
        .collection('ogunler')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
