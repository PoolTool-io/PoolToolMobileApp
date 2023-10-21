import 'package:flutter/material.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool? _darkTheme;

  bool? get darkTheme => _darkTheme;

  ThemeProvider() {
    getTheme();
  }

  Future<void> getTheme() async {
    _darkTheme = await darkThemePreference.getTheme();
    notifyListeners();
  }

  set darkTheme(bool? value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value!);
    notifyListeners();
  }
}

class DarkThemePreference {
  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.THEME_STATUS) ?? false;
  }
}
