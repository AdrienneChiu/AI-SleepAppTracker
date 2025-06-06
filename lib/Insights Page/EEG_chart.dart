// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class EEGChart extends StatelessWidget {
//   final List<FlSpot> eegData;

//   const EEGChart({Key? key, required this.eegData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'EEG Activity (μV)',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 12),
//           AspectRatio(
//             aspectRatio: 1.7,
//             child: LineChart(
//               LineChartData(
//                 backgroundColor: Colors.transparent,
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   getDrawingHorizontalLine: (value) => FlLine(
//                     color: Colors.white.withOpacity(0.2),
//                     strokeWidth: 1,
//                   ),
//                   getDrawingVerticalLine: (value) => FlLine(
//                     color: Colors.white.withOpacity(0.2),
//                     strokeWidth: 1,
//                   ),
//                 ),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()}',
//                           style: const TextStyle(color: Colors.white),
//                         );
//                       },
//                     ),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           '${value.toInt()}',
//                           style: const TextStyle(color: Colors.white),
//                         );
//                       },
//                     ),
//                   ),
//                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: const Border(
//                     bottom: BorderSide(color: Colors.white, width: 1),
//                     left: BorderSide(color: Colors.white, width: 1),
//                     top: BorderSide.none,
//                     right: BorderSide.none,
//                   ),
//                 ),
//                 minX: 0,
//                 maxX: 9,
//                 minY: -100,
//                 maxY: 100,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: eegData,
//                     isCurved: true,
//                     color: Colors.purpleAccent,
//                     barWidth: 2,
//                     dotData: FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       color: Colors.purpleAccent.withOpacity(0.3),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
