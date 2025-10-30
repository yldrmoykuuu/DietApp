class UserProfile {
  String? id;
  double? weight;
  double? height;
  int? age;
  String? gender;
  String? goal;
  List<String>? dietPreferences;
  List<String>? allergies;
  String? photoUrl;
double? weightGoal;

  UserProfile({
    this.id,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.goal,
    this.dietPreferences,
    this.allergies,
    this.photoUrl,
    this.weightGoal,
  });

  Map<String,dynamic> toJson(){
    return{
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'goal': goal,
      'dietPreferences': dietPreferences,
      'allergies': allergies,
      'weightGoal':weightGoal,

    };
  }
  factory UserProfile.fromMap(Map<String, dynamic> json) {
    final weightData = json['weight'];
    final heightData = json['height'];
    final ageData = json['age'];
    final weightGoalData = json['weightGoal'];

    return UserProfile(
      weight: weightData is num ? weightData.toDouble() : null,
      height: heightData is num ? heightData.toDouble() : null,

      age: ageData is num ? ageData.toInt() : null,

      gender: json['gender'],
      goal: json['goal'],
      dietPreferences: List<String>.from(json['dietPreferences'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      photoUrl: json['photoUrl'],
      weightGoal: weightGoalData is num ? weightGoalData.toDouble() : null,    );
  }

}