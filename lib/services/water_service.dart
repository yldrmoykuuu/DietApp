import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterService{
   final FirebaseFirestore _firestore=FirebaseFirestore.instance;
   final FirebaseAuth _auth =FirebaseAuth.instance;

   String _getTodayDocId() {
     final now = DateTime.now();
     return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
   }


   DocumentReference _getTodaysWaterDocRef() {
     final user = _auth.currentUser;
     if (user == null) throw Exception("Kullanıcı bulunamadı");

     final docId = _getTodayDocId(); // '2025-10-20'
     return _firestore
         .collection('users')
         .doc(user.uid)
         .collection('water')
         .doc(docId);
   }
   Future<double> getTodaysWater() async {
     try {
       final doc = await _getTodaysWaterDocRef().get();
       if (doc.exists && doc.data() != null) {
         final data = doc.data() as Map<String, dynamic>;
         return (data['currentWater'] ?? 0.0).toDouble();
       }
       return 0.0;
     } catch (e){
       print("su verisi alınamadı:$e");
       return 0.0;
     }
   }
   Future<void> updateTodaysWater(double newAmount) async {
     try{
       await _getTodaysWaterDocRef().set(
         {
           'currentWater':newAmount,
           'goalWater':2.5,
           'lastUpdated':FieldValue.serverTimestamp(),
         },
         SetOptions(merge: true),


       );

     }catch(e){
       print("su verisi güncellenemedi:$e");
     }
   }
}
