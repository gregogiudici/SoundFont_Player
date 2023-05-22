import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class ThemeClass {
  Color lightPrimary = Colors.green;
  Color lightOnPrimary = Colors.white;

  Color lightSecondary = Colors.green;
  Color lightOnSecondary = Colors.white;

  Color lightError = Colors.red;
  Color lightOnError = Colors.white;

  Color lightBackground = Colors.blue;
  Color lightOnBackground = Colors.white;

  Color lightSurface = Colors.pink;
  Color lightOnSurface = Colors.white;

  //darkmode
  Color darkPrimary = Colors.red;
  Color darkOnPrimary = Colors.white;

  Color darkSecondary = Colors.green;
  Color darkOnSecondary = Colors.white;

  Color darkError = Colors.red;
  Color darkOnError = Colors.white;

  Color darkBackground = Colors.blue;
  Color darkOnBackground = Colors.white;

  Color darkSurface = Colors.white;
  Color darkOnSurface = Colors.black;


  static ThemeData lightTheme = ThemeData(
  //  primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themeClass.lightPrimary,
      onPrimary: _themeClass.lightOnPrimary,
      secondary: _themeClass.lightSecondary,
      onSecondary: _themeClass.lightOnSecondary,
      error: _themeClass.lightError,
      onError: _themeClass.lightOnError,
      background: _themeClass.lightBackground,
      onBackground: _themeClass.lightOnBackground,
      surface: _themeClass.lightSurface,
      onSurface: _themeClass.lightSurface),
  );
  static ThemeData darkTheme = ThemeData(
    //primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
        primary: _themeClass.darkPrimary,
        onPrimary: _themeClass.darkOnPrimary,
        secondary: _themeClass.darkSecondary,
        onSecondary: _themeClass.darkOnSecondary,
        error: _themeClass.darkError,
        onError: _themeClass.darkOnError,
        background: _themeClass.darkBackground,
        onBackground: _themeClass.darkOnBackground,
        surface: _themeClass.darkSurface,
        onSurface: _themeClass.darkSurface),

  );
}
ThemeClass _themeClass = ThemeClass();