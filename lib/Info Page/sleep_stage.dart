import 'package:flutter/material.dart';

class SleepStageDescriptionsPage extends StatelessWidget {
  const SleepStageDescriptionsPage({super.key});

  final List<Map<String, String>> sleepStages = const [
    {
      'stage': 'N1',
      'description':
          'The lightest stage of non-REM sleep. You drift in and out of sleep and can be awakened easily.',
    },
    {
      'stage': 'N2',
      'description':
          'A deeper stage of non-REM sleep where heart rate slows and body temperature drops.',
    },
    {
      'stage': 'N3',
      'description':
          'The deepest stage of non-REM sleep, important for physical restoration and memory consolidation.',
    },
    {
      'stage': 'REM',
      'description':
          'Rapid Eye Movement sleep, associated with dreaming and brain activity similar to wakefulness.',
    },
    {
      'stage': 'Wake',
      'description': 'The awake state.',
    },
  ];

  void _showDescription(BuildContext context, String stage, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stage),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Stage Descriptions'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sleepStages.length,
        itemBuilder: (context, index) {
          final stage = sleepStages[index]['stage']!;
          final description = sleepStages[index]['description']!;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                stage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: const Icon(Icons.info_outline),
              onTap: () => _showDescription(context, stage, description),
            ),
          );
        },
      ),
    );
  }
}
