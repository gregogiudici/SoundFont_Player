import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';





class MyColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colors',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.orange,
          onPrimary: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.white,
          primaryContainer: Colors.orange,
          error: Colors.black,
          onError: Colors.white,
          background: Colors.blue,
          onBackground: Colors.white,
          surface: Colors.pink,
          onSurface: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.white,
          primaryContainer: Colors.pink,
          error: Colors.black,
          onError: Colors.white,
          background: Colors.blue,
          onBackground: Colors.white,
          surface: Colors.pink,
          onSurface: Colors.white,
        ),
      ),
    );
  }
}