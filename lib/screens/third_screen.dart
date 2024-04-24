// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ThirdScreen extends StatelessWidget {
  // Determine background image based on time of day
  String getBackgroundImage() {
    var hour = DateTime.now().hour;
    return hour >= 6 && hour < 18 ? 'assets/images/background.png' : 'assets/images/background2.png';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            getBackgroundImage(),
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              'Welcome to the Third Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
