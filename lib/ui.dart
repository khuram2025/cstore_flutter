import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // Ensure you have the flutter_svg package added to your pubspec.yaml
// Define colors using const Color() constructor
const grey = Color(0xFF9F9F9E);
const amberSea = Color(0xFFFC8019);
const green = Color(0xFF09AA29);

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex() => '#${value.toRadixString(16).substring(2, 8)}';
}

class AppColors {
  static final Color accentColor = HexColor.fromHex('#FC8019');
  static final Color popColor = HexColor.fromHex('#09AA29');
  static final Color highlightColor = HexColor.fromHex('#FFF2E8');
  static final Color typeDarkColor = HexColor.fromHex('#171826');
  static final Color typeFadedColor = HexColor.fromHex('#9F9F9E');
  static final Color separatorsColor = HexColor.fromHex('#F5F5F5');
}