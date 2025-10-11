import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import '../models/sleep_stage_result.dart';

class SleepDataProvider extends ChangeNotifier {
  final List<SleepStageResult> _results = [];

  // Latest EEG window
  Float32List? _currentEEG;

  List<SleepStageResult> get results => List.unmodifiable(_results);

  SleepStageResult? get latest => _results.isEmpty ? null : _results.last;

  void addResult(SleepStageResult r) {
    _results.add(r);
    notifyListeners();
  }

  void clear() {
    _results.clear();
    notifyListeners();
  }

  /// Set new EEG data (from your device or source)
  void setEEG(Float32List data) {
    _currentEEG = data;
    notifyListeners();
  }

  /// Get current EEG; if none exists, return dummy placeholder
  Float32List get currentEEG {
    if (_currentEEG != null) return _currentEEG!;
    // fallback: dummy zero/random data
    return Float32List.fromList(List.generate(3000, (_) => math.Random().nextDouble()));
  }
}
