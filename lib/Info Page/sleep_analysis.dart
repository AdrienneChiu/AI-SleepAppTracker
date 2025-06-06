import 'package:flutter/material.dart';

class SleepAnalysisInterpretationPage extends StatelessWidget {
  const SleepAnalysisInterpretationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Sleep Analysis Interpretation'),
      ),
      body: SingleChildScrollView(  // Add scroll so content doesn’t overflow
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section Header: Analysis
            const Center(
              child: Text(
                " Sleep Analysis",
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
    );
  }
}
