
// Dark theme preference manager for persistent theme storage
import 'package:shared_preferences/shared_preferences.dart';

// Class for managing dark theme preferences in local storage
class DarkThemePreference {

  // ignore: constant_identifier_names
  static const THEME_STATUS = "THEMESTATUS"; // Key for theme status
  // ignore: constant_identifier_names
  static const MANUAL_OFF_DARK = "MANUALOFFDARK"; // Key for manual dark theme override

  // Save dark theme preference to local storage
  // ignore: avoid_positional_boolean_parameters
  Future<void> setDarkTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    prefs.setBool(THEME_STATUS, value); // Save theme status
  }

  // Save system dark theme override preference
  // ignore: avoid_positional_boolean_parameters
  Future<void> setSystemDarkThemeOff(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    prefs.setBool(MANUAL_OFF_DARK, value); // Save manual override status
  }

  // Get system dark theme override preference
  Future<bool?> getSystemDarkTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    return prefs.getBool(MANUAL_OFF_DARK); // Get manual override status
  }

  // Get current theme preference
  Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    return prefs.getBool(THEME_STATUS) ?? false; // Get theme status, default to false
  }
}
