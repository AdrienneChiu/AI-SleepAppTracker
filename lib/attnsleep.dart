import 'dart:typed_data';
import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';

class AttnSleep {
  late Interpreter interpreter;
  final labels = ["W", "N1", "N2", "N3", "REM"];

  Future<void> load() async {
    interpreter = await Interpreter.fromAsset('models/attnsleep_fp16.tflite');
  }

  (String, int, List<double>) predict(Float32List input) {
    final mean = input.reduce((a, b) => a + b) / input.length;
    final variance = input.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) / input.length;
    final std = math.sqrt(variance);
    final zscored = input.map((v) => (v - mean) / (std == 0 ? 1 : std)).toList();

    final reshaped = [[zscored]]; // shape [1,1,T]
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    interpreter.resizeInputTensor(0, [1, 1, input.length]);
    interpreter.allocateTensors();
    interpreter.run(reshaped, output);

    final probs = List<double>.from(output[0]);
    final maxIdx = probs.indexOf(probs.reduce(math.max));
    final predicted = labels[maxIdx];

    return (predicted, maxIdx, probs);
  }
}
