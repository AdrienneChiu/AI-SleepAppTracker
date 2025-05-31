import 'package:flutter/material.dart';

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
