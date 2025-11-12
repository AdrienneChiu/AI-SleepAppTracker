// Author: Adrienne Chiu (2025)
// Converts a list of predicted stage indexes (0..4) into minutes per stage.
import '../theme/sleep_palette.dart';

Map<String, double> aggregateSleepStages(
  List<int> predictions, {
  int epochSeconds = 30,
}) {
  // canonical stage order
  final labels = SleepStages.order; // ["Awake","N1","N2","N3","REM"]

  // init durations map with 0.0
  final stageDurations = {for (var l in labels) l: 0.0};

  final epochMinutes = epochSeconds / 60.0;

  for (final idx in predictions) {
    if (idx >= 0 && idx < labels.length) {
      final label = labels[idx];
      stageDurations[label] = stageDurations[label]! + epochMinutes;
    }
  }

  return stageDurations;
}
