import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepPieChart extends StatelessWidget {
  final List<double> values;

  const SleepPieChart({super.key, required this.values});

  final List<Color> sliceColors = const [
    Color.fromARGB(255, 241, 165, 190), // pink
    Color.fromARGB(255, 167, 142, 235), // purple
    Color.fromRGBO(76, 175, 80, 1),     // green
    Color.fromARGB(255, 209, 176, 67),  // orange
    Color.fromARGB(255, 95, 159, 231),  // blue
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
              title: '', // No title
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
  List<double> sleepStageValues = [30, 20, 25, 15, 10];

  bool isRunning = false;
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  Duration recordedSleepDuration = Duration.zero;

  void toggleStopwatch() {
    if (isRunning) {
      stopwatch.stop();
      timer.cancel();
      recordedSleepDuration = stopwatch.elapsed;
    } else {
      stopwatch.start();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {});
      });
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void resetStopwatch() {
    stopwatch.reset();
    if (isRunning) timer.cancel();
    setState(() {
      isRunning = false;
      recordedSleepDuration = Duration.zero;
    });
  }

  // Update this function to return formatted time (hh:mm:ss)
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  // Sleep score calculation method
  double calculateSleepScore() {
    List<double> weights = [0, 0.5, 0.75, 1.0, 1.0];
    double weightedSum = 0;
    double totalTime = 0;

    for (int i = 0; i < sleepStageValues.length; i++) {
      weightedSum += sleepStageValues[i] * weights[i];
      totalTime += sleepStageValues[i];
    }

    if (totalTime == 0) return 0;
    return (weightedSum / totalTime) * 100;
  }

  @override
  void dispose() {
    if (isRunning) timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sleepScore = calculateSleepScore();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Summary Section
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
              SleepPieChart(values: sleepStageValues),
              const SizedBox(height: 16.0),
              // You can enable this to show stopwatch time if needed
              // Text(
              //   'Hours of Sleep: ${formatDuration(recordedSleepDuration)}',
              //   style: const TextStyle(
              //     fontSize: 20,
              //     color: Color.fromARGB(255, 34, 90, 188),
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 10.0),
              const Text(
                'Sleep Quality: Good',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 34, 90, 188),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Sleep Score Section
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
                sleepScore.toStringAsFixed(1), // Sleep score decimal point
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
  }
}
