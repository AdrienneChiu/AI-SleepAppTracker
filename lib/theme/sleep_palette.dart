// Author: Adrienne Chiu (2025)
import 'package:flutter/material.dart';

/// Canonical display order used across all charts & boxes.
class SleepStages {
  /// Display keys that your UI expects everywhere:
  /// ["Awake","N1","N2","N3","REM"]
  static const List<String> order = ["Awake", "N1", "N2", "N3", "REM"];

  /// Unified colours for each stage (use these in all widgets).
  static const Map<String, Color> color = {
    "Awake": Color(0xFFF1A5BE), // pink
    "N1":    Color(0xFFA78EEB), // purple
    "N2":    Color(0xFF4CAF50), // green
    "N3":    Color(0xFF5F9FE7), // blue
    "REM":   Color(0xFFD1B043), // orange
  };
}
