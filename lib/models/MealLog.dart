import 'package:cloud_firestore/cloud_firestore.dart';

class MealLog{
  final String yemekAdi;
  final String ogun;
  final double toplamKalori;
  final double toplamProtein;
  final double toplamYag;
  final Timestamp createdAt;

  MealLog({
    required this.yemekAdi,
    required this.ogun,
    required this.toplamKalori,
    required this.toplamYag,
    required this.toplamProtein,
    required this.createdAt,
});
  factory MealLog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MealLog(
      yemekAdi: data['yemekAdi'] ?? 'İsimsiz Yemek',
      ogun: data['ogun'] ?? 'Belirtilmemiş',
      toplamKalori: (data['toplamKalori'] ?? 0.0).toDouble(),
      toplamYag: (data['toplamYag'] ?? 0.0).toDouble(),
      toplamProtein: (data['toplamProtein'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}