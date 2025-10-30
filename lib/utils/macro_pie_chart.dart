import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healty/controllers/calorie_controller.dart'; // Controller'ı import et

// Renkleri ve etiketleri tanımlayalım
const Color proteinColor = Colors.blue;
const Color fatColor = Colors.red;
const Color carbsColor = Colors.orange;

class MacroPieChartView extends StatefulWidget {
  final int daysToShow;

  const MacroPieChartView({Key? key, this.daysToShow = 7}) : super(key: key);

  @override
  _MacroPieChartViewState createState() => _MacroPieChartViewState();
}

class _MacroPieChartViewState extends State<MacroPieChartView> {
  late final CalorieController _controller;
  late Future<Map<String, double>> _macroTotalsFuture;

  @override
  void initState() {
    super.initState();
    _controller = CalorieController();

    _macroTotalsFuture = _controller.getMacroTotals(widget.daysToShow);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _macroTotalsFuture,
      builder: (context, snapshot) {
        // ---- A. Yükleniyor ----
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // ---- B. Hata ----
        if (snapshot.hasError) {
          return Center(child: Text('Hata oluştu: ${snapshot.error}'));
        }
        // ---- C. Veri Yok ----
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Makro verisi bulunamadı.'));
        }


        final macroData = snapshot.data!;
        final double proteinCals = macroData['protein'] ?? 0;
        final double fatCals = macroData['fat'] ?? 0;
        final double carbCals = macroData['carbs'] ?? 0;


        final double totalMacroCalories = proteinCals + fatCals + carbCals;

        if (totalMacroCalories == 0) {
          return Center(child: Text('Haftalık makro verisi yok.'));
        }


        final List<PieChartSectionData> sections = [

          PieChartSectionData(
            color: proteinColor,
            value: proteinCals,
            title: '${((proteinCals / totalMacroCalories) * 100).toStringAsFixed(0)}%', // '30%'
            radius: 80,
            titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),

          PieChartSectionData(
            color: fatColor,
            value: fatCals,
            title: '${((fatCals / totalMacroCalories) * 100).toStringAsFixed(0)}%', // '25%'
            radius: 80,
            titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),

          PieChartSectionData(
            color: carbsColor,
            value: carbCals,
            title: '${((carbCals / totalMacroCalories) * 100).toStringAsFixed(0)}%', // '45%'
            radius: 80,
            titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ];


        return Column(
          children: [
            SizedBox(
              height: 200, // Grafik alanı
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2, // Dilimler arası boşluk
                  centerSpaceRadius: 40, // Ortadaki boşluk
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendIndicator(color: proteinColor, text: 'Protein'),
                const SizedBox(width: 16),
                _buildLegendIndicator(color: fatColor, text: 'Yağ'),
                const SizedBox(width: 16),
                _buildLegendIndicator(color: carbsColor, text: 'Karbonhidrat'),
              ],
            )
          ],
        );
      },
    );
  }


  Widget _buildLegendIndicator({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}