import 'package:flutter/material.dart';
import 'package:shabadguru/utils/dark_mode/dark_theme_pref.dart';

class DarkThemeProvider with ChangeNotifier {

  DarkModeChangeListener darkModeChangeListener;

  DarkThemeProvider(this.darkModeChangeListener);

  DarkThemePreference darkThemePreference = DarkThemePreference();

  bool _systemDarkTheme = false;


  bool get systemDarkTheme => _systemDarkTheme;

  set systemDarkTheme(bool value) {
    _systemDarkTheme = value;
    darkThemePreference.setSystemDarkThemeOff(value);
    darkModeChangeListener.onChanged(value);
  }

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
class DarkModeChangeListener {
  // ignore: avoid_positional_boolean_parameters
  void onChanged(bool value) {}
  
}
