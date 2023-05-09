import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modbus_app/utils/utils.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._();

  void init() {
    try {
      _isDarkTheme = localStorage.get('theme') == 'true';
    } catch (e) {
      log(e.toString());
      _isDarkTheme = false;
    }
  }

  static final instance = ThemeController._();

  bool _isDarkTheme = true;
  bool _isInCooldown = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() async {
    if (_isInCooldown) return;
    _isInCooldown = true;
    _isDarkTheme = !_isDarkTheme;
    await localStorage.put('theme', _isDarkTheme ? 'true' : 'false');
    notifyListeners();
    _isInCooldown = false;
  }
}
