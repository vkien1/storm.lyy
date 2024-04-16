// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  get getTheme => _themeData;

  void toggleTheme(bool isDark) {
    _themeData = isDark
        ? ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
            primaryColor: Colors.grey[900], // Dark grey
            scaffoldBackgroundColor: Colors.grey[850],
            appBarTheme: AppBarTheme(
              color: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey[800]),
          )
        : ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.grey,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              foregroundColor: Colors.grey[600],
              elevation: 0,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey[600],
            ),
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.grey[600]),
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[600],
            ),
            primaryIconTheme: IconThemeData(
              color: Colors.grey[600],
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
          );
    notifyListeners();
  }
}
