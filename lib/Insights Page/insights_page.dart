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

  // Weekly sleep data: One entry per day (simulate full week)
  final Map<DateTime, Map<String, double>> allSleepData = {
    DateTime(2025, 6, 2): {
      "Awake": 20,
      "N1": 30,
      "N2": 100,
      "N3": 150,
      "REM": 80,
    },
    DateTime(2025, 6, 3): {
      "Awake": 15,
      "N1": 25,
      "N2": 110,
      "N3": 140,
      "REM": 90,
    },
    DateTime(2025, 6, 4): {
      "Awake": 25,
      "N1": 20,
      "N2": 120,
      "N3": 130,
      "REM": 70,
    },
    DateTime(2025, 6, 5): {
      "Awake": 10,
      "N1": 35,
      "N2": 115,
      "N3": 125,
      "REM": 95,
    },
    DateTime(2025, 6, 6): {
      "Awake": 18,
      "N1": 28,
      "N2": 108,
      "N3": 138,
      "REM": 88,
    },
    DateTime(2025, 6, 7): {
      "Awake": 12,
      "N1": 32,
      "N2": 118,
      "N3": 128,
      "REM": 92,
    },
    DateTime(2025, 6, 8): {
      "Awake": 22,
      "N1": 27,
      "N2": 112,
      "N3": 132,
      "REM": 78,
    },
  };

  final List<String> stageKeys = ["Awake", "N1", "N2", "N3", "REM"];

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

  List<DateTime> getWeekDates(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => DateTime(start.year, start.month, start.day + i));
  }

  String formatDuration(double totalMinutes) {
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
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

    // Get today's data from map
    final todayData = allSleepData[selectedDate] ?? {
      "Awake": 0,
      "N1": 0,
      "N2": 0,
      "N3": 0,
      "REM": 0,
    };

    final durationsInMinutes = stageKeys.map((key) => todayData[key]!.toInt()).toList();

    return SafeArea(
      child: Container(
        color: Colors.blue[800],
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Sleep Insights",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),

              const SizedBox(height: 10),
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
                    text: "${stageNames[index]}: ${formatDuration(durationsInMinutes[index].toDouble())}",
                    onTap: () {},
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(color: Colors.white, thickness: 1.5),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Comparison Charts",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              SleepStageComparisonChart(
                weeklyData: weekDates.map((date) {
                  return allSleepData[date] ?? {
                    "Awake": 0,
                    "N1": 0,
                    "N2": 0,
                    "N3": 0,
                    "REM": 0,
                  };
                }).toList(),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(color: Colors.white, thickness: 1.5),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
