import 'package:flutter/material.dart';

class InsightBox extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onTap;

  const InsightBox({
    Key? key,
    required this.color,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class SleepStageDescriptionPage extends StatefulWidget {
  const SleepStageDescriptionPage({super.key});

  @override
  State<SleepStageDescriptionPage> createState() => _SleepStageDescriptionPageState();
}

class _SleepStageDescriptionPageState extends State<SleepStageDescriptionPage> {
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

  String buildInsightText(int index) {
    return stageNames[index];
  }

  void _showDescriptionDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final Color color = boxColors[index];
        return Dialog(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stageNames[index],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  descriptions[index],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: color, // text color
                      backgroundColor: Colors.white, // button background
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"),
                  ),
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
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Ensures center alignment
        children: [
          // Title: Centered properly
          Align(
            alignment: Alignment.center,
            child: Text(
              "Sleep Stages",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Ensures multiline center
            ),
          ),
          const SizedBox(height: 32),

          // Description
            const Center(
              child: Text(
                "Descriptions",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

          // Insight Boxes with spacing
          Column(
            children: List.generate(stageNames.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: InsightBox(
                  color: boxColors[index],
                  text: buildInsightText(index),
                  onTap: () => _showDescriptionDialog(index),
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );
}
}
