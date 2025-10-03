import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class AttnSleep {
  AttnSleep({this.windowLength = 3000});

  /// We allow this to change after inspecting the model (for fixed shapes).
  int windowLength;

  late final Interpreter _interpreter;

  /// UI label order (probabilities should be of length 5).
  static const labels = ["W", "N1", "N2", "N3", "REM"];

  Future<void> load() async {
    // 1) Verify the asset actually exists at this key
    try {
      final data = await rootBundle.load('assets/models/attnsleep_fp16.tflite');
      debugPrint('[AttnSleep] Asset OK, bytes=${data.lengthInBytes}');
    } catch (e) {
      debugPrint('[AttnSleep] Asset load failed: $e');
      rethrow;
    }

    // 2) Create interpreter
    final opts = InterpreterOptions()..threads = 2;
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/attnsleep_fp16.tflite',
        options: opts,
      );
      debugPrint('[AttnSleep] Interpreter created');
    } catch (e) {
      debugPrint('[AttnSleep] Interpreter.fromAsset failed: $e');
      rethrow;
    }

    // 3) Inspect shapes (no resize yet)
    List<int> inShape;
    List<int> outShape;
    try {
      final inT = _interpreter.getInputTensors().first;
      final outT = _interpreter.getOutputTensors().first;
      inShape = List<int>.from(inT.shape);
      outShape = List<int>.from(outT.shape);
      debugPrint('[AttnSleep] INPUT  shape=$inShape  type=${inT.type}');
      debugPrint('[AttnSleep] OUTPUT shape=$outShape type=${outT.type}');

      // If it’s a fixed-shape model, adopt its length so our UI/dummy match
      if (!inShape.contains(-1)) {
        // Heuristic: take the largest dim as T (covers [1,1,T], [1,T,1], [1,T], [T])
        final t = inShape.reduce((a, b) => a > b ? a : b);
        if (t > 0) {
          windowLength = t;
          debugPrint('[AttnSleep] Using windowLength=$windowLength (from fixed input shape)');
        }
      }
    } catch (e) {
      debugPrint('[AttnSleep] Tensor inspection failed: $e');
      rethrow;
    }

    // 4) Only resize if the model declared a dynamic dim (-1)
    try {
      if (inShape.contains(-1)) {
        // Choose a compatible shape; prefer 3D if rank==3
        if (inShape.length == 3) {
          // Either [1, 1, -1] or [1, -1, 1] are typical; we set [1,1,T]
          _interpreter.resizeInputTensor(0, [1, 1, windowLength]);
          debugPrint('[AttnSleep] Resized dynamic input to [1,1,$windowLength]');
        } else if (inShape.length == 2) {
          _interpreter.resizeInputTensor(0, [1, windowLength]);
          debugPrint('[AttnSleep] Resized dynamic input to [1,$windowLength]');
        } else if (inShape.length == 1) {
          _interpreter.resizeInputTensor(0, [windowLength]);
          debugPrint('[AttnSleep] Resized dynamic input to [$windowLength]');
        } else {
          debugPrint('[AttnSleep] Dynamic input has unexpected rank=${inShape.length}; skipping resize');
        }
      } else {
        debugPrint('[AttnSleep] Fixed-shape model; not resizing input.');
      }
    } catch (e) {
      debugPrint('[AttnSleep] resizeInputTensor failed: $e');
      rethrow;
    }

    // 5) Allocate tensors
    try {
      _interpreter.allocateTensors();
      debugPrint('[AttnSleep] allocateTensors OK');
    } catch (e) {
      // If we fail here on iOS, your model may require Select TF Ops.
      // See Podfile note in our chat.
      debugPrint('[AttnSleep] allocateTensors failed: $e');
      rethrow;
    }
  }

  List<double> _softmax(List<double> logits) {
    final m = logits.reduce(math.max);
    final exps = logits.map((v) => math.exp(v - m)).toList();
    final sum = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sum).toList();
  }

  /// Predict for one window (Float32 length == windowLength).
  /// Returns (label, bestIdx, probs[5]).
  (String, int, List<double>) predict(Float32List eegWindow) {
    if (eegWindow.length != windowLength) {
      throw ArgumentError('Expected window length $windowLength, got ${eegWindow.length}');
    }

    final inShape = _interpreter.getInputTensors().first.shape;
    dynamic input;

    // Pack input according to the model’s actual shape
    if (inShape.length == 3) {
      // Common: [1,1,T]  or  [1,T,1]
      if (inShape[0] == 1 && inShape[1] == 1 && inShape[2] == windowLength) {
        // [1,1,T]
        input = [
          [eegWindow.toList()]
        ];
      } else if (inShape[0] == 1 && inShape[1] == windowLength && inShape[2] == 1) {
        // [1,T,1]
        input = [
          [for (final v in eegWindow) [v]]
        ];
      } else {
        throw StateError('Unsupported 3D input shape $inShape for T=$windowLength');
      }
    } else if (inShape.length == 2) {
      // [1,T]
      if (inShape[0] == 1 && inShape[1] == windowLength) {
        input = [eegWindow.toList()];
      } else {
        throw StateError('Unsupported 2D input shape $inShape for T=$windowLength');
      }
    } else if (inShape.length == 1) {
      // [T]
      if (inShape[0] == windowLength) {
        input = eegWindow.toList();
      } else {
        throw StateError('Unsupported 1D input shape $inShape for T=$windowLength');
      }
    } else {
      throw StateError('Unsupported input rank ${inShape.length}');
    }

    // Prepare output buffer
    final outShape = _interpreter.getOutputTensors().first.shape;
    dynamic output;
    if (outShape.length == 2 && outShape[0] == 1 && outShape[1] == 5) {
      output = List.generate(1, (_) => List<double>.filled(5, 0.0));
    } else if (outShape.length == 1 && outShape[0] == 5) {
      output = List<double>.filled(5, 0.0);
    } else {
      // Fall back to [1,5]
      output = List.generate(1, (_) => List<double>.filled(5, 0.0));
    }

    _interpreter.run(input, output);

    // Extract logits
    List<double> logits;
    if (output is List && output.isNotEmpty && output[0] is List) {
      logits = List<double>.from(output[0] as List);
    } else {
      logits = List<double>.from(output as List);
    }

    final probs = _softmax(logits);
    var bestIdx = 0, bestVal = probs[0];
    for (var i = 1; i < probs.length; i++) {
      if (probs[i] > bestVal) { bestVal = probs[i]; bestIdx = i; }
    }
    return (labels[bestIdx], bestIdx, probs);
  }
}
