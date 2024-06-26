// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormly/consts.dart';

// Import the Weather API utility
import 'package:geolocator/geolocator.dart';
import 'package:stormly/models/weather_model.dart';
import 'package:stormly/service/weather_service.dart';

class ThirdScreen extends StatefulWidget {
  final String
      cityName1; // Add cityName as a parameter to the SecondScreen constructor

  ThirdScreen(
      {super.key,
      required this.cityName1}); // Constructor with required parameter

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  // import api key from conts from lib
  final _weatherSevice = WeatherService(OPENWEATHER_API_KEY);
  final TextEditingController _cityController = TextEditingController();
  MyWeather? _weather;
  // String _cityName = _cityName;
  bool _isLoading = true;

  Position? _currentPosition;

  int _currentPageIndex = 0;
  void _setPageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // inital state of weather fetch
    _loadWeatherData();
  }

  void _loadWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCity = prefs.getString('savedCity3');
    if (savedCity != null) {
      _fetchWeatherByCity(savedCity);
      _cityController.text = savedCity;
    }
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     _fetchWeather(position.latitude, position.longitude);
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // fetch weather

  Future<void> _fetchWeatherByCity(String cityName1) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final weather = await _weatherSevice.getWeather(cityName1);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });

      // saved the city for future use
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('savedCity3', cityName1);
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    //defualt native to sunny
    if (mainCondition == null) return 'assets/sunny.json';
    // TODO
    // refractor with better animations for cases
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/sunnycloudy.json';
      case 'mist':
        return 'assets/windy.json';
      case 'smoke':
        return 'assets/windy.json';
      case 'haze':
        return 'assets/windy.json';
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
        return 'assets/sunny.json';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      appBar: AppBar(
        title: Text('Storm.lyy: ${widget.cityName1}'),
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
                // City Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter City Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Search Button
                ElevatedButton(
                  onPressed: () {
                    _fetchWeatherByCity(_cityController.text);
                  },
                  child: Text('Search'),
                ),
                SizedBox(height: 20),
                // Weather Details or Loading Widget
                _isLoading
                    ? CircularProgressIndicator() // Loading Widget
                    : _weather != null
                        ? _buildDecoratedWidget(
                            Column(
                              children: [
                                Text(
                                  _weather!.cityName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Lottie.asset(getWeatherAnimation(
                                    _weather!.mainCondition)),
                                Text(
                                  '${_weather!.temperature.round()}°C',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _weather!.mainCondition,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ThemeData(),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
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

  Widget _buildHourlyWeatherForecastGraph() {
    // Implement your UI for hourly weather forecast graph here
    return Container(
        // Your UI components here
        );
  }
}
