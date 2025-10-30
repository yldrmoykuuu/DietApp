import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/UserProfile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String?> _handleAuthException(dynamic e) async {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'Şifre çok zayıf.';
        case 'email-already-in-use':
          return 'Bu e-posta adresi zaten kullanılıyor.';
        case 'user-not-found':
          return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
        case 'wrong-password':
          return 'Hatalı şifre.';
        default:
          return 'Bir hata oluştu: ${e.code}';
      }
    }

    if (e is FirebaseException) {
      return 'Veritabanı hatası: ${e.message}';
    }
    return 'Bilinmeyen bir hata oluştu: $e';
  }


  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return await _handleAuthException(e);
    }
  }


  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);


      final user = _auth.currentUser;
      if (user != null) {
        await saveUserData(user, username);
      }
      return null;
    } catch (e) {
      return await _handleAuthException(e);
    }
  }


  Future<String?> saveUserData(User user, String username) async {
    try {

      await _firestore.collection("users").doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'weight': null,
        'height': null,
        'age': null,
        'gender': null,
        'goal': null,
        'dietPreferences': [],
        'allergies': [],
      });
      return null;
    } catch (e) {
      print("AuthService Firestore Hata: $e");
      return "Temel kullanıcı verileri kaydedilirken hata oluştu.";
    }
  }
  Future<UserProfile?> getUserProfile() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      print("Aktif kullanıcı bulunamadı.");
      return null;
    }

    try {
      final docSnapshot =
      await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserProfile.fromMap(docSnapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print("Kullanıcı profili alınırken hata oluştu: $e");
      return null;
    }
  }


  Future<String?> updateProfileData(String uid, Map<String, dynamic> profileData) async {
    try {
      await _firestore.collection("users").doc(uid).set(
        profileData,
        SetOptions(merge: true),
      );
      return null;
    } catch (e) {
      print("AuthService Profil Güncelleme Hata: $e");
      return await _handleAuthException(e);
    }
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
  Future<String?> logAndUpdateWeight(String uid,double newWeight) async{
    try{
      final now=FieldValue.serverTimestamp();
      final DateTime clientTime=DateTime.now();

      final String docId=clientTime.toIso8601String();
      final newLogEntryRef=_firestore
      .collection("users")
      .doc(uid)
      .collection('weightHistory')
      .doc(docId);
      await newLogEntryRef.set({
        'weight':newWeight,
        'date':now,
      });
      await _firestore.collection('users').doc(uid).set({
        'weight':newWeight,
        'updatedAt':now,
      },
        SetOptions(merge: true),
      );
      return null;
    }catch(e){
      return await _handleAuthException(e);
    }
  }
}
