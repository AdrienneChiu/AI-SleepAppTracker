import 'package:flutter/material.dart';

//Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Summary Section
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blue[100], // Light Blue Background for the summary
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 90, 188)),
                ),
              const SizedBox(height: 8.0),
              // const Text(
              //   'This section provides a summary of your sleep analysis, highlighting key metrics such as sleep stages, duration, and quality.',
              //   style: TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
        
        // Sleep Tracker Section
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blue[100], // Light Blue Background for the sleep tracker
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' Sleep \nTracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 90, 188)),
                ),
              const SizedBox(height: 8.0),
              // const Text(
              //   'Track your sleep cycles, including deep sleep, light sleep, and REM sleep, and monitor any potential sleep disturbances.',
              //   style: TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
        
        // Add more sections if needed
      ],
    );
  }
}