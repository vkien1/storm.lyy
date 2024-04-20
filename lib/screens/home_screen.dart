// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stormly/consts.dart';
import 'package:stormly/models/weather_model.dart';
import 'package:stormly/service/weather_service.dart';
// Import the Weather API utility

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // import api key from conts from lib
  final _weatherSevice = WeatherService(OPENWEATHER_API_KEY);
  MyWeather? _weather;

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

    // inital sate of weather fetch
    _getCurrentLocation();
    _fetchWeather();
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

  // fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherSevice.getCurrentCity();

    // get weather
    try {
      final weather = await _weatherSevice.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // error catcher casue ill know ill mess up lol , like alawys
    catch (e) {
      print(e);
    }
  }
  //weather animations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Display Current Location Weather Widget
            _buildDecoratedWidget(
              Column(
                children: [
                  // City name
                  Text(
                    _weather?.cityName ?? "loading city..",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Temperature
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ThemeData(),
            ),
            // Display Hourly Weather Forecast Graph
            _buildDecoratedWidget(
              _buildHourlyWeatherForecastGraph(),
              ThemeData(),
            ),
          ],
        ),
      ),
    );
  }
  // ignore: camel_case_types

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

  // Function to get the appropriate weather icon based on the weather phenomenon
  IconData getWeatherIcon(String phenomenon) {
    // You can define your own logic to map weather phenomenon to icons
    // For demonstration purposes, I'm returning a generic weather icon
    return Icons.wb_sunny;
  }

  Widget _buildHourlyWeatherForecastGraph() {
    // Implement your UI for hourly weather forecast graph here
    return Container(
        // Your UI components here
        );
  }
}
