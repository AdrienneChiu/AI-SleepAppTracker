import 'package:flutter/material.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  int selectedDayIndex = 0;

  final List<String> shortDays = ["M", "T", "W", "T", "F", "S", "S"];
  final List<String> fullDays = [
    "Monday", "Tuesday", "Wednesday", "Thursday",
    "Friday", "Saturday", "Sunday"
  ];

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

  void showInsightDetails(int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: boxColors[index],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
    final ThemeData theme = Theme.of(context);

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
            const SizedBox(height: 20),

            // Days of the week selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(shortDays.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedDayIndex == index
                            ? Colors.blue[600]
                            : Colors.blue[300],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        shortDays[index],
                        style: TextStyle(
                          color: selectedDayIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Selected day label
            Text(
              "Sleep Data for ${fullDays[selectedDayIndex]}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Insights list + divider
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: insights.length + 1,
                itemBuilder: (context, index) {
                  if (index < insights.length) {
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
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.white70,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
