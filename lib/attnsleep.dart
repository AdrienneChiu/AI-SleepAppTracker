import 'dart:math' as math;
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class AttnSleep {
  AttnSleep({this.windowLength = 3000});

  final int windowLength; // instance property
  late final Interpreter _interpreter;

  static const labels = ["W", "N1", "N2", "N3", "REM"]; // keep static

  Future<void> load() async {
    final opts = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset(
      'models/attnsleep_fp16.tflite', 
      options: opts,
    );

    _interpreter.resizeInputTensor(0, [1, 1, windowLength]);
    _interpreter.allocateTensors();
  }

  List<double> _softmax(List<double> logits) {
    final m = logits.reduce(math.max);
    final exps = logits.map((v) => math.exp(v - m)).toList();
    final sum = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sum).toList();
  }

  /// eegWindow must be Float32List of length T
  (String, int, List<double>) predict(Float32List eegWindow) {
    if (eegWindow.length != windowLength) {
      throw ArgumentError('Expected window length $windowLength, got ${eegWindow.length}');
    }

    final input = [
      [eegWindow.toList()]
    ];

    final output = _Reshape(List.filled(5, 0.0)).reshape([1, 5]);
    _interpreter.run(input, output);

    final logits = List<double>.from(output[0]);
    final probs = _softmax(logits);

    var bestIdx = 0;
    var bestVal = probs[0];
    for (var i = 1; i < probs.length; i++) {
      if (probs[i] > bestVal) {
        bestVal = probs[i];
        bestIdx = i;
      }
    }
    return (labels[bestIdx], bestIdx, probs);
  }
}

extension _Reshape on List {
  List reshape(List<int> dims) {
    if (dims.length == 2 && dims[0] == 1 && dims[1] == 5 && length == 5) return [this];
    throw ArgumentError('Unexpected reshape request: dims=$dims, length=$length');
  }
}
