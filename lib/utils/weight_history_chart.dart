import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/WeightEntry.dart';

class WeightHistoryChart extends StatelessWidget {
  final Stream<List<WeightEntry>>? stream;
  final double? goalWeight;

  const WeightHistoryChart({Key? key, required this.stream,required this.goalWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WeightEntry>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Grafik yüklenemedi: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Henüz kilo kaydı yok"));
        }

        final entries = snapshot.data!;
        if (entries.length < 1) {
          return const Center(child: Text("Grafik için en az 1 kayıt gerekli"));
        }

        // 🔹 Spot listesi oluştur
        List<FlSpot> spots = entries.map((entry) {
          return FlSpot(
            entry.date.millisecondsSinceEpoch.toDouble(),
            entry.weight,
          );
        }).toList();

        double minX = spots.first.x;
        double maxX = spots.last.x;
        double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 2;
        double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 2;

        // 🔹 Farkları hesapla (0 olmasın)
        double xRange = maxX - minX;
        double yRange = maxY - minY;
        if (xRange == 0) xRange = 1;
        if (yRange == 0) yRange = 1;

        return LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blueAccent.withOpacity(0.2),
                ),
              ),
            ],
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: goalWeight!,
                  color: Colors.green,
                  strokeWidth: 2,
                  dashArray: [6, 6],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    labelResolver: (line) => "Hedef: ${line.y.toStringAsFixed(1)} kg",
                  ),
                ),
              ],
            ),



            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: xRange / 4,
                  getTitlesWidget: (value, meta) {
                    final date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(
                      "${date.day}/${date.month}",
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: yRange / 4, // ✅ asla 0 değil
                  getTitlesWidget: (value, meta) =>
                      Text(value.toStringAsFixed(0)),
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: yRange / 4,
              verticalInterval: xRange / 4,
            ),
            borderData: FlBorderData(show: false),
          ),
        );
      },
    );
  }
}
