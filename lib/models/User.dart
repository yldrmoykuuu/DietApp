// lib/models/user_model.dart

class User {
  final String uid;
  final String email;
  final String? username; 

  User({
    required this.uid,
    required this.email,
    this.username,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}