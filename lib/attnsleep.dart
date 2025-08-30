import 'dart:math' as math;
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class AttnSleep {
  AttnSleep({this.windowLength = 3000});

  final int windowLength; // T = 3000 by default
  late final Interpreter _interpreter;

  static const labels = ["W","N1","N2","N3","REM"];

  Future<void> load() async {
    final opts = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset(
      'assets/models/attnsleep_fp16.tflite',
      options: opts,
    );

    // Model’s input is dynamic [-1,1,-1]; set it once to [1,1,T]
    _interpreter.resizeInputTensor(0, [1, 1, windowLength]);
    _interpreter.allocateTensors();
  }

  List<double> _softmax(List<double> logits) {
    final m = logits.reduce(math.max);
    final exps = logits.map((v) => math.exp(v - m)).toList();
    final sum = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sum).toList();
  }

  /// eegWindow must be Float32List of length T, already normalized (like your .npz).
  (String, int, List<double>) predict(Float32List eegWindow) {
    if (eegWindow.length != windowLength) {
      throw ArgumentError('Expected window length $windowLength, got ${eegWindow.length}');
    }

    // Input shape [1,1,T]
    final input = [
      [eegWindow.toList()]
    ];

    // Output [1,5]
    final output = _Reshape(List.filled(5, 0.0)).reshape([1, 5]);
    _interpreter.run(input, output);

    final logits = List<double>.from(output[0]);
    final probs = _softmax(logits);

    var bestIdx = 0;
    var bestVal = probs[0];
    for (var i = 1; i < probs.length; i++) {
      if (probs[i] > bestVal) { bestVal = probs[i]; bestIdx = i; }
    }
    return (labels[bestIdx], bestIdx, probs);
  }
}

// Tiny reshape helper for [1,5]
extension _Reshape on List {
  List reshape(List<int> dims) {
    if (dims.length == 2 && dims[0] == 1 && dims[1] == 5 && length == 5) return [this];
    throw ArgumentError('Unexpected reshape request: dims=$dims, length=$length');
  }
}
