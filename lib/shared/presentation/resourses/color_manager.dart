import 'package:flutter/material.dart';

class ColorManager {
  ColorManager._();
  static Color primary = HexColor.fromHex('#343541');
  static Color primaryOpacity70 = HexColor.fromHex('#46343541');
  static Color accentColor = HexColor.fromHex('#34D1B6');
  static Color darkPrimary = HexColor.fromHex('#007A50');
  static Color darkGrey = HexColor.fromHex('#525252');
  static Color grey = HexColor.fromHex('#B0B0B0');
  static Color lightGrey = HexColor.fromHex('#737477');
  static Color grey1 = HexColor.fromHex('#737477');
  static Color white = HexColor.fromHex('#ffffff');
  static Color error = HexColor.fromHex('#ff0000');
  static Color fillColor = HexColor.fromHex('#28A68C5B');
  static Color cpationColor = Colors.white;
  static Color highlight = HexColor.fromHex("#D6DAFF");

  static Color logout = HexColor.fromHex('#ff0000');
  static Color hintColor = Colors.white54;
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    hexString = hexString.replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF' + hexString;
    }
    return Color(int.parse(hexString, radix: 16));
  }
}
