import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WaterChartView extends StatefulWidget {
  const WaterChartView({Key? key}) : super(key: key);

  @override
  State<WaterChartView> createState() => _WaterChartViewState();
}

class _WaterChartViewState extends State<WaterChartView> {
  late Future<Map<String, double>> _waterDataFuture;

  @override
  void initState() {
    super.initState();
    _waterDataFuture = _fetchWaterData();
  }

  Future<Map<String, double>> _fetchWaterData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('water')
        .get();

    Map<String, double> data = {};

    for (var doc in snapshot.docs) {
      try {
        final dateKey = doc.id; // "2025-10-30"
        final parsedDate = DateTime.parse(dateKey);
        final current = (doc['currentWater'] ?? 0).toDouble();
        data[dateKey] = current;
      } catch (e) {
        debugPrint("Tarih parse hatası: $e");
      }
    }

    // Tarihe göre sırala
    final sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Sadece son 7 günü göster
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));
    final filtered = sortedEntries.where((entry) {
      final date = DateTime.parse(entry.key);
      return date.isAfter(sevenDaysAgo);
    });

    return Map.fromEntries(filtered);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _waterDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }

        final data = snapshot.data ?? {};
        if (data.isEmpty) {
          return const Center(child: Text('Su verisi bulunamadı.'));
        }

        final days = data.keys.toList();
        final values = data.values.toList();

        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < days.length) {
                        final day = DateTime.parse(days[index]);
                        return Text(
                          '${day.day}.${day.month}',
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(values.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i],
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.blueAccent,
                    ),
                  ],
                );
              }),
              gridData: FlGridData(show: true),
            ),
          ),
        );
      },
    );
  }
}
