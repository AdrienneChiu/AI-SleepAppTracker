import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'providers/sleep_data_provider.dart';


class SleepPieChart extends StatelessWidget {
  final List<double> values;

  const SleepPieChart({super.key, required this.values});

  final List<Color> sliceColors = const [
    Color(0xFFF1A5BE), // Awake
    Color(0xFFA78EEB), // N1
    Color(0xFF4CAF50), // N2
    Color(0xFF5F9FE7), // N3
    Color(0xFFD1B043), // REM
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: List.generate(values.length, (i) {
            return PieChartSectionData(
              color: sliceColors[i],
              value: values[i],
              title: '',
              radius: 60,
            );
          }),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<double> defaultStageValues = const [30, 20, 25, 15, 10]; // Awake,N1,N2,N3,REM

  double calculateSleepScore(List<double> minutesValues) {
    const weights = [0, 0.5, 0.75, 1.0, 1.0]; // Awake..REM
    double weightedSum = 0, total = 0;
    for (int i = 0; i < minutesValues.length; i++) {
      weightedSum += minutesValues[i] * weights[i];
      total += minutesValues[i];
    }
    if (total == 0) return 0;
    return (weightedSum / total) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepDataProvider>(
      builder: (context, provider, _) {
        final latest = provider.latest;
        const stageKeys = ["Awake", "N1", "N2", "N3", "REM"];

        final stageValues = latest == null
            ? defaultStageValues
            : stageKeys
                .map((k) => (latest.stageDurations[k] ?? 0).toDouble())
                .toList();

        final sleepScore = calculateSleepScore(stageValues);

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // DEBUG PURPOSE: DELETE LATER
            // Text(
            //   'Nights saved: ${provider.results.length}',
            //   style: const TextStyle(color: Colors.white),
            // ),
            // const SizedBox(height: 8),

            // Summary
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 90, 188),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SleepPieChart(values: stageValues),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Sleep Quality: Good',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 34, 90, 188),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // DELETE LATER: DEBUGGING PURPOSES
                  // ElevatedButton(
                  //   onPressed: () => Navigator.of(context).pushNamed('/predict'),
                  //   child: const Text('Open Predictor'),
                  // ),

                  // DEBUG helpers (remove when satisfied)
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Sleep Score
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Sleep Score',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 90, 188),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sleepScore.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 90, 188),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
