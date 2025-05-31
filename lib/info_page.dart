import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> pages = [
      {
        'title': 'PSG',
        'page': const PsgInfoPage(),
        'color': const Color.fromARGB(255, 241, 165, 190),
      },
      {
        'title': 'Sleep Stage Descriptions',
        'page': const SleepStageDescriptionsPage(),
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
          style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold,),
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
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// PSG Info Page with your colored boxes
class PsgInfoPage extends StatelessWidget {
  const PsgInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> infoTitles = ['EEG', 'EOG', 'EMG'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PSG'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: infoTitles.length,
        itemBuilder: (context, index) {
          String bodyText = '';
          switch (index) {
            case 0:
              bodyText = 'Monitors electrical brain activity during sleep.';
              break;
            case 1:
              bodyText = 'Tracks eye movements to detect REM sleep.';
              break;
            case 2:
              bodyText = 'Measures muscle activity to detect body movements.';
              break;
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: index == 0
                  ? const Color.fromARGB(255, 241, 165, 190)
                  : index == 1
                      ? const Color.fromARGB(255, 167, 142, 235)
                      : const Color.fromRGBO(76, 175, 80, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  infoTitles[index],
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bodyText,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Sleep Stage Descriptions Page
class SleepStageDescriptionsPage extends StatelessWidget {
  const SleepStageDescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Stage Descriptions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Here you can add detailed descriptions for sleep stages like N1, N2, N3, REM, and Wake.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Sleep Analysis Interpretation Page
class SleepAnalysisInterpretationPage extends StatelessWidget {
  const SleepAnalysisInterpretationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Analysis Interpretation'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'This section will provide interpretations of the sleep analysis results.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
