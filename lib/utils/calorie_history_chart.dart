import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:healty/controllers/calorie_controller.dart';
import 'package:intl/intl.dart';

class CalorieChartView extends StatefulWidget {
  final int daysToShow;
  const CalorieChartView({Key? key, this.daysToShow = 7}) : super(key: key);
  @override
  _CalorieChartViewState createState() => _CalorieChartViewState();
}

class _CalorieChartViewState extends State<CalorieChartView> {
  late final CalorieController _controller;
  late Future<Map<DateTime, int>> _calorieHistoryFuture;

  @override
  void initState() {
    super.initState();
    _controller = CalorieController();
    _calorieHistoryFuture = _controller.getCalorieHistory(widget.daysToShow);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, int>>(
      future: _calorieHistoryFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Hata oluştu: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Gösterilecek veri bulunamadı.'));
        }

        final calorieData = snapshot.data!;

        final List<BarChartGroupData> barGroups = [];
        final List<DateTime> sortedDays = calorieData.keys.toList()..sort();


        final DateFormat dateFormatter = DateFormat('d/M');

        for (int i = 0; i < sortedDays.length; i++) {
          final DateTime day = sortedDays[i];
          final int totalCalories = calorieData[day]!;

          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: totalCalories.toDouble(),
                  color: Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }

        return Container(
          height: 300,
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value % 500 == 0) {
                        return Text('${value.toInt()}', style: TextStyle(fontSize: 10));
                      }
                      return Text('');
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      if (index >= 0 && index < sortedDays.length) {

                        // "dayName" (gün adı) yerine "dateString" (tarih) yazdırıyoruz
                        final String dateString = dateFormatter.format(sortedDays[index]);

                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(dateString, style: TextStyle(fontSize: 10)),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
              ),

              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                checkToShowHorizontalLine: (value) => value % 500 == 0,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                ),
              ),
              barGroups: barGroups,
            ),
          ),
        );
      },
    );
  }
}