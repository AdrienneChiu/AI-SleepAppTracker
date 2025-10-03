import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class AttnSleep {
  AttnSleep({this.windowLength = 3000});

  int windowLength;
  late final Interpreter _interpreter;

  static const labels = ["W", "N1", "N2", "N3", "REM"];

  Future<void> load() async {
    try {
      final data = await rootBundle.load('assets/models/attnsleep_fp16.tflite');
      debugPrint('Model bytes: ${data.lengthInBytes}');
    } catch (e) {
      debugPrint('Asset load failed: $e');
      rethrow;
    }

    final opts = InterpreterOptions()..threads = 2;

    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/attnsleep_fp16.tflite',
        options: opts,
      );

      final inTensor = _interpreter.getInputTensors().first;
      final inShape = List<int>.from(inTensor.shape);
      debugPrint('TFLite input shape: $inShape  type: ${inTensor.type}');

      // Handle fixed vs dynamic shapes
      if (inShape.any((d) => d == -1)) {
        if (inShape.length == 3) {
          _interpreter.resizeInputTensor(0, [1, 1, windowLength]);
        } else if (inShape.length == 2) {
          _interpreter.resizeInputTensor(0, [1, windowLength]);
        } else if (inShape.length == 1) {
          _interpreter.resizeInputTensor(0, [windowLength]);
        }
      } else {
        if (inShape.length == 3) {
          windowLength = inShape.last;
        } else if (inShape.length == 2) {
          windowLength = inShape.last;
        } else if (inShape.length == 1) {
          windowLength = inShape.first;
        }
      }

      _interpreter.allocateTensors();

      final outTensor = _interpreter.getOutputTensors().first;
      debugPrint('TFLite output shape: ${outTensor.shape}  type: ${outTensor.type}');
    } catch (e) {
      debugPrint('Interpreter load failed: $e');
      rethrow;
    }
  }

  List<double> _softmax(List<double> logits) {
    final m = logits.reduce(math.max);
    final exps = logits.map((v) => math.exp(v - m)).toList();
    final sum = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sum).toList();
  }

  (String, int, List<double>) predict(Float32List eegWindow) {
    if (eegWindow.length != windowLength) {
      throw ArgumentError('Expected window length $windowLength, got ${eegWindow.length}');
    }

    final inShape = _interpreter.getInputTensors().first.shape;
    dynamic input;

    if (inShape.length == 3) {
      if (inShape[1] == 1 && inShape[2] == windowLength) {
        input = [
          [eegWindow.toList()] // [1,1,T]
        ];
      } else if (inShape[1] == windowLength && inShape[2] == 1) {
        input = [
          [for (final v in eegWindow) [v]] // [1,T,1]
        ];
      }
    } else if (inShape.length == 2) {
      input = [eegWindow.toList()]; // [1,T]
    } else {
      input = eegWindow.toList(); // [T]
    }

    final outShape = _interpreter.getOutputTensors().first.shape;
    dynamic output;
    if (outShape.length == 2 && outShape[0] == 1 && outShape[1] == 5) {
      output = List.generate(1, (_) => List<double>.filled(5, 0.0));
    } else {
      output = List<double>.filled(5, 0.0);
    }

    _interpreter.run(input, output);

    List<double> logits;
    if (output is List && output.isNotEmpty && output[0] is List) {
      logits = List<double>.from(output[0] as List);
    } else {
      logits = List<double>.from(output as List);
    }

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
