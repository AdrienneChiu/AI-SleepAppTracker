import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  DateTime selectedDate = DateTime.now();

  // Example durations in minutes for each sleep stage (replace with real data)
  final List<int> durationsInMinutes = [
    45,  // Stage W
    50,  // Stage N1
    65, // Stage N2
    170,  // Stage N3
    200,  // Stage R
  ];

  // Sleep Stage names
  final List<String> stageNames = [
    "W (Awake)",
    "N1 (Light Sleep)",
    "N2 (Moderate Sleep)",
    "N3 (Deep Sleep)",
    "R (REM)",
  ];

  // Updated descriptions as provided
  final List<String> descriptions = [
    "Stage W is wakefulness. This stage indicates the amount of time you were awake during the night.",
    "Stage N1 is the lightest stage of sleep where you start to fall asleep.",
    "Stage N2 is a deeper sleep stage important for memory consolidation.",
    "Stage N3 is deep sleep, critical for physical recovery and growth.",
    "Stage R is REM sleep, associated with dreaming and brain activity.",
  ];

  // Background colors for each box
  final List<Color> boxColors = [
    Color.fromARGB(255, 241, 165, 190), // Awake - Pink
    Color.fromARGB(255, 167, 142, 235), // Light - Purple
    Color.fromRGBO(76, 175, 80, 1),     // Moderate - Green
    Color.fromARGB(255, 95, 159, 231),  // Deep - Blue
    Color.fromARGB(255, 209, 176, 67),  // REM - Yellow
  ];

  // Function to format the duration in hours and minutes
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

  // Function to build the insight text for each stage
  String buildInsightText(int index) {
    return "${stageNames[index]}: ${formatDuration(durationsInMinutes[index])}";
  }

  // Function to get the dates of the week for the selected date
  List<DateTime> getWeekDates(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  // Function to show the date picker
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

 // Function to show the pop-up insight details
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

    // Layout for the insights page (including title, date picker, chart)
    return SafeArea(
      child: Container(
        color: Colors.blue[800],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                final date = weekDates[index];
                final isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[600] : Colors.blue[300],
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat.E().format(date).substring(0, 1),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

          //Line Chart
           SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 60,
                          getTitlesWidget: (value, meta) {
                            int hours = value ~/ 60;
                            return Text(
                              '${hours}h',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            const stages = ['W', 'N1', 'N2', 'N3', 'R'];
                            int index = value.toInt();
                            if (index < 0 || index >= stages.length) return Container();
                            return Text(
                              stages[index],
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (durationsInMinutes.length - 1).toDouble(),
                    minY: 0,
                    maxY: durationsInMinutes.reduce((a, b) => a > b ? a : b).toDouble() + 20,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          durationsInMinutes.length,
                          (index) => FlSpot(index.toDouble(), durationsInMinutes[index].toDouble()),
                        ),
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.white,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // List of insights and layout
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: stageNames.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => showInsightDetails(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: boxColors[index],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        buildInsightText(index),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
