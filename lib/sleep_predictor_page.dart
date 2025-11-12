// lib/sleep_predictor_page.dart
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attnsleep.dart'; 
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


  Future<void> _runFullNightPrediction({int epochs = 480}) async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Model not loaded')));
      return;
    }

    setState(() {
      _running = true;
      _progress = 0;
      _lastProbs = [];
      _lastLabel = null;
    });

    final provider = Provider.of<SleepDataProvider>(context, listen: false);
    final preds = <int>[]; // collect model indices 0..4

    for (int e = 0; e < epochs; e++) {
      Float32List eegData;

      // Try to get real EEG from provider
      if (provider.currentEEG != null &&
          provider.currentEEG!.length >= _runner.windowLength) {
        eegData = provider.currentEEG!;
      } else {
        // fallback dummy
        eegData = Float32List.fromList(
          List<double>.generate(_runner.windowLength, (_) => math.Random().nextDouble()),
        );
      }


      final res = _runner.predict(eegData);
      final int idx = res.$2;           // 0..4
      final List<double> probs = res.$3; // probabilities per stage

      preds.add(idx);


      if (e % 10 == 0) {
        setState(() {
          _progress = (e + 1) / epochs;
          _lastProbs = probs;
          _lastLabel = LabelMap.toDisplay(res.$1); // "W" -> "Awake"
        });
        await Future.delayed(Duration.zero);
      }
    }

    // Final progress
    setState(() {
      _progress = 1.0;
    });

    // Aggregate indices into minutes per stage
    final durations = aggregateSleepStages(preds); // -> {"Awake": x, "N1":..., "REM":...}

    // Store result in provider
    final result = SleepStageResult(
      timestamp: DateTime.now(),
      stageDurations: durations,
    );
    provider.addResult(result);

    setState(() {
      _running = false;
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
                onPressed: () => _runFullNightPrediction(epochs: 480),
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
