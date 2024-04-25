// ignore_for_file: file_names

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:stormly/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // api url to openweather api 1st one is the latest from website, 2nd is old
  // link from research
  // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
  // http://api.openweathermap.org/data/2.5/weather

  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<MyWeather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return MyWeather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<MyWeather> getWeatherByLocation(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return MyWeather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();
    // LocationPermission permission = await Geolocator.checkPermission();

    // permission from user
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert the location into list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract city name from the first placemarker
    String? city = placemarks[0].locality;
    return city ?? "";
  }

  Future<dynamic> get5DayForecast(double lat, double lon) async {
    String url =
        'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //If the server returns a 200 OK response, parse the JSON
      return json.decode(response.body);
    } else {
      // if server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load forecast');
    }
  }

  // Method to parse forecast data into list of MyWeather objects
  List<MyWeather> _parseForecast(dynamic forecastData) {
    List<MyWeather> forecastList = [];

    // Extract forecast list from JSON data
    List<dynamic> forecastItems = forecastData['list'];

    // Iterate through each forecast item
    for (var item in forecastItems) {
      // Extract relevant information
      int timestamp = item['dt'];
      double temperature = item['main']['temp'];
      // double feelsLike = item['main']['feels_like'];
      // double tempMin = item['main']['temp_min'];
      // double tempMax = item['main']['temp_max'];
      // int humidity = item['main']['humidity'];
      String mainCondition = item['weather'][0]['main'];

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

      // Create a MyWeather object and add it to the forecast list
      MyWeather weather = MyWeather(
        time: dateTime,
        temperature: temperature,
        // feelsLike: feelsLike,

        mainCondition: mainCondition, cityName: '',
      );
      forecastList.add(weather);
    }

    return forecastList;
  }
}
