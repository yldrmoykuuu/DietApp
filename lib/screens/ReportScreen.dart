import 'package:flutter/material.dart';
import 'package:healty/components/appbar.dart';
import 'package:healty/utils/macro_pie_chart.dart';
import 'package:healty/utils/calorie_history_chart.dart';

import '../utils/water_chart.dart';


enum ReportType { calorie, water }

class Reportscreen extends StatefulWidget {
  const Reportscreen({super.key});

  @override
  State<Reportscreen> createState() => _ReportscreenState();
}

class _ReportscreenState extends State<Reportscreen> {
  ReportType _selectedType = ReportType.calorie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Raporlar'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTypeSelector(),
          const SizedBox(height: 24),


          if (_selectedType == ReportType.calorie) ...[
            _buildChartCard(
              context: context,
              title: "Kalori Geçmişi",
              child: CalorieChartView(
                key: const ValueKey('calorie_chart'),
                daysToShow: 7,
              ),
            ),
            const SizedBox(height: 24),
            _buildChartCard(
              context: context,
              title: "Makro Dağılımı",
              child: MacroPieChartView(
                key: const ValueKey('macro_chart'),
                daysToShow: 7,
              ),
            ),
          ]


          else if (_selectedType == ReportType.water) ...[
            _buildChartCard(
              context: context,
              title: "Su Tüketimi",
              child: WaterChartView(
                key: const ValueKey('water_chart'),
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildTypeSelector() {
    return Center(
      child: SegmentedButton<ReportType>(
        segments: const [
          ButtonSegment(
            value: ReportType.calorie,
            label: Text('Kalori Değişimi'),
            icon: Icon(Icons.local_fire_department),
          ),
          ButtonSegment(
            value: ReportType.water,
            label: Text('Su Değişimi'),
            icon: Icon(Icons.water_drop),
          ),
        ],
        selected: <ReportType>{_selectedType},
        onSelectionChanged: (Set<ReportType> newSelection) {
          setState(() {
            _selectedType = newSelection.first;
          });
        },
      ),
    );
  }


  Widget _buildChartCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
