
class SleepStageResult {
  final DateTime timestamp;
  final Map<String, double> stageDurations; // minutes per stage

  SleepStageResult({
    required this.timestamp,
    required this.stageDurations,
  });
}
