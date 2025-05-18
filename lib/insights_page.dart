import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  DateTime selectedDate = DateTime.now();

  final List<String> insights = [
    "Stage W: #h #m",
    "Stage N1: #h #m",
    "Stage N2: #h",
    "Stage N3: #m",
    "Stage R: #m"
  ];

  final List<Color> boxColors = [
    Color.fromARGB(255, 241, 165, 190),
    Color.fromARGB(255, 167, 142, 235),
    Color.fromRGBO(76, 175, 80, 1),
    Color.fromARGB(255, 95, 159, 231),
    Color.fromARGB(255, 209, 176, 67),
  ];

  /// Returns the list of weekdays for the week of a given date (Mon - Sun)
  List<DateTime> getWeekDates(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  /// Handles date picking via calendar
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

  /// Show popup insight card
  void showInsightDetails(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: boxColors[index],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  insights[index],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Detailed analysis coming soon...",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
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
    //final selectedDayIndex = selectedDate.weekday - 1;

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
                    decorationColor: Colors.white
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Weekday bubbles
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

            // const SizedBox(height: 10),
            // Text(
            //   "Sleep Data for ${DateFormat.EEEE().format(selectedDate)}",
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),

            const SizedBox(height: 20),

            // Insight list
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: insights.length,
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
                        insights[index],
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
