// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, unused_field

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
  List<MyWeather>? _forecast;

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

    if (_currentPosition != null) {
      double lat = _currentPosition!.latitude;
      double lon = _currentPosition!.longitude;

      try {
        final forecast = await _weatherService.get5DayForecast(lat, lon);
        //Handle forecast data
        setState(() {
          // Pass the forecast data to _buildWForecast
          _forecast = _parseForecast(forecast); // Add this line
        });
      } catch (e) {
        print(e);
      }
    }
  }

  List<MyWeather> _parseForecast(dynamic forecastData) {
    List<MyWeather> forecastList = [];

    // Extract forecast list from JSON data
    List<dynamic> forecastItems = forecastData['list'];

    // Iterate through each forecast item
    for (var item in forecastItems) {
      // Extract relevant information
      int timestamp = item['dt'];
      double temperature = item['main']['temp'];
      String mainCondition = item['weather'][0]['main'];
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

      // Extract hourly time (format: HH:00)
      String hourlyTime = '${dateTime.hour.toString().padLeft(2, '0')}:00';

      // Extract current date and month (format: DD/MM)
      String dateMonth =
          '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';

      // Combine hourly time and date/month into a single string
      String formattedTime = '$hourlyTime, $dateMonth';

      // Create a MyWeather object and add it to the forecast list
      MyWeather weather = MyWeather(
        time: formattedTime,
        temperature: temperature,
        mainCondition: mainCondition,
        cityName: '',
      );
      forecastList.add(weather);
    }

    return forecastList;
  }

  // String _formatTime(String timeString) {
  //   // Parse the time string to DateTime object
  //   DateTime dateTime = DateTime.parse(timeString);

  //   // Extract hourly time (format: HH:00)
  //   String hourlyTime = '${dateTime.hour.toString().padLeft(2, '0')}:00';

  //   // Extract current date and month (format: DD/MM)
  //   String dateMonth =
  //       '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';

  //   return '$hourlyTime, $dateMonth';
  // }

  // Determine background image based on time of day
  String getBackgroundImage() {
    var hour = DateTime.now().hour;
    return hour >= 6 && hour < 18
        ? 'assets/images/background.png'
        : 'assets/images/background2.png';
  }

  // TEMP assets
  // Add this method to handle the weather icon based on the condition
  Widget _buildWeatherIcon(String condition) {
    return Icon(
      getWeatherIcon(condition),
      size: 40,
      color: Colors.blue,
    );
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
                        Lottie.asset(
                            getWeatherAnimation(_weather!.mainCondition)),
                      // Temperature
                      Text(
                        _weather?.temperature != null
                            ? '${(_weather!.temperature.round() * 1.8 + 32).round()}°F'
                            : 'loading temp...', // Placeholder text
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
                // Add the provided text widgets here
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '5Day ',
                        style: GoogleFonts.permanentMarker(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(
                              255, 53, 53, 53), // Set "My" to dark blue
                        ),
                      ),
                      TextSpan(
                        text: 'Forecast',
                        style: GoogleFonts.permanentMarker(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(
                              255, 140, 140, 140), // Set "Location" to white
                        ),
                      ),
                    ],
                  ),
                ),

                // Hourly Weather Forecast Graph
                _buildDecoratedWidget(
                  _forecast != null
                      ? Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _forecast!.length,
                            itemBuilder: (context, index) {
                              final weather = _forecast![index];
                              return Container(
                                width:
                                    120, // Adjust the width of each forecast box
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // Assuming weather.time is the time of the forecast
                                      weather.time,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Implement assets for weather animations from lollite
                                    SizedBox(height: 10),
                                    _buildWeatherIcon(weather.mainCondition),
                                    SizedBox(height: 10),
                                    Text(
                                      // Assuming weather.temperature is the temperature of the forecast in Kelvin
                                      '${(weather.temperature - 273.15).toStringAsFixed(2)}°C',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : CircularProgressIndicator(), // Show loading indicator if forecast is null
                  ThemeData(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for decorating a child widget with background and border
  Widget _buildDecoratedWidget(Widget child, ThemeData themeData) {
    final Color backgroundColor =
        themeData.scaffoldBackgroundColor.withAlpha(230);
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
}
