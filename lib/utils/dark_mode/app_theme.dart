// ignore_for_file: avoid_classes_with_only_static_members, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shabadguru/utils/colors.dart';

class Styles {
  // ignore: avoid_positional_boolean_parameters
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: vividPurpleMaterialColor,
      primaryColor: darkBlueColor,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 20,
          height: .8,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      fontFamily: 'Roboto',
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static const MaterialColor vividPurpleMaterialColor =
      MaterialColor(0xFF3204A3, {
    50: Color.fromRGBO(50, 4, 163, .1),
    100: Color.fromRGBO(50, 4, 163, .2),
    200: Color.fromRGBO(50, 4, 163, .3),
    300: Color.fromRGBO(50, 4, 163, .4),
    400: Color.fromRGBO(50, 4, 163, .5),
    500: Color.fromRGBO(50, 4, 163, .6),
    600: Color.fromRGBO(50, 4, 163, .7),
    700: Color.fromRGBO(50, 4, 163, .8),
    800: Color.fromRGBO(50, 4, 163, .9),
    900: Color.fromRGBO(50, 4, 163, 1),
  });
}
