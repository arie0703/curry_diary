import 'package:flutter/material.dart';

// カスタムのMaterial Color Classを作る
class CommonColor {
  static const int _primaryValue = 0xFFB35400;
  static const MaterialColor primaryColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFFFF2CD),
      100: Color(0xFFFFD6ae),
      200: Color(0xFFFFCC9A),
      300: Color(0xFFFFA64D),
      400: Color(0xFFFF8000),
      500: Color(0xFFCC6000),
      600: Color(_primaryValue),
      700: Color(0xFFB35400),
      800: Color(0xFF9A4800),
      900: Color(0xFF803C00),
    },
  );
}
