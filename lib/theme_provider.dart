
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get getTheme => _themeData;

  void toggleTheme(bool isDark) {
    _themeData = isDark
        ? ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Color(0xFF1B4D3E),
            appBarTheme: AppBarTheme(
              color: Color(0xFF1B4D3E),
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.white),
            ),
          )
        : ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xFF1B4D3E),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              color: Color(0xFF1B4D3E),
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
              bodyText2: TextStyle(color: Color(0xFF1B4D3E)),
            ),
          );
    notifyListeners();
  }
}