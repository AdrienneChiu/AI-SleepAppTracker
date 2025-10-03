/// Map model labels to display labels used in the UI/provider.
class LabelMap {
  static const Map<String, String> modelToDisplay = {
    "W": "Awake",
    "N1": "N1",
    "N2": "N2",
    "N3": "N3",
    "REM": "REM",
  };

  static String toDisplay(String modelLabel) =>
      modelToDisplay[modelLabel] ?? modelLabel;
}
