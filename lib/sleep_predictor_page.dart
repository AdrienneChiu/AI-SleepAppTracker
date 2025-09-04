import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:typed_data';

import 'attnsleep.dart'; // <-- Import your ML helper

class SleepPredictorPage extends StatefulWidget {
  const SleepPredictorPage({super.key});

  @override
  State<SleepPredictorPage> createState() => _SleepPredictorPageState();
}

class _SleepPredictorPageState extends State<SleepPredictorPage> {
  final attnSleep = AttnSleep(); // ML model wrapper
  List<double> probs = [];
  String? predictedLabel;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await attnSleep.load();
    setState(() {}); // trigger rebuild once loaded
  }

  void _runDummyPrediction() {
    const T = 3000; // input length
    final randomData = Float32List.fromList(
      List<double>.generate(T, (_) => math.Random().nextDouble()),
    );

    final (label, idx, probabilities) = attnSleep.predict(randomData);

    setState(() {
      predictedLabel = label;
      probs = probabilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Stage Predictor")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (probs.isEmpty)
              ElevatedButton(
                onPressed: _runDummyPrediction,
                child: const Text("Run Dummy Prediction"),
              )
            else
              Column(
                children: [
                  Text(
                    "Predicted Stage: $predictedLabel",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < probs.length; i++)
                    Text(
                      "${attnSleep.labels[i]}: ${(probs[i] * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
