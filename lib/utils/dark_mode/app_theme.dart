// App theme configuration for light and dark modes
// ignore_for_file: avoid_classes_with_only_static_members, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shabadguru/utils/colors.dart';

// Theme styles and configuration for the ShabadGuru app
class Styles {
  // Create theme data based on dark/light mode
  // ignore: avoid_positional_boolean_parameters
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: vividPurpleMaterialColor, // Primary color swatch
      primaryColor: darkBlueColor, // Primary color
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 20, // Label font size
          height: .8, // Label height
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Enabled border color
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Focused border color
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Default border color
        ),
      ),
      fontFamily: 'Roboto', // Default font family
      brightness: isDarkTheme ? Brightness.dark : Brightness.light, // Theme brightness
      visualDensity: VisualDensity.adaptivePlatformDensity, // Adaptive platform density
    );
  }

  // Material color swatch for purple theme
  static const MaterialColor vividPurpleMaterialColor =
      MaterialColor(0xFF3204A3, {
    50: Color.fromRGBO(50, 4, 163, .1), // Lightest shade
    100: Color.fromRGBO(50, 4, 163, .2), // Very light shade
    200: Color.fromRGBO(50, 4, 163, .3), // Light shade
    300: Color.fromRGBO(50, 4, 163, .4), // Light-medium shade
    400: Color.fromRGBO(50, 4, 163, .5), // Medium shade
    500: Color.fromRGBO(50, 4, 163, .6), // Primary shade
    600: Color.fromRGBO(50, 4, 163, .7), // Medium-dark shade
    700: Color.fromRGBO(50, 4, 163, .8), // Dark shade
    800: Color.fromRGBO(50, 4, 163, .9), // Very dark shade
    900: Color.fromRGBO(50, 4, 163, 1), // Darkest shade
  });
}
