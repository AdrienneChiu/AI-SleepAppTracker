// Author: Adrienne Chiu (2025)
import 'dart:math';

/// Generates a realistic minutes-per-stage map that sums to ~7–9 hours.
/// Keys match your UI: ["Awake","N1","N2","N3","REM"].
Map<String, double> syntheticNight({int seed = 0}) {
  final rnd = Random(seed);

  // total minutes 7–9h
  final total = 420 + rnd.nextInt(120); // 420..540

  // base proportions (rough adult)
  double pAwake = 0.07 + rnd.nextDouble() * 0.03; // 7–10%
  double pN1    = 0.05 + rnd.nextDouble() * 0.03; // 5–8%
  double pN2    = 0.45 + rnd.nextDouble() * 0.07; // 45–52%
  double pN3    = 0.18 + rnd.nextDouble() * 0.07; // 18–25%
  double pREM   = 1.0 - (pAwake + pN1 + pN2 + pN3);

  // clamp REM to plausible range then renormalize
  pREM = pREM.clamp(0.15, 0.25);
  final sum = pAwake + pN1 + pN2 + pN3 + pREM;
  pAwake /= sum; pN1 /= sum; pN2 /= sum; pN3 /= sum; pREM /= sum;

  double toMin(double p) => (p * total).roundToDouble();

  return {
    "Awake": toMin(pAwake),
    "N1":    toMin(pN1),
    "N2":    toMin(pN2),
    "N3":    toMin(pN3),
    "REM":   toMin(pREM),
  };
}
