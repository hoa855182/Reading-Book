import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return int.parse(hexColor, radix: 16);
    } catch (e) {
      return int.parse('FFFFFFFFF', radix: 16);
    }

  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
