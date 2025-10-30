class DietItem {
  final String food;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  DietItem({
    required this.food,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory DietItem.fromMap(Map<String, dynamic> m) {
    return DietItem(
      food: m['food'] ?? '',
      calories: (m['calories'] ?? 0).toDouble(),
      protein: (m['protein'] ?? 0).toDouble(),
      carbs: (m['carbs'] ?? 0).toDouble(),
      fat: (m['fat'] ?? 0).toDouble(),
    );
  }
}

class MealPlan {
  final String name;
  final List<DietItem> items;

  MealPlan({required this.name, required this.items});

  factory MealPlan.fromMap(Map<String, dynamic> m) {
    return MealPlan(
      name: m['name'] ?? '',
      items: (m['items'] as List<dynamic>? ?? [])
          .map((e) => DietItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class DietPlan {
  final double dailyCalories;
  final List<MealPlan> meals;

  DietPlan({required this.dailyCalories, required this.meals});

  factory DietPlan.fromMap(Map<String, dynamic> m) {
    return DietPlan(
      dailyCalories: (m['dailyCalories'] ?? 0).toDouble(),
      meals: (m['meals'] as List<dynamic>? ?? [])
          .map((e) => MealPlan.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
