import 'package:flutter/material.dart';

class PsgInfoPage extends StatelessWidget {
  const PsgInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> infoTitles = ['EEG', 'EOG', 'EMG'];

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Align(
              alignment: Alignment.center,
              child: Text(
                'PSG',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

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

            // Info Boxes
            Column(
              children: List.generate(infoTitles.length, (index) {
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

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
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
