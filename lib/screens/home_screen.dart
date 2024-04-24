// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stormly/consts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stormly/models/weather_model.dart';
import 'package:stormly/service/weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // import api key from consts from lib
  final _weatherService = WeatherService(OPENWEATHER_API_KEY);
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
    // initial state of weather fetch
    _getCurrentLocation();
    _fetchWeather();
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Fetch weather data
  _fetchWeather() async {
    // Get the current city
    String cityName = await _weatherService.getCurrentCity();
    try {
      // Fetch weather for the current city
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Get weather animation based on condition
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/sunnycloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/windy.json';
      case 'fog':
        return 'assets/cloudy(night).json';
      case 'rain':
        return 'assets/storm&showers(day).json';
      case 'drizzle':
        return 'assets/rainy(night).json';
      case 'shower rain':
        return 'assets/partlyshower.json';
      case 'thunderstorm':
        return 'assets/storm&showers(day).json';
      case 'clear':
        return 'assets/sunnylightcloudy.json';
      default:
        return 'assets/sunnycloudy.json';
    }
  }

  // Determine background image based on time of day
  String getBackgroundImage() {
    var hour = DateTime.now().hour;
    return hour >= 6 && hour < 18
        ? 'assets/images/background.png'
        : 'assets/images/background2.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Make app bar transparent with no elevation
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            getBackgroundImage(),
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: kToolbarHeight),
                // Welcome Text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'My ',
                        style: GoogleFonts.permanentMarker(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700, // Set "My" to dark blue
                        ),
                      ),
                      TextSpan(
                        text: 'Location',
                        style: GoogleFonts.permanentMarker(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set "Location" to white
                        ),
                      ),
                    ],
                  ),
                ),
                // Other widgets here...
                _buildDecoratedWidget(
                  Column(
                    children: [
                      // City name
                      Text(
                        _weather?.cityName ?? "loading city...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Animation weather phenomenon
                      if (_weather?.mainCondition != null)
                        Lottie.asset(getWeatherAnimation(_weather!.mainCondition)),
                      // Temperature
                      Text(
                        _weather?.temperature != null
                          ? '${(_weather!.temperature.round() * 1.8 + 32).round()}°F'
                          : 'loading temp...',  // Placeholder text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Condition weather phenomenon
                      Text(
                        _weather?.mainCondition ?? "",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ThemeData(),
                ),
                // Hourly Weather Forecast Graph
                _buildHourlyWeatherForecastGraph(),
                // ...other widgets
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for decorating a child widget with background and border
  Widget _buildDecoratedWidget(Widget child, ThemeData themeData) {
    final Color backgroundColor = themeData.scaffoldBackgroundColor.withAlpha(230);
    final Color borderColor = themeData.primaryColor;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  // Get weather icon based on phenomenon
  IconData getWeatherIcon(String phenomenon) {
    return Icons.wb_sunny; // Placeholder icon
  }

  // Widget for hourly weather forecast graph
  Widget _buildHourlyWeatherForecastGraph() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 150, // Adjust the height as needed
      color: Colors.white.withAlpha(200), // Slightly transparent white color
      child: Center(
        child: Text(
          'Hourly Forecast Graph Placeholder',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
