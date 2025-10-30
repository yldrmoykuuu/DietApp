import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntry {

  final DateTime date;
  final double weight;


  WeightEntry({
    required this.date,
    required this.weight,

  });


  factory WeightEntry.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


    return WeightEntry(
      date: (data['date'] as Timestamp).toDate(),
      weight: (data['weight'] as num).toDouble(),

    );
  }
}