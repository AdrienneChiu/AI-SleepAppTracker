// lib/sleep_predictor_page.dart
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attnsleep.dart'; // my model runner
import 'models/sleep_stage_result.dart';
import 'providers/sleep_data_provider.dart';
import 'utils/aggregator.dart';

class SleepPredictorPage extends StatefulWidget {
  const SleepPredictorPage({super.key});

  @override
  State<SleepPredictorPage> createState() => _SleepPredictorPageState();
}

class _SleepPredictorPageState extends State<SleepPredictorPage> {
  final AttnSleep _runner = AttnSleep(); // your AttnSleep class
  bool _modelLoaded = false;
  bool _running = false;
  double _progress = 0.0;
  List<double> _lastProbs = [];
  String? _lastLabel;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    try {
      await _runner.load(); // ensure your AttnSleep has load()
      setState(() => _modelLoaded = true);
    } catch (e) {
      setState(() => _modelLoaded = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Model load error: $e')),
      );
    }
  }

  /// Runs a dummy full-night inference (N epochs).
  /// In practice, replace dummy window generation with your real preprocessed EEG windows.
  Future<void> _runDummyNight({int epochs = 480}) async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Model not loaded')));
      return;
    }

    setState(() {
      _running = true;
      _progress = 0;
      _lastProbs = [];
      _lastLabel = null;
    });

    final preds = <int>[];

    for (int e = 0; e < epochs; e++) {
      // create a dummy 3000-length Float32List window (replace with real data)
      final Float32List window = Float32List.fromList(
        List<double>.generate(_runner.windowLength, (_) => math.Random().nextDouble()),
      );

      // YOUR AttnSleep.predict returns a record (label, idx, probs)
      final res = _runner.predict(window);
      final int idx = res.$2; // record index position 2 is int index
      final List<double> probs = res.$3; // record position 3 = probs

      preds.add(idx);

      // update last display every N steps to keep UI responsive
      if (e % 10 == 0) {
        setState(() {
          _progress = (e + 1) / epochs;
          _lastProbs = probs;
          _lastLabel = res.$1;
        });
        // yield to UI
        await Future.delayed(Duration.zero);
      }
    }

    // Final progress
    setState(() {
      _progress = 1.0;
    });

    // Aggregate into minutes:
    final durations = aggregateSleepStages(preds);

    // Store result in provider
    final result = SleepStageResult(timestamp: DateTime.now(), stageDurations: durations);
    Provider.of<SleepDataProvider>(context, listen: false).addResult(result);

    // Update UI
    setState(() {
      _running = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prediction saved to app data')));
  }

  @override
  Widget build(BuildContext context) {
    final labels = AttnSleep.labels;
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Stage Predictor')),
      backgroundColor: Colors.blue[800],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!_modelLoaded) const Text('Loading model...', style: TextStyle(color: Colors.white)),
            if (_modelLoaded && !_running)
              ElevatedButton(
                onPressed: () => _runDummyNight(epochs: 480), // default number of epochs for dummy night
                child: const Text('Run Dummy Full-Night Prediction'),
              ),
            if (_running) ...[
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 8),
              Text('${(_progress * 100).toStringAsFixed(0)}% completed', style: const TextStyle(color: Colors.white)),
            ],
            const SizedBox(height: 16),
            if (_lastLabel != null) ...[
              Text('Last epoch predicted: $_lastLabel', style: const TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 8),
            ],
            if (_lastProbs.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_lastProbs.length, (i) {
                  return Text('${labels[i]}: ${(_lastProbs[i] * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white));
                }),
              ),
          ],
        ),
      ),
    );
  }
}

