class Besin {
  final String id;
  final String turkceAd;
  final String ingilizceAd;
  final double kalori;
  final double protein;
  final double yag;
  final double karbonhidrat;
  bool isSelected;

  Besin({
    required this.id,
    required this.turkceAd,
    required this.ingilizceAd,
    required this.kalori,
    required this.protein,
    required this.yag,
    required this.karbonhidrat,
    this.isSelected = false
  });

  factory Besin.fromMap(String id, Map<String, dynamic> map) {
    print("map içeriği: $map");
    return Besin(
      id: id,
      turkceAd: map['Turkish Name'] ?? 'N/A',
      ingilizceAd: map['English Name'] ?? 'N/A',
      kalori: double.tryParse(map['Calorie']?.toString() ?? '0') ?? 0.0,
      protein: double.tryParse(map['Protein']?.toString() ?? '0') ?? 0.0,
      yag: double.tryParse(map['Fat']?.toString() ?? '0') ?? 0.0,
      karbonhidrat: double.tryParse(map['Carbohydrates']?.toString() ?? '0') ?? 0.0,
    );
  }
}