// Dark theme provider for managing app theme state
import 'package:flutter/material.dart';
import 'package:shabadguru/utils/dark_mode/dark_theme_pref.dart';

// Provider class for managing dark theme state and system theme preferences
class DarkThemeProvider with ChangeNotifier {

  DarkModeChangeListener darkModeChangeListener; // Listener for theme changes

  DarkThemeProvider(this.darkModeChangeListener); // Constructor with listener

  DarkThemePreference darkThemePreference = DarkThemePreference(); // Theme preference manager

  bool _systemDarkTheme = false; // System dark theme state

  // Getter for system dark theme
  bool get systemDarkTheme => _systemDarkTheme;

  // Setter for system dark theme
  set systemDarkTheme(bool value) {
    _systemDarkTheme = value; // Update internal state
    darkThemePreference.setSystemDarkThemeOff(value); // Save to preferences
    darkModeChangeListener.onChanged(value); // Notify listener
  }

  bool _darkTheme = false; // Dark theme state

  // Getter for dark theme
  bool get darkTheme => _darkTheme;

  // Setter for dark theme
  set darkTheme(bool value) {
    _darkTheme = value; // Update internal state
    darkThemePreference.setDarkTheme(value); // Save to preferences
    notifyListeners(); // Notify UI listeners
  }
}
// Interface for listening to dark mode changes
class DarkModeChangeListener {
  // ignore: avoid_positional_boolean_parameters
  void onChanged(bool value) {} // Called when dark mode state changes
  
}
