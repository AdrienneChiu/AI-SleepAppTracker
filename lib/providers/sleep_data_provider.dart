import 'package:flutter/material.dart';
import '../models/sleep_stage_result.dart';

class SleepDataProvider extends ChangeNotifier {
  final List<SleepStageResult> _results = [];

  List<SleepStageResult> get results => List.unmodifiable(_results);

  SleepStageResult? get latest => _results.isEmpty ? null : _results.last;

  void addResult(SleepStageResult r) {
    _results.add(r);
    notifyListeners();
  }

  // optional helpers:
  void clear() {
    _results.clear();
    notifyListeners();
  }
}
