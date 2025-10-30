import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final double baslangicKilo;
  final DateTime baslangicTarihi;
  final DateTime guncelTarih;
  final double guncelKilo;

  Goal({
    required this.baslangicKilo,
    required this.baslangicTarihi,
    required this.guncelTarih,
    required this.guncelKilo,
  });

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      baslangicKilo: (map['baslangicKilo'] as num).toDouble(),
      baslangicTarihi: (map['baslangicTarihi'] as Timestamp).toDate(),
      guncelTarih: (map['guncelTarih'] as Timestamp).toDate(),
      guncelKilo: (map['guncelKilo'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baslangicKilo': baslangicKilo,
      'baslangicTarihi': Timestamp.fromDate(baslangicTarihi),
      'guncelTarih': Timestamp.fromDate(guncelTarih),
      'guncelKilo': guncelKilo,
    };
  }


  Goal copyWith({
    double? baslangicKilo,
    DateTime? baslangicTarihi,
    DateTime? guncelTarih,
    double? guncelKilo,
  }) {
    return Goal(
      baslangicKilo: baslangicKilo ?? this.baslangicKilo,
      baslangicTarihi: baslangicTarihi ?? this.baslangicTarihi,
      guncelTarih: guncelTarih ?? this.guncelTarih,
      guncelKilo: guncelKilo ?? this.guncelKilo,
    );
  }
}