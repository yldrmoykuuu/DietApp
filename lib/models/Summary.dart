class Meal {
  final String id;
  final String title;
  final String subtitle;
  final String kcal;
  final String icon;
  final List<int> colors;

  Meal({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kcal,
    required this.icon,
    required this.colors,
  });

  factory Meal.fromMap(Map<String, dynamic> data, String documentId) {
    return Meal(
      id: documentId,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      kcal: data['kcal'] ?? '',
      icon: data['icon'] ?? 'fastfood',
      colors: List<int>.from(data['colors'] ?? [0xFF89F7FE, 0xFF66A6FF]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'kcal': kcal,
      'icon': icon,
      'colors': colors,
    };
  }
}
