// Main Insights Page
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final List<String> stageNames = [
    "W (Awake)",
    "N1 (Light Sleep)",
    "N2 (Moderate Sleep)",
    "N3 (Deep Sleep)",
    "R (REM)",
  ];

  final List<String> descriptions = [
    "Stage W is wakefulness. This stage indicates the amount of time you were awake during the night.",
    "Stage N1 is the lightest stage of sleep where you start to fall asleep.",
    "Stage N2 is a deeper sleep stage important for memory consolidation.",
    "Stage N3 is deep sleep, critical for physical recovery and growth.",
    "Stage R is REM sleep, associated with dreaming and brain activity.",
  ];

  final List<Color> boxColors = [
    const Color.fromARGB(255, 241, 165, 190), // Pink
    const Color.fromARGB(255, 167, 142, 235), // Purple
    const Color.fromRGBO(76, 175, 80, 1),     // Green
    const Color.fromARGB(255, 95, 159, 231),  // Blue
    const Color.fromARGB(255, 209, 176, 67),  // Yellow
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

  void showInsightDetails(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: boxColors[index],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stageNames[index],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  formatDuration(durationsInMinutes[index]),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  descriptions[index],
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: boxColors[index],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
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
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              DateSelector(
                weekDates: weekDates,
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),

              const SizedBox(height: 20),

              LineChartWidget(durationsInMinutes: durationsInMinutes),

              // Insight boxes list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stageNames.length,
                itemBuilder: (context, index) {
                  return InsightBox(
                    color: boxColors[index],
                    text: buildInsightText(index),
                    onTap: () => showInsightDetails(index),
                  );
                },
              ),

              const SizedBox(height: 20),

              // White divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

              // Analysis section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Analysis",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Interpretation",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Good Sleep: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Average Sleep: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Bad Sleep: ",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
