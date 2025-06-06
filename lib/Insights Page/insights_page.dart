// Main Insights UI Page
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'sleep_stage_comparison_chart.dart';
import 'date_selector.dart';
import 'line_chart.dart';
import 'insight_box.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  DateTime selectedDate = DateTime.now();

  final List<int> durationsInMinutes = [10, 60, 75, 170, 200];

    final List<Map<String, double>> sleepStageData = [
    {
      "Awake": 20,
      "N1": 30,
      "N2": 100,
      "N3": 150,
      "REM": 80,
    },
    {
      "Awake": 15,
      "N1": 25,
      "N2": 110,
      "N3": 140,
      "REM": 90,
    },
    {
      "Awake": 25,
      "N1": 20,
      "N2": 120,
      "N3": 130,
      "REM": 70,
    },
    {
      "Awake": 10,
      "N1": 35,
      "N2": 115,
      "N3": 125,
      "REM": 95,
    },
    {
      "Awake": 18,
      "N1": 28,
      "N2": 108,
      "N3": 138,
      "REM": 88,
    },
    {
      "Awake": 12,
      "N1": 32,
      "N2": 118,
      "N3": 128,
      "REM": 92,
    },
    {
      "Awake": 22,
      "N1": 27,
      "N2": 112,
      "N3": 132,
      "REM": 78,
    },
  ];



  // Sample EEG data - not using anymore
  // final List<FlSpot> eegData = [
  // FlSpot(0, 10),
  // FlSpot(1, -20),
  // FlSpot(2, 50),
  // FlSpot(3, -60),
  // FlSpot(4, 80),
  // FlSpot(5, -40),
  // FlSpot(6, 30),
  // FlSpot(7, -10),
  // FlSpot(8, 20),
  // FlSpot(9, 0),
  // ];

  // Sample heart rate data - not using anymore
  // final List<FlSpot> heartRateData = [
  // FlSpot(0, 70),
  // FlSpot(1, 74),
  // FlSpot(2, 78),
  // FlSpot(3, 72),
  // FlSpot(4, 88),
  // FlSpot(5, 84),
  // FlSpot(6, 76),
  // FlSpot(7, 70),
  // FlSpot(8, 92),
  // FlSpot(9, 85),
  // ];

  final List<FlSpot> sleepStageData = [
  FlSpot(0, 10), // Awake
  FlSpot(1, 60), // N1
  FlSpot(2, 75), // N2
  FlSpot(3, 170), // N3
  FlSpot(4, 200), // REM
  ];

  final List<String> stageNames = [
    "W (Awake)",
    "N1 (Light Sleep)",
    "N2 (Moderate Sleep)",
    "N3 (Deep Sleep)",
    "R (REM)",
  ];

  final List<Color> boxColors = [
    const Color.fromARGB(255, 241, 165, 190),
    const Color.fromARGB(255, 167, 142, 235),
    const Color.fromRGBO(76, 175, 80, 1),
    const Color.fromARGB(255, 95, 159, 231),
    const Color.fromARGB(255, 209, 176, 67),
  ];

  String formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return "${hours}h ${minutes}m";
    } else if (hours > 0) {
      return "${hours}h";
    } else {
      return "${minutes}m";
    }
  }

  String buildInsightText(int index) {
    return "${stageNames[index]}: ${formatDuration(durationsInMinutes[index])}";
  }

  List<DateTime> getWeekDates(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = getWeekDates(selectedDate);

    return SafeArea(
      child: Container(
        color: Colors.blue[800],
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Sleep Insights",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              //Select Date Functionality
              GestureDetector(
                onTap: _pickDate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Sleep Data for ${DateFormat('d MMMM yyyy').format(selectedDate)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              DateSelector(
                weekDates: weekDates,
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 40),

              LineChartWidget(durationsInMinutes: durationsInMinutes),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stageNames.length,
                itemBuilder: (context, index) {
                  return InsightBox(
                    color: boxColors[index],
                    text: buildInsightText(index),
                    onTap: () {}, // Removed onTap functionality (for now)
                  );
                },
              ),
              const SizedBox(height: 20),

              //First White Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

              // Title for Other Charts 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                alignment: Alignment.centerLeft,
                 child: Text(
                   "Comparison Charts",
                   style: TextStyle(
                   fontSize: 26,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               ),
            ),
          ),
           const SizedBox(height: 12),
          //EEGChart(eegData: eegData), //Build EEG Chart into insights Page

          SleepStageComparisonChart(weeklyData: sleepStageData),


          // Second White Divider
          const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

          //HeartRateChart(heartRateData: heartRateData), //Build HeartRate Chart into insights Page
          const SizedBox(height: 10),

          

          
            ],
          ),
        ),
      ),
    );
  }
}
