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
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white), // Set text color to white
            ),
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
          )
        : ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.grey,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white), // Set text color to white
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            primaryIconTheme: IconThemeData(
              color: Colors.white,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
          );
    notifyListeners();
  }
}
