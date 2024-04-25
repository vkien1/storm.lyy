// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormly/consts.dart';

// Import the Weather API utility
import 'package:geolocator/geolocator.dart';
import 'package:stormly/models/weather_model.dart';
import 'package:stormly/service/weather_service.dart';

class SecondScreen extends StatefulWidget {
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  // import api key from conts from lib
  final _weatherSevice = WeatherService(OPENWEATHER_API_KEY);
  MyWeather? _weather;
  TextEditingController _cityController = TextEditingController();
  String _savedCityNameOne = '';
  bool _isLoading = true;

  Position? _currentPosition;

  // int _currentPageIndex = 0;
  // void _setPageIndex(int index) {
  //   setState(() {
  //     _currentPageIndex = index;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // inital state of weather fetch
    _loadWeatherData();

    // _getCurrentLocation
    // _fetchWeather();
  }

  void _loadWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCity = prefs.getString('savedCity');
    if (savedCity != null) {
      setState(() {
        _savedCityNameOne = savedCity;
      });
      _fetchWeatherByCity(savedCity);
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
  Future<void> _fetchWeather(double latitude, double longitude) async {
    //TODO modify to set current city instead of retriving what city we are at
    String cityName = await _weatherSevice.getCurrentCity();

    // get weather
    try {
      final weather =
          await _weatherSevice.getWeatherByLocation(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    }
    // error catcher casue ill know ill mess up lol , like alawys
    catch (e) {
      print(e);
    }
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final weather = await _weatherSevice.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });

      // saved the city for future use
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('savedCity', cityName);
    } catch (e) {
      print(e);
    }
    setState(() {
      _savedCityNameOne = cityName;
      _isLoading = false;
    });
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

=======
import 'package:flutter/services.dart';

class SecondScreen extends StatelessWidget {
  // Determine background image based on time of day
  String getBackgroundImage() {
    var hour = DateTime.now().hour;
    return hour >= 6 && hour < 18 ? 'assets/images/background.png' : 'assets/images/background2.png';
  }

>>>>>>> main
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: Text('Storm.lyy: $_savedCityNameOne'),
      ),
      body: SingleChildScrollView(
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
                            Lottie.asset(
                                getWeatherAnimation(_weather!.mainCondition)),
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
                    : Container(), // Weather Details
            // 5 day forecast
            Text(
              "This week's weather phenomenon",
=======
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
              'Welcome to the Second Screen!',
>>>>>>> main
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
<<<<<<< HEAD
            // Display Hourly Weather Forecast Graph
            _buildDecoratedWidget(
              _buildHourlyWeatherForecastGraph(),
              ThemeData(),
            ),
          ],
        ),
=======
          ),
        ],
>>>>>>> main
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
