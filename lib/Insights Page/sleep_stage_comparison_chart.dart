import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepStageComparisonChart extends StatelessWidget {
  final List<Map<String, double>> weeklyData;

  const SleepStageComparisonChart({super.key, required this.weeklyData});

  final List<String> stageLabels = const [
    "Awake",
    "N1",
    "N2",
    "N3",
    "REM",
  ];

  final List<Color> stageColors = const [
    Color.fromARGB(255, 241, 165, 190), // Awake
    Color.fromARGB(255, 167, 142, 235), // N1
    Color.fromRGBO(76, 175, 80, 1),     // N2
    Color.fromARGB(255, 95, 159, 231),  // N3
    Color.fromARGB(255, 209, 176, 67),  // REM
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Sleep Stage Comparison',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}m', style: const TextStyle(color: Colors.white, fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(days[value.toInt()], style: const TextStyle(color: Colors.white));
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 60),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
                maxY: 480,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(weeklyData.length, (index) {
      double sumHeight = 0;
      List<BarChartRodStackItem> stackItems = [];

      for (int i = 0; i < stageLabels.length; i++) {
        final value = weeklyData[index][stageLabels[i]] ?? 0;
        stackItems.add(
          BarChartRodStackItem(sumHeight, sumHeight + value, stageColors[i]),
        );
        sumHeight += value;
      }

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
          toY: sumHeight,
          rodStackItems: stackItems,
          width: 16,
        )
      ]);
    });
  }
}
