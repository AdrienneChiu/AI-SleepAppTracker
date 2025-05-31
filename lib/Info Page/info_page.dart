import 'package:flutter/material.dart';

import 'psg_page.dart';
import 'sleep_stage.dart';
import 'sleep_analysis.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> pages = [
      {
        'title': 'PSG Interpretation',
        'page': const PsgInfoPage(),
        'color': const Color.fromARGB(255, 241, 165, 190),
      },
      {
        'title': 'Sleep Stage Descriptions',
        'page': const SleepStageDescriptionPage(),
        'color': const Color.fromARGB(255, 167, 142, 235),
      },
      {
        'title': 'Sleep Analysis Interpretation',
        'page': const SleepAnalysisInterpretationPage(),
        'color': const Color.fromRGBO(76, 175, 80, 1),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Information Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: pages.map((entry) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: entry['color'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => entry['page']),
                  );
                },
                child: Text(
                  entry['title'],
                  style: const TextStyle(
                  fontSize: 26, // Increased size here
                  fontWeight: FontWeight.bold,
                  ),
                    textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
