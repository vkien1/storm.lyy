// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  Position? _currentPosition;

  void _setPageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Text
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            //Display welcome message before displaying weather widgets
            _buildDecoratedWidget(_buildWelcomeMessage(), ThemeData()),
            // Display Current Location Weather Widget
            _buildDecoratedWidget(
                _buildCurrentLocationWeatherWidget(), ThemeData()),
            // Display Hourly Weather Forecast Graph
            _buildDecoratedWidget(
                _buildHourlyWeatherForecastGraph(), ThemeData()),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container();
  }

  Widget _buildDecoratedWidget(Widget child, ThemeData themeData) {
    final Color backgroundColor = themeData.scaffoldBackgroundColor;
    final Color textColor = themeData.textTheme.bodyMedium!.color!;
    final Color borderColor = themeData.primaryColor;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Theme(
        data: themeData,
        child: child,
      ),
    );
  }

  Widget _buildCurrentLocationWeatherWidget() {
    // Implement your UI for displaying current location weather here
    // You can use _currentPosition.latitude and _currentPosition.longitude to fetch weather data
    return Container(
        // Your UI components here
        );
  }

  Widget _buildHourlyWeatherForecastGraph() {
    // Implement your UI for hourly weather forecast graph here
    return Container(
        // Your UI components here
        );
  }
}
