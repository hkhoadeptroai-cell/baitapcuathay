import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final instance = AppSettings._();

  ThemeMode themeMode = ThemeMode.light;
  Color accent = const Color(0xFF2F5BEA);
  double fontScale = 1;
  bool remind = true, sound = true, dailySummary = false;

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }
}
