import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healty/models/WeightEntry.dart';
import 'package:line_icons/line_icon.dart';

class GoalService{
  final FirebaseFirestore _db=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String? get _uid =>_auth.currentUser?.uid;



  Stream<List<WeightEntry>> getWeightHistoryStream(){
    final uid=_uid;
    if(uid==null){
      return Stream.value([]);
    }

    final collectionRef = _db
        .collection('users')
        .doc(uid)
        .collection('weightHistory')

        .orderBy('date', descending: false);
    return collectionRef.snapshots().map((snapshot){
      return snapshot.docs
          .map((doc)=>WeightEntry.fromSnapshot(doc))
          .toList();
    });

  }
}