import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  User? get user=> _user;
  Future<void> fetchUserData() async {
    final firebaseUser=_auth.currentUser;
    if(firebaseUser!=null){
      final snapshots=await _firestore.collection("users").doc(firebaseUser.uid).get();
      if(snapshots.exists){
        _user=firebaseUser;
        notifyListeners();
      }
    }
  }
  void signOut() async{
    await _auth.signOut();
    _user=null;
    notifyListeners();
  }
}