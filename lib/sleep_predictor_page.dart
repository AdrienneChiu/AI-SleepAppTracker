// lib/sleep_predictor_page.dart
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attnsleep.dart'; // your model runner
import 'models/sleep_stage_result.dart';
import 'providers/sleep_data_provider.dart';
import 'utils/aggregator.dart';
import 'utils/label_map.dart';

class SleepPredictorPage extends StatefulWidget {
  const SleepPredictorPage({super.key});

  @override
  State<SleepPredictorPage> createState() => _SleepPredictorPageState();
}

class _SleepPredictorPageState extends State<SleepPredictorPage> {
  final AttnSleep _runner = AttnSleep();
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
      await _runner.load();
      setState(() => _modelLoaded = true);
    } catch (e) {
      setState(() => _modelLoaded = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Model load error: $e')),
      );
    }
  }

  Future<void> _runNight() async {
    if (!_modelLoaded) return;

    setState(() {
      _running = true;
      _progress = 0;
      _lastProbs = [];
      _lastLabel = null;
    });

    final preds = <int>[];
    final provider = Provider.of<SleepDataProvider>(context, listen: false);
    Float32List eegData;

    // 1️⃣ Try to use real EEG
    try {
      eegData = provider.currentEEG;
      if (eegData.isEmpty) throw Exception('EEG data empty');
    } catch (_) {
      // 2️⃣ Fallback to dummy data
      debugPrint('[SleepPredictorPage] Using dummy EEG data');
      eegData = Float32List.fromList(
        List<double>.generate(_runner.windowLength * 480, (_) => math.Random().nextDouble()),
      );
    }

    // Split EEG into windows
    final totalWindows = (eegData.length / _runner.windowLength).ceil();

    for (int w = 0; w < totalWindows; w++) {
      final start = w * _runner.windowLength;
      final end = ((w + 1) * _runner.windowLength).clamp(0, eegData.length);
      final window = eegData.sublist(start, end);

      // Pad if last window is short
      final windowData = window.length < _runner.windowLength
          ? Float32List.fromList([...window, ...List.filled(_runner.windowLength - window.length, 0.0)])
          : Float32List.fromList(window);

      final res = _runner.predict(windowData);
      preds.add(res.$2);

      if (w % 5 == 0) {
        setState(() {
          _progress = (w + 1) / totalWindows;
          _lastProbs = res.$3;
          _lastLabel = LabelMap.toDisplay(res.$1);
        });
        await Future.delayed(Duration.zero);
      }
    }

    final durations = aggregateSleepStages(preds);
    final result = SleepStageResult(timestamp: DateTime.now(), stageDurations: durations);
    provider.addResult(result);

    setState(() {
      _running = false;
      _progress = 1.0;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Prediction saved to app data')));
  }

  @override
  Widget build(BuildContext context) {
    final modelLabels = AttnSleep.labels;

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Stage Predictor')),
      backgroundColor: Colors.blue[800],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!_modelLoaded)
              const Text('Loading model...', style: TextStyle(color: Colors.white)),
            if (_modelLoaded && !_running)
              ElevatedButton(
                onPressed: _runNight,
                child: const Text('Run Full-Night Prediction'),
              ),
            if (_running) ...[
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 8),
              Text(
                '${(_progress * 100).toStringAsFixed(0)}% completed',
                style: const TextStyle(color: Colors.white),
              ),
            ],
            const SizedBox(height: 16),
            if (_lastLabel != null) ...[
              Text(
                'Last epoch predicted: $_lastLabel',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
            ],
            if (_lastProbs.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_lastProbs.length, (i) {
                  final display = LabelMap.toDisplay(modelLabels[i]);
                  return Text(
                    '$display: ${(_lastProbs[i] * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}




// // lib/sleep_predictor_page.dart
// import 'dart:typed_data';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'attnsleep.dart'; // my model runner
// import 'models/sleep_stage_result.dart';
// import 'providers/sleep_data_provider.dart';
// import 'utils/aggregator.dart';
// import 'utils/label_map.dart'; // 

// class SleepPredictorPage extends StatefulWidget {
//   const SleepPredictorPage({super.key});

//   @override
//   State<SleepPredictorPage> createState() => _SleepPredictorPageState();
// }

// class _SleepPredictorPageState extends State<SleepPredictorPage> {
//   final AttnSleep _runner = AttnSleep(); // your AttnSleep class
//   bool _modelLoaded = false;
//   bool _running = false;
//   double _progress = 0.0;
//   List<double> _lastProbs = [];
//   String? _lastLabel; // display label ("Awake","N1","N2","N3","REM")

//   @override
//   void initState() {
//     super.initState();
//     _initModel();
//   }

//   Future<void> _initModel() async {
//     try {
//       await _runner.load(); // ensure your AttnSleep has load()
//       setState(() => _modelLoaded = true);
//     } catch (e) {
//       setState(() => _modelLoaded = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Model load error: $e')),
//       );
//     }
//   }

//   /// Runs a dummy full-night inference (N epochs).
//   /// In practice, replace dummy window generation with your real preprocessed EEG windows.
//   Future<void> _runDummyNight({int epochs = 480}) async {
//     if (!_modelLoaded) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Model not loaded')));
//       return;
//     }

//     setState(() {
//       _running = true;
//       _progress = 0;
//       _lastProbs = [];
//       _lastLabel = null;
//     });

//     final preds = <int>[]; // collect model indices 0..4

//     for (int e = 0; e < epochs; e++) {
//       // create a dummy 3000-length Float32List window (replace with real data)
//       final Float32List window = Float32List.fromList(
//         List<double>.generate(_runner.windowLength, (_) => math.Random().nextDouble()),
//       );

//       // AttnSleep.predict returns (label, idx, probs)
//       final res = _runner.predict(window);
//       final int idx = res.$2;           // 0..4
//       final List<double> probs = res.$3; // probabilities per stage

//       preds.add(idx);

//       // update last display every N steps to keep UI responsive
//       if (e % 10 == 0) {
//         setState(() {
//           _progress = (e + 1) / epochs;
//           _lastProbs = probs;
//           _lastLabel = LabelMap.toDisplay(res.$1); // ⬅️ display key ("W" -> "Awake")
//         });
//         await Future.delayed(Duration.zero);
//       }
//     }

//     // Final progress
//     setState(() {
//       _progress = 1.0;
//     });

//     // Aggregate indices into minutes per stage, using display keys internally
//     final durations = aggregateSleepStages(preds); // -> {"Awake": x, "N1":..., "REM":...}

//     // Store result in provider
//     final result = SleepStageResult(
//       timestamp: DateTime.now(),
//       stageDurations: durations,
//     );
//     Provider.of<SleepDataProvider>(context, listen: false).addResult(result);

//     // Update UI
//     setState(() {
//       _running = false;
//     });

//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Prediction saved to app data')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     // model labels are ["W","N1","N2","N3","REM"]; we'll show display versions below
//     final modelLabels = AttnSleep.labels;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Sleep Stage Predictor')),
//       backgroundColor: Colors.blue[800],
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (!_modelLoaded)
//               const Text('Loading model...', style: TextStyle(color: Colors.white)),
//             if (_modelLoaded && !_running)
//               ElevatedButton(
//                 onPressed: () => _runDummyNight(epochs: 480),
//                 child: const Text('Run Dummy Full-Night Prediction'),
//               ),
//             if (_running) ...[
//               LinearProgressIndicator(value: _progress),
//               const SizedBox(height: 8),
//               Text(
//                 '${(_progress * 100).toStringAsFixed(0)}% completed',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ],
//             const SizedBox(height: 16),
//             if (_lastLabel != null) ...[
//               Text(
//                 'Last epoch predicted: $_lastLabel', // already mapped to display key
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//               ),
//               const SizedBox(height: 8),
//             ],
//             if (_lastProbs.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: List.generate(_lastProbs.length, (i) {
//                   final display = LabelMap.toDisplay(modelLabels[i]); // "W" -> "Awake"
//                   return Text(
//                     '$display: ${(_lastProbs[i] * 100).toStringAsFixed(1)}%',
//                     style: const TextStyle(color: Colors.white),
//                   );
//                 }),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
