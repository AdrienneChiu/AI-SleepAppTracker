// lib/insights/line_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<int> durationsInMinutes;

  const LineChartWidget({Key? key, required this.durationsInMinutes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxDuration = durationsInMinutes.reduce((a, b) => a > b ? a : b).toDouble() + 20;
    const stages = ['W', 'N1', 'N2', 'N3', 'R'];

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 1,
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= stages.length) return Container();
                    return Text(
                      stages[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 60,
                  getTitlesWidget: (value, meta) {
                    int hours = value ~/ 60;
                    return Text(
                      '${hours}h',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: maxDuration,
            minY: 0,
            maxY: (durationsInMinutes.length - 1).toDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(durationsInMinutes.length, (index) => 
                  FlSpot(durationsInMinutes[index].toDouble(), index.toDouble())),
                isCurved: true,
                color: Colors.white,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              )
            ],
          ),
        ),
      ),
    );
  }
}
