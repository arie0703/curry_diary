import 'dart:ui';

import 'package:flutter/material.dart';

class UserStatus with ChangeNotifier {
  String _name = "ゲスト";
  String get name => _name;

  void setUserInfo(name) {
    _name = name;
    notifyListeners();
  }
}
