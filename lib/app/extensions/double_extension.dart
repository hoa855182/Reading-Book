extension DoubleExtension on double? {
  String toRoundedString({int decimalPlaces = 1}) {
    if (this == null) {
      return "";
    }
    return this!.toStringAsFixed(decimalPlaces);
  }
}
