import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepPieChart extends StatelessWidget {
  final List<double> values;

  const SleepPieChart({super.key, required this.values});

  // Colors for the pie chart slices
  final List<Color> sliceColors = const [
    Color.fromARGB(255, 241, 165, 190), // pink
    Color.fromARGB(255, 167, 142, 235), // purple
    Color.fromRGBO(76, 175, 80, 1),     // green
    Color.fromARGB(255, 209, 176, 67),  // orange
    Color.fromARGB(255, 95, 159, 231),  // blue
  ];

  // Creates the pie chart
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

// This is the main page of the app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Placeholder data for the pie chart
class _HomePageState extends State<HomePage> {
  List<double> sleepStageValues = [30, 20, 25, 15, 10]; // Initial pie values

  // This is where I'll update pie chart values dynamically when AI model is implemented
  void updatePieChart(List<double> newValues) {
    setState(() {
      sleepStageValues = newValues;
    });
  }

  // Bubbles containing the pie chart and manual sleep tracker
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Summary Bubble Section
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
              const SizedBox(height: 12.0),

              // Dynamic Pie Chart
              SleepPieChart(values: sleepStageValues),

              const SizedBox(height: 16.0),

              // Text Info
              const Text(
                'Hours of Sleep: #.#',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 34, 90, 188),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
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

        // Sleep Tracker Bubble Section
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Sleep \nTracker',
                style: TextStyle(
                  fontSize: 24,
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
