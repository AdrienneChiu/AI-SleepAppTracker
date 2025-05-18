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
  // Current selected date for insights display on top of the page
  DateTime selectedDate = DateTime.now();

  // Temporary time for each sleep stage (will convert to hours/minutes)
  final List<int> durationsInMinutes = [10, 60, 75, 170, 200];

  // Names of sleep stages
  final List<String> stageNames = [
    "W (Awake)",
    "N1 (Light Sleep)",
    "N2 (Moderate Sleep)",
    "N3 (Deep Sleep)",
    "R (REM)",
  ];

  // Descriptions for each sleep stage pop-up, on click
  final List<String> descriptions = [
    "Stage W is wakefulness. This stage indicates the amount of time you were awake during the night.",
    "Stage N1 is the lightest stage of sleep where you start to fall asleep.",
    "Stage N2 is a deeper sleep stage important for memory consolidation.",
    "Stage N3 is deep sleep, critical for physical recovery and growth.",
    "Stage R is REM sleep, associated with dreaming and brain activity.",
  ];

  // Colors for the insight boxes, matched to each sleep stage
  final List<Color> boxColors = [
    const Color.fromARGB(255, 241, 165, 190), // Pink
    const Color.fromARGB(255, 167, 142, 235), // Purple
    const Color.fromRGBO(76, 175, 80, 1),     // Green
    const Color.fromARGB(255, 95, 159, 231),  // Blue
    const Color.fromARGB(255, 209, 176, 67),  // Yellow
  ];

  // Format total minutes into "Xh Ym" or "Xm"
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

  // Title text shown on each insight box with time
  String buildInsightText(int index) {
    return "${stageNames[index]}: ${formatDuration(durationsInMinutes[index])}";
  }

  // Gets a list of dates for the current week based on the given date
  List<DateTime> getWeekDates(DateTime date) {
    // DateTime.weekday: Monday=1, Sunday=7
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  // Function to show date picker calendar
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

  // Show detailed descriptions inside insight boxs when clicked
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
    // Calculate the dates for the current week for the date selector widget
    final weekDates = getWeekDates(selectedDate);

    return SafeArea(
      child: Container(
        color: Colors.blue[800],
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Page Title
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

              // Selected date label with underline, opens date picker when clicked
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

              // Date selector widget showing the week dates
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

              // Line chart widget showing the durations visually
              LineChartWidget(durationsInMinutes: durationsInMinutes),

              // List of insight boxes for each sleep stage
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

              // White divider line
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

              // Analysis Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Section Header: Analysis
                    const Center(
                      child: Text(
                        "Analysis",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Interpretation
                    const Center(
                      child: Text(
                        "Interpretation",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Good Sleep interpretation box
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Good Sleep: ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "You’re getting enough restful sleep with a healthy balance of deep (N3) and REM stages. This supports physical recovery, memory, and emotional wellbeing. You typically sleep 7–9 hours with minimal interruptions.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Average Sleep interpretation box
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Average Sleep: ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Sleep quality is moderate with some disruptions. You might get enough total sleep but less deep and REM sleep than ideal, which can affect memory, focus, and mood.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bad Sleep interpretation box
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Bad Sleep: ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Sleep is insufficient or fragmented with limited deep and REM stages. This negatively impacts physical recovery, cognitive function, and emotional health, and often results in daytime tiredness.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
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
