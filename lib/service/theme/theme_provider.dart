import 'package:expense_tracker/service/theme/darkmode.dart';
import 'package:expense_tracker/service/theme/lightmode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //initially start with light mode
  ThemeData _themeData = lightMode;

  //getter method to access theme from other parts of the code
  ThemeData get themeData => _themeData;

  //getter method to see if we are in dark mode
  bool get isDarkMode => _themeData == darkMode;

  //setter to set the ew theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
