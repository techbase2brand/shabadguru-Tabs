
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {

  // ignore: constant_identifier_names
  static const THEME_STATUS = "THEMESTATUS";
  // ignore: constant_identifier_names
  static const MANUAL_OFF_DARK = "MANUALOFFDARK";

  // ignore: avoid_positional_boolean_parameters
  Future<void> setDarkTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }


  // ignore: avoid_positional_boolean_parameters
  Future<void> setSystemDarkThemeOff(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(MANUAL_OFF_DARK, value);
  }

  Future<bool?> getSystemDarkTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(MANUAL_OFF_DARK);
  }

  Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
